module Ukkonen::STSuffix

data STSuffix = stSuffix(int sourceNodeIndex, int firstCharIndex, int lastCharIndex);

public STSuffix NewSuffix(int sni, int fci, int lci){
	return stSuffix(sni, fci, lci);
}

public int GetLength(STSuffix suffix) = suffix.lastCharIndex - suffix.firstCharIndex;

public bool Explicit(STSuffix suffix) = suffix.firstCharIndex > suffix.lastCharIndex;

public bool Implicit(STSuffix suffix) = suffix.lastCharIndex >= suffix.firstCharIndex;