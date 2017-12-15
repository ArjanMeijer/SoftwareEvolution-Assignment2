module FromPython::STEdge

data STEdge = stEdge(int firstCharIndex, int lastCharIndex, int sourceNodeIndex, int destNodeIndex);

STEdge NewEdge(int s, int e, int sni, int dni){
	return stEdge(s, e, sni, dni);
}

public int GetLength(STEdge self) = self.lastCharIndex - self.firstCharIndex;


