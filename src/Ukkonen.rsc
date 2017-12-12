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
	int ROOT = 0;
	
public NodeList CreateUkkonen(list[int] input){
	NodeList nodes = [<(),NONEXISTING_SUFFIX>];
	Pointer activePoint = <ROOT,0,0>;
	
	int remainder = 1;
	
	for(int i <- [0..size(input)])
	{
		if(input[i] notin GetIndex(nodes, activePoint))
		{
			nodes = Add(nodes, activePoint, i, CURRENT_END, input[i], NO_CHILD);	
					
			if(remainder > 1){		
				tuple[int, NodeList, Pointer] traversed = TraverseTrie(nodes, activePoint, input, i, remainder);
				remainder = traversed[0];
				nodes = traversed[1];
				activePoint = traversed[2];
			};
			
		} else {
			activePoint = UpdateActivePoint(activePoint, i);

			if(GetChild(nodes, activePoint, input) != NO_CHILD && RemainderEqualsEdge(input, activePoint, nodes))
				activePoint = <GetChild(nodes, activePoint, input),0,0>;
			remainder += 1;	
		};
	};	
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
public tuple[int, NodeList, Pointer] TraverseTrie(NodeList nodes, Pointer activePoint, list[int] values, int i, int remainder, int iteration = 0){
	if(values[i] in GetIndex(nodes, activePoint) && values[GetIndexValue(nodes, activePoint, values)[0] + activePoint[2]] == values[i]){
		remainder += 1;
		activePoint[2] += 1;
	} else {
		// insertion
		nodes = Insert(nodes, activePoint, values, i);
		remainder -= 1;	
		
		// rule 1
		activePoint = Rule1(activePoint);
				
		// rule 2
		nodes = Rule2(iteration, nodes);
					
		// rule 3
		activePoint = Rule3(activePoint, nodes);
		
		if(remainder > 1 && activePoint[2] != 0)
			return TraverseTrie(nodes, activePoint, values, i, remainder, iteration = iteration + 1);
		else
			nodes = Add(nodes, activePoint, activePoint[1], CURRENT_END, values[activePoint[1]], NO_CHILD);
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
public NodeList Add(NodeList nodes, Pointer activePoint, int s, int e, int id, int childIndex){
	if (activePoint[2] == 0)
		nodes[activePoint[0]][0] += (id:<s,e,childIndex>);
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
public bool RemainderEqualsEdge(list[int] values, Pointer activePoint, NodeList nodes){
	return GetIndexValue(nodes, activePoint, values)[1] == activePoint[2];
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
	if(activePoint[0] == ROOT){
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
	if(activePoint[0] > ROOT && GetSuffixLink(nodes, activePoint) != NONEXISTING_SUFFIX)
		activePoint[0] = nodes[activePoint[0]][1];
	else
		activePoint[0] = ROOT;
	return activePoint;
}

/*
	Branch:	Updates the end index and next node of the current Node
	Input:	nodes
			active point
			string
	Result:	nodes
*/
public NodeList Branch(NodeList nodes, Pointer activePoint, list[int] values){
	NodeIndex nodeIndex = GetIndex(nodes, activePoint);	
	nodeIndex[values[activePoint[1]]][1] = activePoint[2];			
	nodeIndex[values[activePoint[1]]][2] = size(nodes);									
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
public NodeList Insert(NodeList nodes, Pointer activePoint, list[int] values, int i){
	nodes = Branch(nodes, activePoint, values);		
	int splitIndex = activePoint[2] + GetIndexValue(nodes, activePoint, values)[0];
	nodes += <(values[splitIndex] : <splitIndex, CURRENT_END, NO_CHILD>, values[i]:<i, CURRENT_END, NO_CHILD>), NONEXISTING_SUFFIX>;
	return nodes;
}