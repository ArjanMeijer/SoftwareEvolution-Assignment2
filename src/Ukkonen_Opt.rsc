module Ukkonen_Opt

import util::ValueUI;
import IO;
import String;
import List;
import Map;
import Exception;

// Contains logic to read from nodes
import Nodes;

bool DOLOG = false;

private void PrintPaths(list[int] values, map[int,str] rIndex, NodeIndex n, NodeList l, Pointer activePoint, int remainder, int currentEnd, bool isStart = true, list[str] prev = []){
	if(DOLOG){
		if(isStart)
			println("Results:<activePoint> - <remainder>");
		for(int key <- n){
			list[str] p = [rIndex[values[x]] | x <- [n[key][0] .. n[key][1] == -1 ? currentEnd + 1 : n[key][0] + n[key][1]]];
			if(n[key][2] >= 0)
				PrintPaths(values, rIndex, l[n[key][2]][0], l, activePoint, remainder, currentEnd, isStart = false, prev = prev + p + ["-"]);
			else
				println("\t<prev + p>");
		};
	}
}

private void LOG(value v){
	if(DOLOG)
		println("<v>");
}

/* Static declarations */
	int CURRENT_END = -1;
	int NONEXISTING_SUFFIX = -2;
	int NO_CHILD = -3;
	int ROOT = 0;
	
	list[str] aValues = [];
	map[int,str] rIndex = ();
	
public NodeList CreateUkkonen(list[int] input, list[list[str]] raw, map[int,str] rI){
	rIndex = rI;
	aValues = [];
	for(int i <- [0..size(raw)])
		for(int j <- [0..size(raw[i])])
			if(raw[i][j] notin aValues)
				aValues += raw[i][j];
	NodeList nodes = [<(),NONEXISTING_SUFFIX>];
	Pointer activePoint = <ROOT,0,0>;
	
	int remainder = 1;
	
	for(int i <- [0..size(input)])
	{
	
		LOG("Case: <aValues[input[i]]> at index <i> - <input[i]>- <GetIndex(nodes, activePoint)>");
		LOG("\tRemainder: <remainder>");
		LOG("\tActivePoint: <activePoint>");
		if(input[i] notin GetIndex(nodes, activePoint))
		{
			LOG("\tDid not contain - <activePoint>");
			
			nodes = Add(nodes, activePoint, i, CURRENT_END, input[i], NO_CHILD);	
			
			/*if(input[i] notin nodes[0][0])
				nodes = Add(nodes, <0,0,0>, i, CURRENT_END, input[i], NO_CHILD);*/
				
			if(remainder > 1 || (activePoint[0] != 0 && input[i] notin nodes[0][0])){		
				tuple[int, NodeList, Pointer] traversed = TraverseTrie(nodes, activePoint, input, i, remainder);
				remainder = traversed[0];
				nodes = traversed[1];
				activePoint = traversed[2];
				if(input[activePoint[1]] notin nodes[activePoint[0]][0])
				{
					nodes = Add(nodes, <0,0,0>, activePoint[1], CURRENT_END, input[activePoint[1]], NO_CHILD);
					activePoint = <0,0,0>;
				};
			};
			
		} else {
			LOG("\tDid contain");
			LOG(nodes[activePoint[0]][0]);
			LOG("\tUpdating active point");
			activePoint = UpdateActivePoint(activePoint, i);
			
			if(input[i] == input[i-1]){
				remainder += 1;
				activePoint[2] -= 1;
			};
			
			
			LOG("\tNew active point: <activePoint> - <aValues[input[activePoint[1]]]>");
			if(remainder > 1){
				tuple[int, NodeList, Pointer] traversed = TraverseTrie(nodes, activePoint, input, i, remainder);
				remainder = traversed[0];
				nodes = traversed[1];
				activePoint = traversed[2];
			} else {
				remainder += 1;
			};
						//activePoint = UpdateActivePoint(activePoint, i);
			

			if(input[activePoint[1]] in GetIndex(nodes, activePoint) && GetChild(nodes, activePoint, input) != NO_CHILD && RemainderEqualsEdge(input, activePoint, nodes))
			{
				activePoint = <GetChild(nodes, activePoint, input),0,0>;
				//remainder = 1;
				LOG("Went to node:<activePoint>");	
			}
		};
		if(DOLOG)
			PrintPaths(input, rIndex, nodes[0][0], nodes, activePoint, remainder, i);
		LOG("\n");
		
		if(remainder == 0)
			remainder = 1;
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
	//LOG("IN TRAVERSE");	
	//LOG(activePoint);
	//LOG(values);
	if((activePoint[2] != 0 || activePoint[0] == 0) && activePoint[1] + activePoint[2] < size(values) - 1 && values[activePoint[1]] in GetIndex(nodes, activePoint) && values[GetIndexValue(nodes, activePoint, values)[0] + activePoint[2]] == values[activePoint[1] + activePoint[2]]){
		remainder += 1;
		activePoint[2] += 1;
		LOG("\t\tIncreased remainder<activePoint>");
	} else if(activePoint[2] == 0) {
		LOG("\t\tAdding in traverse:<activePoint>");
		nodes = Add(nodes, activePoint, i, CURRENT_END, values[i], NO_CHILD);
		// rule 1
		activePoint = Rule1(activePoint);
				
		// rule 2
		nodes = Rule2(iteration, nodes);
					
		// rule 3
		activePoint = Rule3(activePoint, nodes);
		remainder -= 1;
		if(remainder > 1)
			return TraverseTrie(nodes, activePoint, values, i, remainder, iteration = iteration + 1);
		LOG("\t\tAddingInTrie:<activePoint>");
		activePoint = <0,i,1>;

		remainder = 1;
		//if(values[i] notin GetIndex(nodes, activePoint))
		//	nodes = Add(nodes, activePoint, i, CURRENT_END, values[i], NO_CHILD);
		
		LOG("\t\tRemainder <remainder>");
		LOG("\t\tActivePoint<activePoint>");
	} else {
		LOG("\t\tInsert to Trie");
		// insertion
		nodes = Insert(nodes, activePoint, values, i);
		remainder -= 1;	
		
		LOG("\t\tRemainder: <remainder>");
		
		if(values[i] != values[i-1]){
			// rule 1
			activePoint = Rule1(activePoint);
					
			// rule 2
			nodes = Rule2(iteration, nodes);
						
			// rule 3
			activePoint = Rule3(activePoint, nodes);
		}
		
		LOG("\t\tActivePoint: <activePoint>");
		
		if((remainder > 1 && activePoint[2] != 0))
			return TraverseTrie(nodes, activePoint, values, i, remainder, iteration = iteration + 1);
		else if(activePoint[1] == i && values[activePoint[1]] notin nodes[activePoint[0]][0])
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
	if (activePoint[2] == 0){
		nodes[activePoint[0]][0] += (id:<s,e,childIndex>);
		LOG("\tAdded value!");	
	}
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
public tuple[NodeList,tuple[int,int]] Branch(NodeList nodes, Pointer activePoint, list[int] values, int i){
	LOG("\t\t\t\tCreating Branch");
	
	NodeIndex nodeIndex = GetIndex(nodes, activePoint);	
	LOG("\t\t\t\tTarget: <values[activePoint[1]]> - <aValues[values[activePoint[1]]]>");
	LOG("\t\t\t\t<nodeIndex>");
	
	tuple[int,int] cValues = <nodeIndex[values[activePoint[1]]][1], nodeIndex[values[activePoint[1]]][2]>;
	
	//println("CVAL:<cValues>");
	//PrintPaths(values, rIndex, nodes[0][0], nodes, i);
	//if(cValues[0] != CURRENT_END)
	//	return SplitNode(cValues, nodes, activePoint, nodeIndex, values);
	//else
		return <SplitLeaf(nodes, activePoint, nodeIndex, values), cValues>;
}


public NodeList SplitLeaf(NodeList nodes, Pointer activePoint, NodeIndex nodeIndex, list[int] values){
	LOG("\t\t\t\t\tSplitting leaf");
	nodeIndex[values[activePoint[1]]][1] = activePoint[2];			
	nodeIndex[values[activePoint[1]]][2] = size(nodes);
	nodes[activePoint[0]][0] = nodeIndex;
	LOG("\t\t\t\t\t<nodeIndex>");
	return nodes;
}

public tuple[NodeList, tuple[int,int]] SplitNode(tuple[int,int] cValues, NodeList nodes, Pointer activePoint, NodeIndex nodeIndex, list[int] values){
	LOG("\t\t\t\t\tSplitting node");
	//cValues[0] -= 1;
	text(nodes);
	println(activePoint);
	println(cValues);
	
	//nodeIndex[values[activePoint[1]]][1] = activePoint[2];
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

	if(values[activePoint[1]] notin nodes[activePoint[0]][0]){
		LOG("\t\t\tNot included case");
		LOG("\t\t\t\t<values[activePoint[1]]>");
		LOG("\t\t\t\t<nodes[activePoint[0]][0]>");
		return nodes;
	}
	int splitIndex = activePoint[2] + GetIndexValue(nodes, activePoint, values)[0];
	int newEdge = i;
	if(activePoint[1] + activePoint[2] - 1 == i)
		newEdge += 1;
	
	if(values[splitIndex] == values[newEdge])
		return nodes;

	LOG("\t\t\tInserting at <activePoint> with <i>");
	tuple[NodeList, tuple[int,int]] branchResult = Branch(nodes, activePoint, values, i);		
	nodes = branchResult[0];
	
	// This holds since the closing character can't appear anywhere else in the input
	// Therefore, the i + 1 case is valid, there can be no event in which i == $ && activePoint[1] == $

	
	nodes += <(values[splitIndex] : <splitIndex, branchResult[1][0], branchResult[1][1]>, values[newEdge]:<newEdge, CURRENT_END, NO_CHILD>), NONEXISTING_SUFFIX>;
	LOG("\t\t\tJust added:<nodes[size(nodes)-1]>");
	LOG("\t\t\tCurrent end: <i>");
	//LOG(nodes[0]);
	return nodes;
}