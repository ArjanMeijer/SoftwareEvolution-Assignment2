module Ukkonen_scr

import Nodes;
import List;
import IO;
import Map;

bool DOLOG = true;

private void PrintPaths(list[int] values, map[int,str] rIndex, NodeIndex n, NodeList l, Pointer activePoint, int remainder, int currentEnd, bool isStart = true, list[str] prev = []){
	if(DOLOG){
		if(isStart)
			println("Results:<activePoint> - <remainder>");
		for(int key <- n){
			list[str] p = [rIndex[values[x]] | x <- [n[key][0] .. n[key][1] == -1 ? currentEnd + 1 : n[key][0] + n[key][1]]];
			if(n[key][2] >= 0)
			{
				str s = "-";
				if(activePoint[0] == n[key][2])
					s += "!";
				PrintPaths(values, rIndex, l[n[key][2]][0], l, activePoint, remainder, currentEnd, isStart = false, prev = prev + p + [s]);
			}
			else
				println("\t<prev + p>");
		};
	};
}

private void LOG(value v){
	if(DOLOG)
		println("<v>");
}


int CURRENT_END = -1;
int NO_SUCC = -2;
int NO_SUFFIX = -3;


public NodeList CreateUkkonen(list[int] values, list[list[str]] raw, map[int,str] rI){
	Pointer activePoint = <0,0,0>;
	NodeList nodes = [<(),NO_SUFFIX>];
	int remainder = 0;
	
	for(int i <- [0..size(values)]){
	
		LOG("\n====== current: <rI[values[i]]> - (<activePoint[0]>, <rI[values[activePoint[1]]]>, <activePoint[2]>) - <remainder>");
		bool jumpedNode = false;
		if(values[i] in nodes[activePoint[0]][0]){
			LOG("in nodes");
	
			if(activePoint[2] == 0)
				activePoint[1] = i;
			activePoint[2] += 1;
			remainder += 1;
			/*
			LOG(nodes[activePoint[0]][0][values[activePoint[1]]]);
			LOG(nodes[activePoint[0]][0][values[activePoint[1]]][0] + activePoint[2]);
			LOG(values[i]);
*/
			
			
			LOG("<activePoint> - (<activePoint[0]>, <rI[values[activePoint[1]]]>, <activePoint[2]>) & <remainder>");
			LOG(nodes[activePoint[0]]);
			LOG(values[activePoint[1]]);
			LOG("======");
			if(activePoint[2] > 0 && nodes[activePoint[0]][0][values[activePoint[1]]][1] == activePoint[2]){
				activePoint[2] = 0;
				activePoint[0] = nodes[activePoint[0]][0][values[activePoint[1]]][2];
				jumpedNode = true;
				remainder -= 1;
				LOG("Jumped to <activePoint[0]>");
			};
			
			while(activePoint[2] > 0){
				if(values[nodes[activePoint[0]][0][values[activePoint[1]]][0] + activePoint[2] - 1] != values[i])
				{
					//LOG("not next in line");
					//LOG(nodes[activePoint[0]][0]);
					//LOG(values[activePoint[1]]);
					//LOG(activePoint[2]);
					//LOG("<values[nodes[activePoint[0]][0][values[activePoint[1]]][0] + activePoint[2]]> == <values[i]>");
					LOG("reduced activepoint 2");
					activePoint[2] -= 1;
					remainder -= 1;
					LOG("CALL FROM WHILE");
					nodes = Split(nodes, activePoint, i, values);	
					activePoint[1] += 1;
				}
				//PrintPaths(values, rI, nodes[0][0], nodes, activePoint, remainder, i);
				if(activePoint[0] == 0)
					break;
				else
					activePoint = GoDown(nodes, activePoint);
				
				//LOG(activePoint);
			};
		}; 
		
		if(values[i] notin nodes[activePoint[0]][0] && !jumpedNode)
		{
			LOG("HERE <rI[values[i]]>");
			while(true)
			{
				int iteration = 0;
				while (activePoint[2] != 0){
					LOG("AP:<activePoint>");
					LOG("RM:<remainder>");
					LOG("NL:<nodes[activePoint[0]]>");
					
					if(activePoint[2] > 0 && nodes[activePoint[0]][0][values[activePoint[1]]][1] == activePoint[2]){
						activePoint[2] = 0;
						activePoint[0] = nodes[activePoint[0]][0][values[activePoint[1]]][2];
						jumpedNode = true;
						LOG("WHILE-Jumped to <activePoint[0]>");
						remainder -= 1;
						break;
					};
					
					//if(activePoint[2] > 0 && (nodes[activePoint[0]][0][values[activePoint[1]]][1] == -1 || nodes[activePoint[0]][0][values[activePoint[1]]][1] > activePoint[2]))
					//	break;
									
					nodes = Split(nodes, activePoint, i, values);
					if(iteration > 0)
					{
						nodes[size(nodes) - 2][1] = size(nodes) -1;
					};
					
					remainder -= 1;
					if(activePoint[0] == 0)
					{
						LOG("IMA HERO");
						LOG("(<activePoint[0]>, <rI[values[activePoint[1]]]>, <activePoint[2]>) - <remainder>");
						//if(remainder > 1){
						//	activePoint[1] -= remainder;
							//activePoint[2] = 1;	
						//}
						//else{
							activePoint[1] += 1;
							activePoint[2] -= 1;
						//}
					} else {
						activePoint = GoDown(nodes, activePoint);
					};
						
					iteration += 1;
					PrintPaths(values, rI, nodes[0][0], nodes, activePoint, remainder, i);
					LOG("=====================================");
				};
				LOG("Adding - current point<activePoint>");
				nodes[activePoint[0]][0] += (values[i]:<i,CURRENT_END,NO_SUCC>);
				if(activePoint[0] == 0)
					break;
				else
					activePoint = GoDown(nodes, activePoint);
			};
		};
		PrintPaths(values, rI, nodes[0][0], nodes, activePoint, remainder, i);
	};
	
	return nodes;
}

private Pointer GoDown(NodeList nodes, Pointer activePoint){
	if(nodes[activePoint[0]][1] == NO_SUFFIX)
	{
		activePoint[0] = 0;
	} else {
		LOG("== FOLLOWING SUFFIX LINK ==");
		activePoint[0] = nodes[activePoint[0]][1];
	};
	return activePoint;
}

private NodeList Split(NodeList nodes, Pointer activePoint, int i, list[int] values)
{
	LOG("Splitting");
	LOG(activePoint);
	LOG(i);
	LOG(values);
	NodeIndex index = nodes[activePoint[0]][0];
	LOG(index);
	tuple[int,int,int] orgValues = index[values[activePoint[1]]];
	
	index[values[activePoint[1]]][1] = activePoint[2];
	index[values[activePoint[1]]][2] = size(nodes);
	nodes[activePoint[0]][0] = index;
	return AddNode(nodes, activePoint, values, i, orgValues);
}

private NodeList AddNode(NodeList nodes, Pointer activePoint, list[int] values, int i, tuple[int,int,int] orgValues)
{
	return nodes + <(values[orgValues[0] + activePoint[2]]:<orgValues[0] + activePoint[2], orgValues[1], orgValues[2]>, values[i]:<i,CURRENT_END,NO_SUCC>), NO_SUFFIX>;
}
