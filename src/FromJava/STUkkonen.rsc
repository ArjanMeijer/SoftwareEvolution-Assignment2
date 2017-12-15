module FromJava::STUkkonen

import FromJava::STEdgeBag;
import FromJava::STEdge;
import FromJava::STNode;
import IO;
import List;
import String;

data STUkkonen = stUkkonen(int last, int root, int activeLeaf);

public STUkkonen NewUkkonen(int l = 0, int r = NewNode().index){
	return stUkkonen(l, r, r);
}

STUkkonen u = NewUkkonen();

public void put(str key, int index){
	println("<u>");
	if(index < u.last){
		println("Index was smaller than last index!");
		return;
	} else {
		u.last = index;
	}
	
	u.activeLeaf = u.root;
	str remainder = key;
	int s = u.root;
	
	str text = "";
	for(int i <- [0..size(remainder)]){
		str v = remainder[i];
		text += v;
		tuple[int, str] active = update(s, text, remainder[i..], index);
		active = canonize(active[0], active[1]);
		
		s = active[0];
		text = active[1];	
	};
	
	if(NodeIndex[u.activeLeaf].suffix == -1 && u.activeLeaf != u.root && u.activeLeaf != s)
		setSuffix(u.activeLeaf, s);
}

int DBUG = 0;

private tuple[int, str] update(int inpIndex, str part, str rest, int val){
	println("<inpIndex>-<part>-<rest>-<val>");
	int s = inpIndex;
	str temp = part;
	str newInt = part[size(part) -1];
	
	int oldRoot = u.root;
	
	tuple[bool, int] ret = testAndSplit(s, temp[0..size(temp)-1], newInt, rest, val);
	
	bool endPoint = ret[0];
	int r = ret[1];
	
	int leaf;
	while(!endPoint){
		if(DBUG > 10)
			return <s,"">;
		
		DBUG += 1;
		println("!endpoint");
		///STEdge tempEdge;// = r.edges.d[newInt];
		if(newInt in NodeIndex[r].edges.dat){
			leaf = NodeIndex[r].edges.dat[newInt].dest;
		} else {
			println("adding leaf node");
			leaf = NewNode().index;
			addRef(leaf, val);
			STEdge newEdge = NewEdge(l = rest, d = leaf);
			addEdge(r, newInt, newEdge);
		};
		
		if(u.activeLeaf != u.root)
			setSuffix(u.activeLeaf, leaf);
			
		oldRoot = r;
		
		if(NodeIndex[s].suffix == -1){
			if(u.root != s)
				println("assert was false!!");
			
			temp = temp[1..];
		} else {
			tuple[int, str] canret = canonize(getSuffix(s), temp[0..size(temp) - 1]);
			s = canret[0];
			temp = canret[1] + temp[size(temp) - 1];
		};
		
		ret = testAndSplit(s, temp[0..size(temp) - 1], newInt, rest, val);
		endpoint = ret[0];
		r = ret[1];
	};
	
	if(oldRoot != u.root){
		setSuffix(oldRoot, r);
	}
	oldRoot = u.root;
	
	return <s, temp>;
}

private tuple[int, str] canonize(int s, str input)
{
	if(size(input) == 0)
		return <s, input>;
	
	int currentNode = s;
	str lst = input;
	println("lst:<lst>");
	if(lst[0] in NodeIndex[s].edges.dat) {
		STEdge g = getEdge(s, lst[0]);
		while(lst[0] in NodeIndex[s].edges.dat && isStartingWith(lst, g.label)){
			println("canonize");
			lst = lst[size(g.label)..];
			currentNode = g.dest;
			if(size(lst) > 0 && lst[0] in NodeIndex[currentNode].edges.dat)
				g = NodeIndex[currentNode].edges.dat[lst[0]];
		}; 
	};
	
	return <currentNode, lst>;
}

private tuple[bool, int] testAndSplit(int n, str part, str t, str remainder, int val){
	
	tuple[int, str] ret = canonize(n, part);
	int s = ret[0];
	str lst = ret[1];
	
	if(size(lst) > 0){
		
		STEdge g = NodeIndex[s].edges.dat[lst[0]];
		str lbl = g.label;
		
		if(size(lbl) > size(lst) && lbl[size(lst)] == t)
			return <true, s>;
		else {
			str newLabel = lbl[size(lst)..];
			if(isStartingWith(lbl,lst))
				println("Assert was true! - in test and split");
			
			int r = NewNode().index;
			STEdge newEdge = NewEdge(l = lst, d = r);
			g.label = newLabel;
			
			addEdge(r, newLabel[0], g);
			addEdge(s, lbl[0], newEdge);
			
			println("henk1");
			return <false, r>;
		};
	} else {
		println("t: <t>");
		//println("<s.edges.dat>");
		if(t notin NodeIndex[s].edges.dat) {
				println("henk2");
			return <false, s>;
		}
		else {
			STEdge e = getEdge(s,t);
			if(remainder == e.label)
			{
				addRef(e.dest, val);
				return <true, s>;
			} else if (isStartingWith(remainder, e.label))
				return <true, s>;
			else if (isStartingWith(e.label, remainder)){
				int newNode = NewNode().index;
				addRef(newNode, val);
				
				STEdge newEdge = NewEdge(l = remainder, d = newNode);
				e.label = e.label[size(remainder)..];
				addEdge(newNode, e.label[0], e);
				addEdge(s, t, newEdge);
				
							println("henk3");
				return <false, s>;
			} else {
				return <true, s>;
			};
			
		}
	
	};
}

bool isStartingWith(str target, str s){
	return startsWith(target, s);
	for(int i <- [0..size(s)])
		if(s[i] != target[i])
			return false;
	return true;
}