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

map[int, list[tuple[list[STEdge], tuple[str, int]]]] CloneClasses = (); 	
map[int, list[str]] CloneText = ();

lrel[int, loc] fileIndex = [];
list[int] values = [];

public void ExportToJSON(Edges edges, map[int, str] rIndex, list[int] values, lrel[int, loc] _fileIndex) {
	
	//Assign the local fileIndex and values to the global variables. Also sort the fileIndex.
	fileIndex = sort(_fileIndex, bool (tuple[int, loc] a, tuple[int, loc] b){ return a[0] < b[0]; });
	values = values;
	
	text(fileIndex);

	// Get all the clone classes.
	println("Searching for clones ... ");
	CollectClones(edges);
	
	// Get text per cloneclass.
	println("Get code by clone ...");
	for(key <- CloneClasses)
		CloneText += (key:CloneToText(CloneClasses[key], rIndex, values));
	
	//text(CloneText);
	//text(CloneClasses);
	
	//println(ToString(CloneClasses));
	
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

public list[str] CloneToText(list[tuple[list[STEdge], tuple[str, int]]] clones, map[int, str] rIndex, list[int] values) {
	list[str] result = [""];
	
	list[STEdge] smallestSubTree = [];
	int smallestSize = 9999999999;
	for(tuple[list[STEdge], tuple[str, int]] clone <- clones) {
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
	text(rIndex);
	return result;
}


public void CollectClonesHelper(Edges edges, int saveToID, list[STEdge] prev, int current = 0) {	
	for(int key <- edges[current]) {
		if(edges[current][key].destNodeIndex in edges) {
			list[STEdge] p = prev;
			CollectClonesHelper(edges, saveToID, p + edges[current][key], current = edges[current][key].destNodeIndex);
		} else {
			//println("Save to: <saveToID>");
			list[STEdge] listToSave = prev + edges[current][key];
			
			//println(prev);
			if(GetLengthFromRoot(prev) > MIN_CLONE_LENGTH) {
				SaveClass(saveToID, listToSave);
			};
		};
	};
}


public void SaveClass(int saveToID, list[STEdge] edges) {

	STEdge leafNode = edges[size(edges) - 1];
	tuple[int, loc] file = GetFile(leafNode);

	if(saveToID notin CloneClasses)
		CloneClasses += (saveToID: [<edges, <file[1].path, file[0]>>]);
	else
		CloneClasses[saveToID] += [<edges, <file[1].path, file[0]>>];
}

public int GetLengthFromRoot(list[STEdge] edges) {
	return sum([GetLength(x) + 1 | x <- edges]);
}

public tuple[int, loc] GetFile(STEdge e) {
	tuple[int, loc] previousKey = fileIndex[0];
	for(tuple[int, loc] tupl <- fileIndex) {		
		if(e.firstCharIndex < tupl[0]) {
			//println("<e.firstCharIndex> \< <tupl[0]>");
			break;
		}
		previousKey = tupl;		
	}
	
	return previousKey;
}

public void ToJSON(map[int, list[tuple[list[STEdge], tuple[str, int]]]] cloneclasses) {
	writeFile(|home:///input.js|, "<ToString(cloneclasses)>;");
	
	println("File written to: |home:///input.js|");
}

/*
	Get the first and last line of the clone. This can be calculated 
	by summing the number of lines from each node and subtract it 
	from the last one.
*/
public tuple[int, int] GetMinMax(list[STEdge] clone, int startLine) {
	STEdge occurence = clone[size(clone) - 1];
	
	int length = GetLengthFromRoot(clone[0..size(clone) - 1]) ;
	//println("Subtract <length> from <occurence>");
	
	//occurence.lastCharIndex - 
	return <occurence.firstCharIndex - startLine, occurence.firstCharIndex - startLine + length>;
}

public str CloneToString(tuple[list[STEdge], tuple[str, int]] clone) {
	tuple[int, int] minmax = GetMinMax(clone[0], clone[1][1]);
	return "[<minmax[0]>, <minmax[1]>, \"<clone[1][0]>\"]";
}

public str CloneClassToString(int id, list[tuple[list[STEdge], tuple[str, int]]] cloneclass) {
	
	//CloneText[id];
	str result = "\"occurences\": [";
	
	for(tuple[list[STEdge], tuple[str, int]] x <- cloneclass) {
		result += "<CloneToString(x)>, ";
	};
	
	result += "], \"code\":  <CloneText[id]>";
	
	return result;
}

public str ToString(map[int, list[tuple[list[STEdge], tuple[str, int]]]] cloneclasses) {

	str result = "var RascalResult = [";

	for(int key <- cloneclasses) {
		result += "{";
		result += CloneClassToString(key, cloneclasses[key]) + "," ;
		result += "} ,";
	}
	result += "]";
	return result;
}



//public str CloneToText(list[[int, int, int]] clone, NodeList nodes, map[int,str] rIndex, list[int] values) {
//	println("Clone <clone>");
//	str cloneText = "";
////	list[str] p = [rIndex[values[x]] | x <- [n[key][0] .. n[key][1] == -1 ? currentEnd + 1 : n[key][0] + n[key][1]]];
//	
//	for(c <- clone) {
//		//println(nodes[c][0]);
//		
//		bool first = true;
//		for(i <- nodes[c][0]){
//			if(first){
//				println(nodes[c][0][i]);
//				first = false;
//			}
//		};
//		println("Break to here");
//	};
//	
//	return cloneText;
//}
//
//public set[list[tuple[int, int, int]]] GetClones(NodeList nodes) {
//
//	// Reset AllPaths
//	AllPaths = {};
//	
//	// This function will add to AllPaths recursively. 
//	FindPaths(nodes[0][0], nodes);
//	
//	return AllPaths;
//}
//
//
//private void FindPaths(NodeIndex n, NodeList l, list[tuple[int, int, int]] prev = [<0, 0, 0>]){
//	for(int key <- n){
//		if(n[key][2] >= 0)
//			FindPaths(l[n[key][2]][0], l, prev = prev + [n[key]]);
//		else if (prev != [<0,0,0>])
//			AllPaths += prev;
//	};
//}

//
//
//public bool HasNext(NodeIndex n) {
//	for(key <- n){
//		if(n[key][2] != -2)
//			return true;
//	};
//	return false;
//}


//	//for(int key <- tree[n])
//	//{
//	//	list[str] p = [rIndex[values[x]] | x <- [tree[n][key].firstCharIndex .. tree[n][key].lastCharIndex + 1]];
//	//	if(tree[n][key].destNodeIndex in tree){
//	//		PrintTree(tree, rIndex, values, n = tree[n][key].destNodeIndex, prev = prev + p + ["-"]);
//	//	} else {
//	//		println(prev + p);
//	//	};
//	//};
//	
//	list[STEdge] cloneClasses = GetCloneClasses(edges);
//	
//
//	//for (STEdge clone <- cloneClasses) {
//	//	if(true /* heeft ie child*/) {
//	//	
//	//	
//	//	} else if(GetLength(clone) > 6) {
//	//	
//	//		println();
//	//	}
//	//}
//}