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
	// char + <start index + endindex + continue node>;
	list[map[str,tuple[int,int,int]]] internalNodes = [()];
	tuple[int,str,int] activePoint = <0,"",0>;
	int remainder = 1;
	
	// current end = -1
	for(int i <- [0..size(s)])
	{
		bool nowSet = false;
		if(s[i] notin internalNodes[activePoint[0]])
			internalNodes[activePoint[0]] += (s[i]:<i,-1, -1>);
		else if(activePoint[1] == ""){
			remainder += 1;	
			activePoint = <0,s[i],1>;
			nowSet = true;
		};
		
		
		bool finished = false;
		int dec = 0;
		while(remainder > 1 && !nowSet && !finished)
		{
			finished = true;
			if(s[internalNodes[activePoint[0]][activePoint[1]][0] + activePoint[2]] == s[i]){
				remainder += 1;
				activePoint[2] += 1;
			} else {
				// insertion
				// You're a wizzard Harry!
				int tEnd = internalNodes[activePoint[0]][activePoint[1]][1];
				internalNodes[activePoint[0]][activePoint[1]][1] = activePoint[2];
				internalNodes[activePoint[0]][activePoint[1]][2] = size(internalNodes);
				internalNodes += (s[activePoint[2]]:<activePoint[2],tEnd,-1>,s[i]:<i,-1,-1>);
				remainder -= 1;
				
				// from root
				if(activePoint[0] == 0){
					activePoint[1] = s[(i + 1) - (remainder)];
					dec += 1;
				};
				finished = false;
			};
		};
		activePoint[2] -= dec;
	};
	
	println(remainder);
	println(activePoint);

	text(internalNodes);
}

