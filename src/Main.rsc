module Main

import IO;					// Println
import List; 				// indexOf
import String; 				// toLocation
import Exception;			// Try Catch
import util::ValueUI;

import STrie;
import Ukkonen;
import Map;
import Tools::Reader;
import Tools::CodeParser;
import Nodes;
import util::Math;

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

private void DetectClones(int cloneType, int projectID, loc outputFile)
{
	loc project = [|project://smallsql0.21_src|,|project://hsqldb-2.3.1|][projectID];
	//CreateTrie("abcabxabcd");
	//println("Detected clones!");
	//CreateUkkonen("abcabxabcd");

	//list[list[str]] input = GetAllLines(project) + [["$"]];
	
	/*list[str] alph = split("","abcdefghijklmnopqrstuvwxyz1234567890");
	for(x <- [0..4000]){
		list[str] res = [];
		for(i <- [0..30]){
			res += [alph[arbInt(size(alph))]];
		};
		res += "$";
		for(str s <- res)
			print(s);
		println("");
		list[list[str]] input = [res];*/
		list[list[str]] input = [split("","okgf2oaq3zihmj8k8oo7sokz3i98za$")];
		
		map[str,int] index = ();
		map[int, str] rIndex = ();
		map[tuple[int,int],loc] locIndex = ();
		list[int] values = [];
			
		//list[str] input = readFileLines(testFile);
		//list[list[str]] input = [["a","b","c","a","b","x","a","b","c","d"]];
		//
		//input = [RemoveComments(x) | x <- input];
		//list[list[str]] input = [["a","b","c","d","e","f","g","h","i","j","a","b","c","d","e","f","g","i","k","a","b","c","d","e","f","g","h","i","l","i"]];
		//list[list[str]] input = [split("","ababcdefghijklmnop$")];//fgkg
		//list[list[str]] input = [[trim(x) | x <- readFileLines(|project://CloneDetector/src/Test/TestFiles/testFile.java|)]] + [["$"]];
		for(int i <- [0 .. size(input)])
			for(int j <- [0 .. size(input[i])]){
				if(input[i][j] notin index){
					index += (input[i][j]:size(index));
					rIndex += (index[input[i][j]]:input[i][j]);
				}
				values += index[input[i][j]];
			}
		//println(rIndex[values[25115]]);
		//println("Finished reading");
		//println("Do stuff!");
		//values += 999;
		NodeList strie = CreateUkkonen(values, input, rIndex);
		//PrintPaths(values, rIndex, strie[0][0], strie);
 	//};
	
	//text(strie);
	/*for(tuple[NodeIndex,int] n <- strie){
		println(n[0]);
		println("\n");
	};	
	*/
	
	/*list[list[int]] vals = PrintNode(values, strie[0][0]);
	list[str] conv = ["0","1","2","3","4","5", "6", "7", "8", "9","a","b","c","d"];
	println([conv[x] | x <- values]);
	for(list[int] v <- vals){
		println([conv[x] | x <- v]);
		println("\n");
	};*/
	//println(strie);
	//println(values);
	//NodeIndex root = strie[0][0];
	
	//println(strie[0]);
	//for(tuple[NodeIndex,int] n <- strie)
	//	println(PrintNode(input, n[0]));	
	
	//WalkTree(strie, input[0], 0);	
	
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



