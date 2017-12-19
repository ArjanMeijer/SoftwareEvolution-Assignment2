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

public map[int,map[int,STEdge]] RunDetection(lrel[lrel[str,int], loc] input, bool testing = false){
	if(!testing)
		println("Parsing input");
	
	map[str,int] index = ();
	list[int] values = [];
	map[int,tuple[int,loc]] fileIndex = ();
	
	// Add closing character 
	tuple[lrel[str, int],loc] temp = input[size(input) - 1];
	temp[0] = temp[0] + <"$",-1>;
	input[size(input) -1] = temp;
	
	int counter = 0;
	for(tuple[lrel[str,int], loc] i <- input){
		for(tuple[str,int] line <- i[0]){
			if(line[0] notin index)
				index += (line[0]:size(index));
			values += index[line[0]];
			fileIndex += (counter:<line[1], i[1]>);
			counter += 1;
		};
	};
	
	if(!testing){
		println("Finished parsing");
		println("Creating suffix tree");
	}		
	// Create suffix tree
	STSuffixTree tree = NewSuffixTree(values);
	
	// Start exporting
	if(!testing) {
		println("Start analyzing");	
		ExportToJSON(tree.edges, (index[x]:x|x <- index), values, fileIndex);
	}
	// Only return the edges
	return tree.edges;
}

public void BFTest(int a, int l){
	list[str] alph = split("","abcdefghijklmnopqrstuvwxyz1234567890");
	for(x <- [0..a]){
		lrel[str, int] res = [];
		for(i <- [0..l]){
			res += [<alph[arbInt(size(alph))], i>];
		};

		RunDetection([<res,|temp:///NA|>], testing = true);
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
	RunDetection(GetAllLines(project));
}
