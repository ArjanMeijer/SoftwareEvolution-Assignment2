module Tools::Exporter

import util::ValueUI;
import IO;
import Set;
import List;

import Ukkonen::STEdge;

alias Edges = map[int, map[int, STEdge]];

//list[list[STEdge]] AllPaths = {}; // AllPaths[0]
//list[list[]] LeafNodes; 				//  LeafNodes[0]

int MIN_CLONE_LENGTH = 10;

map[int, list[tuple[list[STEdge], tuple[str, list[int]]]]] CloneClasses = (); 	
map[int, list[str]] CloneText = ();

map[int,tuple[int,loc]] fileIndex = ();
list[int] values = [];

public void ExportToJSON(Edges edges, map[int, str] rIndex, list[int] values, map[int,tuple[int,loc]] _fileIndex) {
	
	//Assign the local fileIndex and values to the global variables. Also sort the fileIndex.
	//fileIndex = sort(_fileIndex, bool (tuple[int, loc] a, tuple[int, loc] b){ return a[0] < b[0]; });
	fileIndex = _fileIndex;
	values = values;

	// Get all the clone classes.
	println("Searching for clones ... ");
	CollectClones(edges);
	
	// Get text per cloneclass.
	println("Get code by clone ...");
	for(key <- CloneClasses)
		CloneText += (key:CloneToText(CloneClasses[key], rIndex, values));
	
	println("Writing results to file ... ");
	ToJSON(CloneClasses);
}


public void CollectClones(Edges edges) {
	// Reset clone classes
	CloneClasses = ();
	
	// Go recusively over the tree to get all the clone classes.
	for(int key <- edges[0])
		if(edges[0][key].destNodeIndex in edges) 
			CollectClonesHelper(edges, key, [edges[0][key]], current = edges[0][key].destNodeIndex);
} 

public list[str] CloneToText(list[tuple[list[STEdge], tuple[str, list[int]]]] clones, map[int, str] rIndex, list[int] values) {
	list[str] result = [""];
	
	list[STEdge] smallestSubTree = [];
	int smallestSize = 9999999999;
	for(tuple[list[STEdge], tuple[str, list[int]]] clone <- clones) {
		int cloneLength = GetLengthFromRoot(clone[0][0..size(clone[0])-1]);
		if(cloneLength < smallestSize) {
			smallestSubTree = clone[0];
			smallestSize = cloneLength;
		}
	}
	
	for(int x <- [0..size(smallestSubTree) - 1]) {
		STEdge e = smallestSubTree[x];
		for(i <- [e.firstCharIndex..e.lastCharIndex+1]){
			result += rIndex[values[i]];
		};
	};

	return result;
}


public void CollectClonesHelper(Edges edges, int saveToID, list[STEdge] prev, int current = 0) {	
	for(int key <- edges[current]) {
		if(edges[current][key].destNodeIndex in edges) {
			list[STEdge] p = prev;
			CollectClonesHelper(edges, saveToID, p + edges[current][key], current = edges[current][key].destNodeIndex);
		} else {
			list[STEdge] listToSave = prev + edges[current][key];
			
			if(GetLengthFromRoot(prev) > MIN_CLONE_LENGTH) {
				SaveClass(saveToID, listToSave);
			};
		};
	};
}


public void SaveClass(int saveToID, list[STEdge] edges) {

	STEdge leafNode = edges[size(edges) - 1];
	list[int] lineNumbers = [fileIndex[x][0] | x <- [leafNode.firstCharIndex .. leafNode.lastCharIndex + 1]];
	str file = fileIndex[leafNode.firstCharIndex][1].path;
	if(saveToID notin CloneClasses)
		CloneClasses += (saveToID: [<edges, <file, lineNumbers>>]);
	else
		CloneClasses[saveToID] += [<edges, <file, lineNumbers>>];
}

public int GetLengthFromRoot(list[STEdge] edges) {
	return sum([GetLength(x) + 1 | x <- edges]);
}

public void ToJSON(map[int, list[tuple[list[STEdge], tuple[str, list[int]]]]] cloneclasses) {
	writeFile(|home:///input.js|, "<ToString(cloneclasses)>;");
	
	println("File written to: |home:///input.js|");
}

public str CloneToString(tuple[list[STEdge], tuple[str, list[int]]] clone) {
	int length = GetLengthFromRoot(clone[0][0..size(clone[0]) - 1]) ;
	return "[<clone[1][1][0] - length - 1>, <length>, \"<clone[1][0]>\"]";
}

public str CloneClassToString(int id, list[tuple[list[STEdge], tuple[str, list[int]]]] cloneclass) {
	
	str result = "\"occurences\": [";
	
	for(tuple[list[STEdge], tuple[str, list[int]]] x <- cloneclass) {
		result += "<CloneToString(x)>, ";
	};
	
	result += "], \"code\":  <CloneText[id]>";
	
	return result;
}

public str ToString(map[int, list[tuple[list[STEdge], tuple[str, list[int]]]]] cloneclasses) {

	str result = "var RascalResult = [";

	for(int key <- cloneclasses) {
		result += "{";
		result += CloneClassToString(key, cloneclasses[key]) + "," ;
		result += "} ,";
	}
	result += "]";
	return result;
}