module FromJava::STEdge

data STEdge = stEdge(str label, int dest);

public STEdge NewEdge(str l = "", int d = -1)
{
	return stEdge(l, d);
}
