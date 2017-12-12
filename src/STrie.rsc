module STrie

import util::ValueUI;
import IO;
import String;
import List;
import Map;
/*
public set[str] StringToSTrie(str T)
{
	text(STrie({}, "", {}, (),("":""), T));
	return {};
}

private tuple[map[tuple[str,tuple[str,int]], str], map[str,str]] STrie(set[str] Q, str Root, set[str] F, map[tuple[str,tuple[str,int]],str] g, map[str,str] f, str T){
	str r = Root;
	str oldrA = Root;
	int i = 0;
	while(i < size(T) && <r,<T[i],i>> notin g){
		println(T[i]);
		rA = "";
		if(i + 1 < size(T))
		{
			g += (<r,<T[i],i>>:T[i+1]);
			rA = g[<r,<T[i],i>>];
		}
		if(r != Root)
		{
			f += (oldrA:rA);
			rA = f[oldrA];	
		}
		oldrA += rA;
		r += f[r];
		i += 1;
	};
	//f += (oldrA:g[<r,<T,i-1>>]);
	//Root = g[<Root,T>];
	
	return <g,f>;
}*/


//inspiration: https://www.cs.cmu.edu/~ckingsf/bioinfo-lectures/suffixtrees.pdf
public void CreateSuffixTrie(str s){
	if(size(s) <= 0)
		return;
	
	lrel[map[str,int],int] suffixIndex = [<(s[0] : 1),0>,<(),0>];
	int root = 0;	
	int longest = 1;
	map[str,int] previous = ();
		
	for(int i <- [1..size(s)])
	{
		if(s[i] notin previous)
			previous += (s[i]: -1);
		
		int current = longest;
		while(s[i] notin suffixIndex[current][0]){
			int rl = size(suffixIndex);
			suffixIndex += <(),previous[s[i]]>;	
			suffixIndex[current][0] += (s[i] : rl);
			
			if(previous[s[i]] != -1)
				suffixIndex[previous[s[i]]][1] = rl;
			
			previous[s[i]] = rl;
			current = suffixIndex[current][1];
			println(previous);
		};

		//if(current == root)
		//	suffixIndex[previous[s[i]]][1] = root;
		//else
		//if(current != root)
		//s	suffixIndex[previous[s[i]]][1] = suffixIndex[current][0][s[i]];
		
		longest = suffixIndex[longest][0][s[i]];
	}
	
	println(suffixIndex);
	//text(suffixIndex);
	printTrie(suffixIndex, 0);
}
/*
private lrel[map[str,int],int] compressIndex(lrel[map[str,int],int] index){
	for(str key <- index[n][0])
	{
	
	};
	
	
}

private int compressLine(lrel[map[str,int],int] index, int n){
//	list[str] keys = [x | x <- index[n][0]];
//	if(size(keys) == 1)
//		return 1 + compressIndex(index, index[n][0][keys[0]]);
	return 0;
}
*/
private void printTrie(lrel[map[str,int],int] index, int n){
	for(str v <- index[n][0]){
		print(v);
		printTrie(index, index[n][0][v]);
	};
	if(size(index[n][0]) == 0)
		println("");
	//if(n + 1 < size(index))
	//printTrie(index, n + 1);
}


public void CreateTrie(str s)
{
	// char + <start index + endindex + continue node> + suffix link + start Index;
	lrel[map[str,tuple[int,int,int]], int, int] internalNodes = [<(),-2,0>];
	list[map[str,int]] nodePosition = [()];
	tuple[int,int,int] activePoint = <0,0,0>;
	int remainder = 1;
	
	// current end = -1
	// non-existing suffix link = -2
	
	for(int i <- [0..size(s)])
	{
		bool nowSet = false;
		if(s[i] notin internalNodes[0][0])
		{
			internalNodes[0][0] += (s[i]:<i,-1, -1>);
			nodePosition[activePoint[0]] += (s[i]:i);	
		}
		else if(activePoint[2] == 0){
			remainder += 1;	
			activePoint[1] = i;
			activePoint[2] += 1;
			nowSet = true;
		};
		
		if(internalNodes[activePoint[0]][0][s[activePoint[1]]][2] >= 0){
			// string till current end
			str currentString = substring(s, activePoint[1], i+1);
			int end = internalNodes[activePoint[0]][0][s[i]][1];
			end = end == -1 ? i + 1 : end;
			str targetString = substring(s, internalNodes[activePoint[0]][0][s[activePoint[1]]][0],end); 		
			if(currentString == targetString){
				remainder += 1;
				activePoint = <internalNodes[activePoint[0]][0][s[activePoint[1]]][2],0,0>;
			};
		} else {		
			bool finished = false;
			int dec = 0;
			int iterations =0;
			while(remainder > 1 && !nowSet && !finished)
			{
				finished = true;
			
				if(s[internalNodes[activePoint[0]][0][s[activePoint[1]]][0] + activePoint[2]] == s[i]){
					remainder += 1;
					activePoint[2] += 1;
				} else {
					// insertion
					// You're a wizzard Harry!
					int tEnd = /*nodePosition[activePoint[0]][s[activePoint[1]]] +*/ internalNodes[activePoint[0]][0][s[activePoint[1]]][1];
				
					map[str,tuple[int,int,int]] tItem = internalNodes[activePoint[0]][0];
					
					//println("Assigning for <s[activePoint[1]]>: <tItem[s[activePoint[1]]][1]> = <activePoint[2]>");
					//println("\t<activePoint[2]> + <internalNodes[activePoint[0]]>");
					int p = activePoint[2];
					p = p<nodePosition[activePoint[0]][s[activePoint[1]]]? p + nodePosition[activePoint[0]][s[activePoint[1]]]:p;
					
					tItem[s[activePoint[1]]][1] = p;//activePoint[2];
				
					tItem[s[activePoint[1]]][2] = size(internalNodes);				
					
					internalNodes[activePoint[0]][0] = tItem;
					
					println("ASDFKJA: <s[activePoint[1]]> + <activePoint> + <internalNodes[activePoint[0]]>");
					println(nodePosition[activePoint[0]][s[activePoint[1]]]);
					int tIndex = activePoint[2] + internalNodes[activePoint[0]][2];
					println("<tIndex> ====== <i> ===== <activePoint>");
					internalNodes += <(s[tIndex] : <tIndex, tEnd, -1>, s[i]:<i,-1,-1>),-2,activePoint[2]>;
					nodePosition += (s[tIndex]:tIndex, s[i]:i);
					remainder -= 1;
					
									
					// rule 2
					if(iterations != 0)
					{
						println("rule 2");
						internalNodes[size(internalNodes) - 2][1] = size(internalNodes) - 1;	
					};
					
					// rule 3
					if(activePoint[0] != 0 && internalNodes[activePoint[0]][1] != -2){
						activePoint[0] = internalNodes[activePoint[0]][1];
					} else {
						activePoint[0] = 0;
					};
					
					// rule 1
					if(activePoint[0] == 0){
						println("rule 1");
						activePoint[1] = (i + 1) - remainder;
						dec += 1;
					};
					
					/*if(i == size(s) - 1){
						text(internalNodes);
						println("REMAINDER:<remainder> - <iterations> - <activePoint>");
					};*/
					
					finished = false;
				};
				
				iterations += 1;
			};
			activePoint[2] -= dec;
		};
	};
	//text(nodePosition);
	//println(remainder);
	//println(activePoint);

	text(internalNodes);
}

