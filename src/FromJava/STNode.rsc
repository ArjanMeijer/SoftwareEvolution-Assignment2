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

void addRef(int n, int index){
	if(contains(n, index))
		return;
	
	addIndex(n, index);
	
	int iter = NodeIndex[n].suffix;
	while(iter != NO_SUFFIX){
		
		if(contains(iter, index))
			break;
		
		addRef(iter, index);
		iter = NodeIndex[iter].suffix;
	};
}

bool contains(int n, int index) = index in NodeIndex[n].dat;

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

void addEdge(int n, str s, STEdge e){
	NodeIndex[n].edges.dat += (s:e);
}

STEdge getEdge(int n, str s){
	return NodeIndex[n].edges.dat[s];
}

int getSuffix(int n){
	return NodeIndex[n].suffix;
}

void setSuffix(int n, int t){
	NodeIndex[n].suffix = t;
}

private void addIndex(int n, int index){
	NodeIndex[n].dat += [index];
}