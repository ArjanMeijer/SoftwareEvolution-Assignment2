/* 
	Implementation of the ukkonen algorithm
		STNode contains the data type of the node
		and functions to create a node
	
	We used the implementation of Nils Diefenbach (python) and Mark Nelson (C++)
	for our rascal implementation.
	
	Sources:
		https://github.com/kvh/Python-Suffix-Tree/blob/master/suffix_tree.py	- Nils Diefenbach
		http://marknelson.us/1996/08/01/suffix-trees/							- Mark Nelson
*/

module Ukkonen::STNode

data STNode = stNode(int suffixNode);

public STNode NewNode(int suffix)
{
	return stNode(suffix);
}

public STNode NewNode(int suffix = -1)
{
	return NewNode(suffix);
}