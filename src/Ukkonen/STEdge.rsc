/* 
	Implementation of the ukkonen algorithm
		STEdge contains the data type of the edge,
		functions to get the properties of the edge,
		and functions to construct the edge
	
	We used the implementation of Nils Diefenbach (python) and Mark Nelson (C++)
	for our rascal implementation.
	
	Sources:
		https://github.com/kvh/Python-Suffix-Tree/blob/master/suffix_tree.py	- Nils Diefenbach
		http://marknelson.us/1996/08/01/suffix-trees/							- Mark Nelson
*/

module Ukkonen::STEdge

data STEdge = stEdge(int firstCharIndex, int lastCharIndex, int sourceNodeIndex, int destNodeIndex);

STEdge NewEdge(int s, int e, int sni, int dni){
	return stEdge(s, e, sni, dni);
}

// Length of the edge
public int GetLength(STEdge self) = self.lastCharIndex - self.firstCharIndex;


