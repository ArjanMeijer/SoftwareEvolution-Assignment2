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


// To run this application from the console you should use this command:
//		java -Xmx1G -Xss32m -jar libs/rascal-shell-stable.jar Main.rsc 0 1 C:/user/meije/test.txt
// This command assumes the .jar file is placed in the right folder.

// Args input:
// 	0) Type of clone, [0,1,2]
//  1) [0] Small Project, [1] Large project
//  2) Output file location
public void main(list[str] args) {
	println("Clone Detector by Arjan Meijer and Niels Boerkamp");
	DetectClones(0,1,|home:///henk|);
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

private void RunDetection(list[list[str]] input){
	map[str,int] index = ();
	map[int, str] rIndex = ();
	map[tuple[int,int],loc] locIndex = ();
	list[int] values = [];
	
	for(int i <- [0 .. size(input)])
		for(int j <- [0 .. size(input[i])]){
			if(input[i][j] notin index){
				index += (input[i][j]:size(index));
				rIndex += (index[input[i][j]]:input[i][j]);
			}
			values += index[input[i][j]];
		}
	println("Finished reading");
	NewSuffixTree(values);
	//NodeList strie = // CreateUkkonen(values, input, rIndex);
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
		RunDetection([res]);
	};
}

private void DetectClones(int cloneType, int projectID, loc outputFile)
{
	//loc project = [|project://smallsql0.21_src|,|project://hsqldb-2.3.1|][projectID];
	BFTest(9999999, 10);
	//9zh84h8vr5t1n6f8bz8j0jg7cvlgsvmos1djs33r4qfhqhb8sl
	//RunDetection([split("","yk97y78e50cihio$")]);
	//RunDetection([split("","wxabwxcwxa$")]);
	//RunDetection([split("","pjpaxrpjp7$")]);
	//list[list[str]] input = [[trim(x) | x <- readFileLines(|project://CloneDetector/src/Test/TestFiles/testFile.java|)]] + [["$"]];	
	//RunDetection(GetAllLines(project));
	
	//STUkkonen ukkonen = NewUkkonen();
	/*list[int] vals = [0,1,2]; // abc
	put("c", 0);
	println(NodeIndex);*/
	//text(NewSuffixTree("cacaou"));
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


//{
//  "files" : ["file1.java", "file2.java", "..."],
//  "occurences" : [[1, 10, 20], [] ], 
//  "classes" : [[0,1], [1,2]]
//}
//
//class
//  file1 en file2
//  [0, start clone, end clone], [1, start clone, end clone]



