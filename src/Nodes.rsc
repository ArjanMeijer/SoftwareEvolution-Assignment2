module Nodes

import Map;
/*
	structure: NodeIndex
		map:
			character
			tuple:
				start index,
				size,
				next node
*/
alias NodeIndex = map[str,tuple[int,int,int]];

/*  structure: NodeList
		list relation:
			NodeIndex
			suffix link	
*/
alias NodeList = lrel[NodeIndex, int];


/* structure: activePoint 
		tuple:
			active node,
			active start index,	---> edge character fron NodeList
			active length
*/
alias Pointer = tuple[int,int,int];

//lrel[map[str,tuple[int,int,int]],int, int] NodeList = [];

public int GetChild(NodeList nodes, Pointer activePoint, str s)
{
	return GetIndex(nodes, activePoint)[s[activePoint[1]]][2];
}

/*public bool Contains(NodeList nodes, tuple[int,int,int] activePoint, str character)
{
	return character notin nodes[activePoint[0]][0];
}*/

public NodeIndex GetIndex(NodeList nodes, Pointer activePoint){
	return nodes[activePoint[0]][0];
}

public tuple[int,int,int] GetIndexValue(NodeList nodes, Pointer activePoint, str s)
{
	return GetIndex(nodes,activePoint)[s[activePoint[1]]];
}

public int GetSuffixLink(NodeList nodes, Pointer activePoint){
	return nodes[activePoint[0]][1];
}