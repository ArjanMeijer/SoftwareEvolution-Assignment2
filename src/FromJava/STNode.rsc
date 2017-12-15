module FromJava::STNode

import FromJava::STEdgeBag;
import FromJava::STEdge;
import List;
import Set;
import IO;

/* Statics */
public list[STNode] NodeIndex = [];
private int NO_SUFFIX = -1;

data STNode = stNode(list[int] dat, int lastIdx, STEdgeBag edges, int suffix, int resultCount, int index);

public STNode NewNode(list[int] d = [], int l = -1, STEdgeBag e = NewEdgeBag(), int s = NO_SUFFIX, int r = -1){
	STNode res = stNode(d, l, e, s, r, size(NodeIndex));
	NodeIndex += res;
	return res;
}

public set[int] getData(STNode n){
	return getData(n, -1);
}

public set[int] getData(STNode n, int numElements){
	set[int] ret = {};
	for(int i <- n.dat){
		ret += i;
		if(size(ret) == numElements)
			return ret;
	};
	
	for(str k <- n.edges.dat){
		if(-1 == numElements || size(ret) < numElements)
			for(int i <- getData(NodeIndex[n.edges.dat[k].dest])){
				ret += i;
				if(size(ret) == numElements)
					return ret;
			};
	};
	return ret;
}

void addRef(STNode n, int index){
	if(contains(n, index))
		return;
	
	n = addIndex(n, index);
	
	int iter = n.suffix;
	while(iter != NO_SUFFIX){
		
		if(contains(NodeIndex[iter], index))
			break;
		
		addRef(NodeIndex[iter], index);
		iter = NodeIndex[iter].suffix;
	};
}

bool contains(STNode n, int index){
	/*int low = 0;
	int high = n.lastIdx - 1;
	while(low <= high){
		int mid = (low + high) / 2; // >>> 2
		int midVal = n.dat[mid];
	};*/
	return index in n.dat;
}

int computeAndCacheCount(STNode n){
	computeAndCacheCountRecursive(n);
	return n.resultCount;
}

private set[int] computeAndCacheCountRecursive(STNode n){
	set[int] ret = {};
	for(int i <- n.dat){
		ret += i;
	};
	
	for(str k <- n.edges.dat)
		for(int i <- computeAndCacheCountRecursive(NodeIndex[n.edges.dat[k].dest]))
			ret += i;
	
	n.resultCount = size(ret);
	return ret;
}

public int getResultCount(STNode n)
{
	if(n.resultCount == -1)
	{
		println("Error: get result count called without compute count!");
		return 0;
	}
	
	return n.resultCount;
}

STNode addEdge(STNode n, str s, STEdge e){
	n.edges.dat += (s:e);
	
	return n;
}

STEdge getEdge(STNode n, str s){
	return n.edges.dat[s];
}

STNode getSuffix(STNode n){
	return NodeIndex[n.suffix];
}

STNode setSuffix(STNode n, STNode t){
	n.suffix = t.index;
	
	return n;
}

private STNode addIndex(STNode n, int index){
	n.dat += [index];
	
	return n;
}



