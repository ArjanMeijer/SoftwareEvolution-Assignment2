/* 
	Implementation of the ukkonen algorithm
		STSuffix contains the data type of the suffix,
		functions to get properties of the suffix
		and the functions to create a suffix
	
	We used the implementation of Nils Diefenbach (python) and Mark Nelson (C++)
	for our rascal implementation.
	
	Sources:
		https://github.com/kvh/Python-Suffix-Tree/blob/master/suffix_tree.py	- Nils Diefenbach
		http://marknelson.us/1996/08/01/suffix-trees/							- Mark Nelson
*/

module Ukkonen::STSuffix

data STSuffix = stSuffix(int sourceNodeIndex, int firstCharIndex, int lastCharIndex);

public STSuffix NewSuffix(int sni, int fci, int lci){
	return stSuffix(sni, fci, lci);
}

// Length of the suffix
public int GetLength(STSuffix suffix) = suffix.lastCharIndex - suffix.firstCharIndex;

// Ends on an explicit node
public bool Explicit(STSuffix suffix) = suffix.firstCharIndex > suffix.lastCharIndex;

// Ends on an implicit node
public bool Implicit(STSuffix suffix) = suffix.lastCharIndex >= suffix.firstCharIndex;