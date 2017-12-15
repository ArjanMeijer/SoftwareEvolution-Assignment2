module FromJava::STUkkonen

import FromJava::STEdgeBag;
import FromJava::STEdge;
import FromJava::STNode;
import IO;
import List;
import String;

data STUkkonen = stUkkonen(int last, STNode root, STNode activeLeaf);

public STUkkonen NewUkkonen(int l = 0, STNode r = NewNode()){
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
	STNode s = u.root;
	
	str text = "";
	for(int i <- [0..size(remainder)]){
		str v = remainder[i];
		text += v;
		tuple[STNode, str] active = update(s, text, remainder[i..], index);
		active = canonize(active[0], active[1]);
		
		s = active[0];
		text = active[1];	
	};
	
	if(u.activeLeaf.suffix == -1 && u.activeLeaf != u.root && u.activeLeaf != s)
		u.activeLeaf = setSuffix(u.activeLeaf, s);
}

private tuple[STNode, str] update(STNode inpNode, str part, str rest, int val){
	STNode s = inpNode;
	str temp = part;
	str newInt = part[size(part) -1];
	
	STNode oldRoot = u.root;
	
	tuple[bool, STNode] ret = testAndSplit(s, temp[0..size(temp)-1], newInt, rest, val);
	
	bool endPoint = ret[0];
	STNode r = ret[1];
	
	STNode leaf;
	while(!endPoint){
		println("!endpoint");
		///STEdge tempEdge;// = r.edges.d[newInt];
		if(newInt in r.edges.dat){
			leaf = NodeIndex[r.edges.dat[newInt].dest];
		} else {
			leaf = NewNode();
			addRef(leaf, val);
			STEdge newEdge = NewEdge(l = rest, d = leaf.index);
			r = addEdge(r, newInt, newEdge);
		};
		
		if(u.activeLeaf != u.root)
			u.activeLeaf = setSuffix(u.activeLeaf, leaf);
			
		oldRoot = r;
		
		if(s.suffix == -1){
			if(u.root != s)
				println("assert was false!!");
			
			temp = temp[1..];
		} else {
			tuple[STNode, str] canret = canonize(getSuffix(s), temp[0..size(temp) - 1]);
			s = canret[0];
			temp = canret[1] + temp[size(temp) - 1];
		};
		
		ret = testAndSplit(s, temp[0..size(temp) - 1], newInt, rest, val);
		endpoint = ret[0];
		r = ret[1];
	};
	
	if(oldRoot != u.root){
		oldRoot = setSuffix(oldRoot, r);
	}
	oldRoot = u.root;
	
	return <s, temp>;
}

private tuple[STNode, str] canonize(STNode s, str input)
{
	if(size(input) == 0)
		return <s, input>;
	
	STNode currentNode = s;
	str lst = input;
	if(lst[0] in s.edges.dat) {
		STEdge g = getEdge(s, lst[0]);
		while(lst[0] in s.edges.dat && isStartingWith(lst, g.label)){
			println("canonize");
			lst = lst[size(g.label)..];
			currentNode = NodeIndex[g.dest];
			if(size(lst) > 0 && lst[0] in currentNode.edges.dat)
				g = currentNode.edges.dat[lst[0]];
		}; 
	};
	
	return <currentNode, lst>;
}

private tuple[bool, STNode] testAndSplit(STNode n, str part, str t, str remainder, int val){
	
	tuple[STNode, str] ret = canonize(n, part);
	STNode s = ret[0];
	str lst = ret[1];
	
	if(size(lst) > 0){
		
		STEdge g = s.edges.dat[lst[0]];
		str lbl = g.label;
		
		if(size(lbl) > size(lst) && lbl[size(lst)] == t)
			return <true, s>;
		else {
			str newLabel = lbl[size(lst)..];
			if(isStartingWith(lbl,lst))
				println("Assert was true! - in test and split");
			
			STNode r = NewNode();
			STEdge newEdge = NewEdge(l = lst, d = r.index);
			g.label = newLabel;
			
			r = addEdge(r, newLabel[0], g);
			s = addEdge(s, lbl[0], newEdge);
			
			println("henk1");
			return <false, r>;
		};
	} else {
		println("t: <t>");
		println("<s.edges.dat>");
		if(t notin s.edges.dat) {
				println("henk2");
			return <false, s>;
		}
		else {
			STEdge e = getEdge(s,t);
			if(remainder == e.label)
			{
				addRef(NodeIndex[e.dest], val);
				return <true, s>;
			} else if (isStartingWith(remainder, e.label))
				return <true, s>;
			else if (isStartingWith(e.label, remainder)){
				STNode newNode = NewNode();
				addRef(newNode, val);
				
				STEdge newEdge = NewEdge(l = remainder, d = newNode.index);
				e.label = e.label[size(remainder)..];
				newNode = addEdge(newNode, e.label[0], e);
				s = addEdge(s, t, newEdge);
				
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