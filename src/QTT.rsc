module QTT

import List;
import IO;
import String;

private SXNODE nullNode = sxNode(-1, <0, 0>, [], -1);

data SXNODE = sxNode(int id, tuple[int left, int right] edge, list[SXNODE] childeren, int link); 
			//| updateNode(SXNODE parent, SXNODE newChild); 

public SXNODE fillTree(int i, SXNODE root) {
	/* Do the same for the child nodes. */
	root.childeren = [fillSubTree(i, child) | child <- root.childeren];
	return root;
}

public SXNODE fillSubTree(int i, SXNODE sxnode) {
	/* Replace the empty right edge with i. */
	if (sxnode.edge.right == 0) {
		sxnode.edge.right = i;
	}
	/* Do the same for the child nodes. */
	sxnode.childeren = [fillSubTree(i, child) | child <- sxnode.childeren];
	return sxnode;
}

public SXNODE findHash(SXNODE root, int hash, list[int] serCode) {
	for (child <- root.childeren) {
		if (serCode[child.edge.left] == serCode[hash]) {
			return child;
		}
	}
	return nullNode;
}

public SXNODE removeChild(SXNODE sxnode, int removedChildId) {
	sxnode.childeren = [child | child <- sxnode.childeren, child.id != removedChildId];
	return sxnode;
}

public SXNODE replaceSubtree(SXNODE sxnode, SXNODE newSub, int oldSubId) {
	//println("__________________");
	//println("oldSubID: <oldSubId>");
	//println("sxNode: <sxnode>");
	//println("newSub: <newSub>");
	//println("__________________");

	if (sxnode.id == oldSubId) {
		return newSub;
	}
	
	if (sxnode.childeren == []) {
		return sxnode;
	}
	
	for (child <- sxnode.childeren) {
		if (child.id == oldSubId) {
			sxnode = removeChild(sxnode, child.id);
			sxnode.childeren += [newSub];
			return sxnode;
		}
	}
	sxnode.childeren = [replaceSubtree(child, newSub, oldSubId) | child <- sxnode.childeren];
	return sxnode;
}

public SXNODE addLink(SXNODE sxnode, int fromId, int toId) {
	if (sxnode.id == fromId) {
		sxnode.link = toId;
	} else {
		sxnode.childeren = [addLink(child, fromId, toId) | child <- sxnode.childeren];
	}
	return sxnode;
}

public SXNODE findNode(SXNODE sxnode, int nodeID) {
	if (sxnode.id == nodeID) {
		return sxnode;
	}
	for (child <- sxnode.childeren) {
		if (findNode(child, nodeID) != nullNode) {
			return child;
		}
	}
	return nullNode;
}