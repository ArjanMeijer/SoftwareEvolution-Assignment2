module STrie

import util::ValueUI;
import IO;
import String;
import List;
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
public void CreateSuffixTrie(list[str] s){
	if(size(s) <= 0)
		return;
	
	lrel[map[str,int],int] suffixIndex = [<(s[0] : 1),0>,<(),0>];
	int root = 0;	
	int longest = 1;
		
	for(int i <- [1..size(s)])
	{
		int current = longest;
		previous = -1;
		while(s[i] notin suffixIndex[current][0]){
		
			int rl = size(suffixIndex);
			suffixIndex += <(),rl>;	
			suffixIndex[current][0] += (s[i] : rl);
			
			if(previous != -1)
				suffixIndex[previous][1] = rl;
			
			previous = rl;
			current = suffixIndex[current][1];
		};
		
		if(current == root)
			suffixIndex[previous][1] = root;
		else
			suffixIndex[previous][1] = suffixIndex[current][0][s[i]];
		
		longest = suffixIndex[longest][0][s[i]];
	}
	
	printTrie(suffixIndex, 0);
}

private void printTrie(lrel[map[str,int],int] index, int n){
	for(str v <- index[n][0]){
		print(v);
		printTrie(index, index[n][0][v]);
	};
}

