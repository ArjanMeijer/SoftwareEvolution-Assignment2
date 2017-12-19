module Main

import IO;					// Println
import List; 				// indexOf
import String; 				// toLocation
import Exception;			// Try Catch
import util::ValueUI;
import util::Math;


import Map;
import Tools::Reader;
import Tools::CodeParser;

import Tools::Exporter;
import util::Math;

import Ukkonen::STSuffixTree;
import Ukkonen::STEdge;
import util::Eval;


// To run this application from the console you should use this command:
//		java -Xmx1G -Xss32m -jar libs/rascal-shell-stable.jar Main.rsc 0
// This command assumes the .jar file is placed in the right folder.

// Args input:
// 	0) Type of clone, [0,1,2]
//  1) [0] Small Project, [1] Large project
//  2) Output file location
public void main(list[str] args) {
	println("Clone Detector by Arjan Meijer and Niels Boerkamp");
	if(size(args) == 1){
		int project = indexOf(["0","1"], args[0]);
		if(project != -1)
			DetectClones(project);	
	} else {
		println("invalid input!");
	}
}

private map[int,map[int,STEdge]] RunDetection(lrel[list[str], loc] input, bool writeToFile = true){
	println("Parsing input");
	
	map[str,int] index = ();
	list[int] values = [];
	lrel[int, loc] fileIndex = [];
	int linesOfCode = 0;
	
	// Add closing character 
	tuple[list[str],loc] temp = input[size(input) - 1];
	temp[0] = temp[0] + "$";
	input[size(input) -1] = temp;
	
	for(tuple[list[str], loc] i <- input){
		fileIndex += <linesOfCode, i[1]>;
		for(str line <- i[0]){
			linesOfCode += 1;
			if(line notin index)
				index += (line:size(index));
			values += index[line];
		};
	};
	
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
	ExportToJSON(tree.edges, (index[x]:x|x <- index), values, fileIndex);
	
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
		str inp = "";
		for(str s <- res)
			inp += s;
		println("<inp>");
		RunDetection([<res,|temp:///NA|>], writeToFile = false);
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

private void DetectClones(int projectID)
{
	loc project = [|project://smallsql0.21_src|,|project://hsqldb-2.3.1|][projectID];
	//BFTest(9999999, 50);
	 
	//RunDetection([split("","abcabxabcd$")]);
	RunDetection(GetAllLines(project));
	//RunDetection(<[split("", "abcabxabcd")], [|temp:///NA|]>, writeToFile=true);
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



