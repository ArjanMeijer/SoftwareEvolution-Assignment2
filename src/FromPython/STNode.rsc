module FromPython::STNode

data STNode = stNode(int suffixNode);

public STNode NewNode(int suffix)
{
	return stNode(suffix);
}

public STNode NewNode(int suffix = -1)
{
	return NewNode(suffix);
}