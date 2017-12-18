module Main

import IO;					// Println
import List; 				// indexOf
import String; 				// toLocation
import Exception;			// Try Catch
import util::ValueUI;
import util::Math;

//import STrie;
//import Ukkonen_scr;
//import QTest;
import Map;
import Tools::Reader;
import Tools::CodeParser;
import Nodes;
import Tools::Exporter;
import util::Math;
//import FromJava::STUkkonen;
//import FromJava::STNode;
import FromPython::STSuffixTree;
import FromPython::STEdge;
import util::Eval;


// To run this application from the console you should use this command:
//		java -Xmx1G -Xss32m -jar libs/rascal-shell-stable.jar Main.rsc 0 1 C:/user/meije/test.txt
// This command assumes the .jar file is placed in the right folder.

// Args input:
// 	0) Type of clone, [0,1,2]
//  1) [0] Small Project, [1] Large project
//  2) Output file location
public void main(list[str] args) {
	println("Clone Detector by Arjan Meijer and Niels Boerkamp");
	DetectClones(0,0,|home:///henk|);
	/*	
	bool isValidInput = true;
	if(size(args) == 3){
		int cloneType = indexOf(["0","1","2"], args[0]);
		int projectID = indexOf(["0","1"], args[1]);
		loc outputFile;
		
		try
			outputFile = toLocation("file:///<args[2]>");
		catch : isValidInput = false;
		
		if(cloneType != -1 && projectID != -1 && isValidInput)
			DetectClones(cloneType, projectID, outputFile);	
	} else {
		isValidInput = false;
	};
	
	if(!isValidInput){
		println("invalid input!");
	}*/
}

private map[int,map[int,STEdge]] RunDetection(tuple[list[list[str]], list[loc]] input, bool writeToFile = true){
	println("Parsing input");
	
	map[str,int] index = ();
	list[int] values = [];
	lrel[int, loc] fileIndex = [];
	int linesOfCode = 0;
	
	// Add closing character 
	list[list[str]] temp = input[0];
	temp[size(temp) - 1] += ["$"];
	input[0] = temp;
	
	for(int i <- [0 .. size(input[0])])
	{
		for(int j <- [0 .. size(input[0][i])]){
			if(input[0][i][j] notin index)
				index += (input[0][i][j]:size(index));
			values += index[input[0][i][j]];
		}
		linesOfCode += size(input[0][i]);
		fileIndex += <linesOfCode, input[1][i]>;
	}

	println("Finished parsing");
	
	// Write reverted index
	//if(writeToFile)
	//	WriteIndex((index[x]:x|x <- index));
	// Clear index
	//index = ();
	
	// Write fileindex
	//if(writeToFile)
	//	WriteFileIndex(fileIndex);
	
	// Clear index
	//fileIndex = ();
	
	// Create suffix tree
	println("Creating suffix tree");
	STSuffixTree tree = NewSuffixTree(values);
	
	// Start exporting
	println("Start analyzing");	
	ExportToJSON(tree.edges, (), values, fileIndex);
	
	// Only return the edges
	return tree.edges;
}

private void BFTest(int a, int l){
	list[str] alph = split("","abcdefghijklmnopqrstuvwxyz1234567890");
	for(x <- [0..a]){
		list[str] res = [];
		for(i <- [0..l]){
			res += [alph[arbInt(size(alph))]];
		};
		res += "$";
		str inp = "";
		for(str s <- res)
			inp += s;
		println("<inp>");
		RunDetection(<[res],[|temp:///NA|]>, writeToFile = false);
	};
}

private void PrintTree(map[int,map[int,STEdge]] tree, map[int, str] rIndex, list[int] values, int n = 0, list[str] prev = []){
	for(int key <- tree[n])
	{
		list[str] p = [rIndex[values[x]] | x <- [tree[n][key].firstCharIndex .. tree[n][key].lastCharIndex + 1]];
		if(tree[n][key].destNodeIndex in tree){
			PrintTree(tree, rIndex, values, n = tree[n][key].destNodeIndex, prev = prev + p + ["-"]);
		} else {
			println(prev + p);
		};
	};
}

private void DetectClones(int cloneType, int projectID, loc outputFile)
{
	loc project = [|project://smallsql0.21_src|,|project://hsqldb-2.3.1|][projectID];
	//BFTest(9999999, 50);
	 
	//RunDetection([split("","abcabxabcd$")]);
	RunDetection(GetAllLines(project));
	//RunDetection(<[split("", "abcabxabcd")], [|temp:///NA|]>, writeToFile=true);
}

private int PrintChar(str c){
	print(c);
	return 1;
}

public list[list[int]] PrintNode(list[int] input, NodeIndex n) { 
	list[list[int]] result = [];
	
	for(x <- n){
		int s = n[x][0];
		int e = n[x][1];
		if(e == -1)
			result += [[input[y]| y <- [s..size(input)]]];
		else
			result += [[input[y]| y <- [s..s+e]]];
	}
	
	return result;
}

public void WalkTree(NodeList strie, list[str] input, int nIndex) {
	for(int n <- strie[nIndex][0]) {
		print(input[n]);
		
		int childNodeID = strie[nIndex][0][n][2];
		if(childNodeID > 0)
			WalkTree(strie, input, childNodeID);	
	}
}


private void WriteIndex(map[int, str] index){
	writeFile(|tmp:///CDIndex.txt|, "<index>;");
}

private void WriteFileIndex(map[int,loc] index){
	writeFile(|tmp:///CDFileIndex.txt|,"<index>;");
}

private map[int,str] ReadIndex(){
	map[int,str] v;
	try{
		v = eval(readFile(|tmp:///CDIndex.txt|)).val;
	} catch: v = ();
	return v;
}

public list[tuple[int,loc]] ReadFileIndex(){
	lrel[int,loc] v;
	try{
		v = eval(readFile(|tmp:///CDFileIndex.txt|)).val;
			println("blah <v>");
	} catch: v = [];
	
	println(v);
	return v;
}

//{
//  "files" : ["file1.java", "file2.java", "..."],
//  "occurences" : [[1, 10, 20], [] ], 
//  "classes" : [[0,1], [1,2]]
//}
//
//class
//  file1 en file2
//  [0, start clone, end clone], [1, start clone, end clone]



