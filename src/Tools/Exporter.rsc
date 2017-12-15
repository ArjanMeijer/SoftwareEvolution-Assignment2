module Tools::Exporter

import util::ValueUI;
import IO;
import Set;

import Nodes;

set[list[tuple[int, int, int]]] AllPaths = {};

public void ExportToJSON(NodeList nodes, map[int,str] rIndex, list[int] values){
	text(nodes);
	list[list[tuple[int,int,int]]] clones = toList(GetClones(nodes));
	
	println(AllPaths);
	
	CloneToText(clones[1], nodes, rIndex, values);
}

public str CloneToText(list[[int, int, int]] clone, NodeList nodes, map[int,str] rIndex, list[int] values) {
	println("Clone <clone>");
	str cloneText = "";
//	list[str] p = [rIndex[values[x]] | x <- [n[key][0] .. n[key][1] == -1 ? currentEnd + 1 : n[key][0] + n[key][1]]];
	
	for(c <- clone) {
		//println(nodes[c][0]);
		
		bool first = true;
		for(i <- nodes[c][0]){
			if(first){
				println(nodes[c][0][i]);
				first = false;
			}
		};
		println("Break to here");
	};
	
	return cloneText;
}

public set[list[tuple[int, int, int]]] GetClones(NodeList nodes) {

	// Reset AllPaths
	AllPaths = {};
	
	// This function will add to AllPaths recursively. 
	FindPaths(nodes[0][0], nodes);
	
	return AllPaths;
}


private void FindPaths(NodeIndex n, NodeList l, list[tuple[int, int, int]] prev = [<0, 0, 0>]){
	for(int key <- n){
		if(n[key][2] >= 0)
			FindPaths(l[n[key][2]][0], l, prev = prev + [n[key]]);
		else if (prev != [<0,0,0>])
			AllPaths += prev;
	};
}

//
//
//public bool HasNext(NodeIndex n) {
//	for(key <- n){
//		if(n[key][2] != -2)
//			return true;
//	};
//	return false;
//}