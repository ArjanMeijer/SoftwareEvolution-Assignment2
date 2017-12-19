/* 
	Implementation of the ukkonen algorithm
		STSuffixTree contains the data type of the tree
		and functions to construct the tree
	
	We used the implementation of Nils Diefenbach (python) and Mark Nelson (C++)
	for our rascal implementation.
	
	Sources:
		https://github.com/kvh/Python-Suffix-Tree/blob/master/suffix_tree.py	- Nils Diefenbach
		http://marknelson.us/1996/08/01/suffix-trees/							- Mark Nelson
*/

module Ukkonen::STSuffixTree

import Ukkonen::STNode;
import Ukkonen::STSuffix;
import Ukkonen::STEdge;
import String;
import List;
import Map;

data STSuffixTree = stSuffixTree(list[int] total, int n, list[STNode] nodes, map[int, map[int,STEdge]] edges, STSuffix active);

public STSuffixTree NewSuffixTree(list[int] t, int n = size(t) - 1, list[STNode] nodes = [NewNode()], map[int, map[int,STEdge]] edges = (), STSuffix active = NewSuffix(0,0,-1)){
	STSuffixTree tree = stSuffixTree(t, n, nodes, edges, active);
	
	for(int i <- [0..size(tree.total)])
		tree = AddPrefix(tree, i);
	
	return tree;
}

public STSuffixTree AddPrefix(STSuffixTree tree, int lastCharIndex){
	int lastParentNode = -1;
	int parentNode = -1;
	while(true){
		parentNode = tree.active.sourceNodeIndex;
		
		if(Explicit(tree.active)){
			if(tree.active.sourceNodeIndex in tree.edges && tree.total[lastCharIndex] in tree.edges[tree.active.sourceNodeIndex])
				break;
		} else {
			STEdge e = tree.edges[tree.active.sourceNodeIndex][tree.total[tree.active.firstCharIndex]];
			if(tree.total[e.firstCharIndex + GetLength(tree.active) + 1] == tree.total[lastCharIndex])
				break;
			tuple[int,STSuffixTree] splitRes = SplitEdge(tree, e, tree.active);
			parentNode = splitRes[0];
			tree = splitRes[1];
		};
		
		tree.nodes += [NewNode()];
		STEdge e = NewEdge(lastCharIndex, tree.n, parentNode, size(tree.nodes) - 1);
		tree = InsertEdge(tree, e);
		
		if(lastParentNode > 0)
			tree.nodes[lastParentNode].suffixNode = parentNode;
		lastParentNode = parentNode;
		
		if(tree.active.sourceNodeIndex == 0)
			tree.active.firstCharIndex += 1;
		else
			tree.active.sourceNodeIndex = tree.nodes[tree.active.sourceNodeIndex].suffixNode;
		
		tree.active = CanonizeSuffix(tree, tree.active);
	};
	
	if(lastParentNode > 0)
		tree.nodes[lastParentNode].suffixNode = parentNode;
	
	tree.active.lastCharIndex += 1;
	tree.active = CanonizeSuffix(tree, tree.active);
	
	return tree;
}

public STSuffixTree InsertEdge(STSuffixTree tree, STEdge edge){
	if(edge.sourceNodeIndex notin tree.edges)
		tree.edges += (edge.sourceNodeIndex:());
	tree.edges[edge.sourceNodeIndex] += (tree.total[edge.firstCharIndex]:edge);
	return tree;
}

public STSuffixTree RemoveEdge(STSuffixTree tree, STEdge edge){
	tree.edges[edge.sourceNodeIndex] -=  (tree.total[edge.firstCharIndex]:edge);
	if(size(tree.edges[edge.sourceNodeIndex]) == 0)
		tree.edges -= (edge.sourceNodeIndex:());
	return tree;
}

public tuple[int, STSuffixTree] SplitEdge(STSuffixTree tree, STEdge edge, STSuffix suffix)
{
	tree.nodes += [NewNode()];
	STEdge e = NewEdge(edge.firstCharIndex, edge.firstCharIndex + GetLength(suffix), suffix.sourceNodeIndex, size(tree.nodes) -1);
	tree = RemoveEdge(tree, edge);
	tree = InsertEdge(tree, e);
	tree.nodes[e.destNodeIndex].suffixNode = suffix.sourceNodeIndex;
	edge.firstCharIndex += GetLength(suffix) + 1;
	edge.sourceNodeIndex = e.destNodeIndex;
	tree = InsertEdge(tree, edge);
	return <e.destNodeIndex, tree>;
}

public STSuffix CanonizeSuffix(STSuffixTree tree, STSuffix suffix){
	if(!Explicit(suffix))
	{
		STEdge e = tree.edges[suffix.sourceNodeIndex][tree.total[suffix.firstCharIndex]];
		if(GetLength(e) <= GetLength(suffix))
		{
			suffix.firstCharIndex += GetLength(e) + 1;
			suffix.sourceNodeIndex = e.destNodeIndex;
			return CanonizeSuffix(tree, suffix);
		};
	};
	return suffix;
}