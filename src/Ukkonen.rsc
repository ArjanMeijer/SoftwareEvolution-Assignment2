module Ukkonen

import util::ValueUI;
import IO;
import String;
import List;
import Map;

// Contains logic to read from nodes
import Nodes;

/* Static declarations */
	int CURRENT_END = -1;
	int NONEXISTING_SUFFIX = -2;
	int NO_CHILD = -3;
	
public NodeList CreateUkkonen(str s){
	NodeList nodes = [<("":<0,0,1>),NONEXISTING_SUFFIX,0>,<(),NONEXISTING_SUFFIX,0>];
	Pointer activePoint = <1,0,0>;
	
	int remainder = 1;
	
	for(int i <- [0..size(s)])
	{
		if(s[i] notin GetIndex(nodes, activePoint))
		{
			//if(activePoint[2] < 1)
			nodes = Add(nodes, activePoint, i, CURRENT_END, s[i], NO_CHILD);	
					
			if(remainder > 1){		
				tuple[int, NodeList, Pointer] traversed = TraverseTrie(nodes, activePoint, s, i, remainder);
				remainder = traversed[0];
				nodes = traversed[1];
				activePoint = traversed[2];
			};
			
		} else {
			println("passed both");
			activePoint = UpdateActivePoint(activePoint, i);

			if(GetChild(nodes, activePoint, s) != NO_CHILD && RemainderEqualsEdge(s, activePoint, nodes, i))
				activePoint = <GetChild(nodes, activePoint, s),0,0>;
			remainder += 1;	
		};
	};	
	println(remainder);
	println(activePoint);
	return nodes;
}

/*
	TraverseTrie: Traverses the trie
	Input:	nodes,
			active point,
			string
			index
			remainder
			current iteration
*/
public tuple[int, NodeList, Pointer] TraverseTrie(NodeList nodes, Pointer activePoint, str s, int i, int remainder, int iteration = 0){
	if(s[i] in GetIndex(nodes, activePoint) && s[GetIndexValue(nodes, activePoint, s)[0] + activePoint[2]] == s[i]){
		println("rem inc");
		remainder += 1;
		activePoint[2] += 1;
	} else {
		println("else stmt");
		// insertion
		nodes = Insert(nodes, activePoint, s, i);
		remainder -= 1;	
		
		// rule 1
		activePoint = Rule1(activePoint);
				
		// rule 2
		nodes = Rule2(iteration, nodes);
					
		// rule 3
		println("before r3:<activePoint>");
		activePoint = Rule3(activePoint, nodes);
		println("after r3: <activePoint>");
		
		if(remainder > 1 && activePoint[2] != 0)
			return TraverseTrie(nodes, activePoint, s, i, remainder, iteration = iteration + 1);
		else
			nodes = Add(nodes, activePoint, activePoint[1], CURRENT_END, s[activePoint[1]], NO_CHILD);
	};
	return <remainder, nodes, activePoint>;
}

/*
	Add: Ads a value to the nodes
	Input: 	nodes,
			node index
			start index of string
			end index of string
			string character
			index of child node
	Returns: nodes
*/
public NodeList Add(NodeList nodes, Pointer activePoint, int s, int e, str character, int childIndex){
	//println("Adding: <character> to <nodes[n][0]>");
	if (activePoint[2] == 0)
		nodes[activePoint[0]][0] += (character:<s,e,childIndex>);
	return nodes;
}

/* 
	UpdateActivePoint: updates the active point to the current value
	Input:	current active point
			current index
	Returns: active point
*/
public Pointer UpdateActivePoint(Pointer activePoint, int i){
	if(activePoint[2] == 0)
		activePoint[1] = i;
	activePoint[2] += 1;
	return activePoint;
}

/*
	RemainderEqualsEdge: checks if the string to-add equals the current edge
	Input: 	string
			active point
			nodes
			index
	Returns: string to-add equals current edge
*/
public bool RemainderEqualsEdge(str s, Pointer activePoint, NodeList nodes, int i){
	str currentString = substring(s, activePoint[1], activePoint[1] + activePoint[2]);
	int end = GetIndexValue(nodes, activePoint, s)[1] == -1 ? i + 1 : GetIndexValue(nodes, activePoint, s)[0] + GetIndexValue(nodes, activePoint, s)[1];
	str targetString = substring(s, GetIndex(nodes,activePoint)[s[activePoint[1]]][0], end);
	return currentString == targetString;
}

/*
	Rule1: 	Updates the activepoint and the remainder
	Input:	active point
			remainder
			index
	Result:	active point,
			remainder
*/
public Pointer Rule1(Pointer activePoint){
	if(activePoint[0] == 1){
		activePoint[1] += 1;
		activePoint[2] -= 1;
	}
	return activePoint;
}

/*
	Rule2: 	Create a suffix link
	Input: 	current iteration
			nodes
	Result:	nodes
*/
public NodeList Rule2(int iteration, NodeList nodes){
	if(iteration != 0)
		nodes[size(nodes) - 2][1] = size(nodes) - 1;	

	return nodes;
}

/*
	Rule3:	Updates active point
	Input:	active point,
			nodes
	Result:	active point
	
	Preconditions: 	After split
					there is a suffix node to follow
*/
public Pointer Rule3(Pointer activePoint, NodeList nodes){
	if(activePoint[0] > 1 && GetSuffixLink(nodes, activePoint) != NONEXISTING_SUFFIX)
		activePoint[0] = nodes[activePoint[0]][1];
	else
		activePoint[0] = 1;
	return activePoint;
}

/*
	Branch:	Updates the end index and next node of the current Node
	Input:	nodes
			active point
			string
	Result:	nodes
*/
public NodeList Branch(NodeList nodes, Pointer activePoint, str s){
	//println("(<activePoint[0]>, <s[activePoint[1]]>, <activePoint[2]>)");
	//println("(<nodes[activePoint[0]][0]>");
	NodeIndex nodeIndex = GetIndex(nodes, activePoint);	
	nodeIndex[s[activePoint[1]]][1] = activePoint[2];			
	nodeIndex[s[activePoint[1]]][2] = size(nodes);									
	nodes[activePoint[0]][0] = nodeIndex;
	return nodes;
}

/*
	Insert: Inserts new node to the trie
	Input:	nodes,
			active point,
			string
			index
	Result:	nodes
*/
public NodeList Insert(NodeList nodes, Pointer activePoint, str s, int i){
	nodes = Branch(nodes, activePoint, s);		
	int splitIndex = activePoint[2] + GetIndexValue(nodes, activePoint, s)[0];
	nodes += <(s[splitIndex] : <splitIndex, CURRENT_END, NO_CHILD>, s[i]:<i, CURRENT_END, NO_CHILD>), NONEXISTING_SUFFIX, activePoint[2]>;
	return nodes;
}