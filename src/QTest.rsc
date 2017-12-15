module QTest

import IO;

import List;
import Set;
import Node;
import String;

import QTT;

private str text = "abcabxabcd$"; 
private list[int] hashedCode = [1,2,3,1,2,4,1,2,3,5,-1];

private int nodeId;
private SXNODE root;
private int linkedNode;
private int newLinkedNode;
private SXNODE nullNode = sxNode(-1, <0, 0>, [], -1);
/*
	aP = activePoint
	aN = activeNode
	aE = activeEdge
	aL = activeLength
	aH = activeHash
*/
private tuple[SXNODE aN, SXNODE aE, int aL, int aH] aP;
private int remainder;

//
private int count;

public SXNODE cST(list[int] code) {

	/* Set variables to zero for a new tree. */
	nodeId = 0;
	remainder = 0;
	
	//
	count = 0;
	
	
	/* Use test code if the input is empty */
	if (code != []) {
		hashedCode = code + [-1];
	}
	
	/* Initiate the tree. */
	root = sxNode(nodeId, <0, 0>, [], -1);
	nodeId += 1;
	tuple[SXNODE aN, SXNODE aE, int aL, int aH] startAp = <root, nullNode, 0, -1>;
	aP = startAp;
	
	/* The algorithm moves through the list from left to right. */
	for (i <- [0 .. size(hashedCode)]) {
		/* Remainder is incremented every step and only decremented when the hash is inserted. */
		remainder += 1;
		/* Needed to check if a suffix link needs to be created. */
		linkedNode = 0;
		newLinkedNode = 0;
		step(i);
	}
	
	/* Finalize and show the tree. */
	root = fillTree(size(hashedCode) - 1, root);
	//println(root);
	
	return root;
}

private void step(int i) {
	count += 1;
	/* Print info about the step. */
	//println("STEP <count>:");
	//println("Tree: <root>");
	//println("Active node <aP.aN.id>");
	//println("Active edge <aP.aE.id>");
	//println("Active length <aP.aL>");
	//println("Active hash: <aP.aH>");
	//println("Remainder <remainder - 1>");
	//println("Link <linkedNode>");
	//println("");
	
	if (aP.aN.id == 0) {
		if (aP.aL == 0) {
			rootExtension(i);
		} else {
			activeEdgeExtension(i);
		}
	} else {
		if (aP.aL == 0) {
			internalNodeExtension(i);
		} else {
			activeEdgeExtension(i);
		}

	}
}

/* Check if hash can be found one of the edges leaving the root node. */
/* If not, create a new edge for that hash. If so, follow that edge until it stops matching. */
private void rootExtension(int i) {
	/* Search for the hash on leaving edges. */
	SXNODE matchingEdge = findHash(root, i, hashedCode);
	/* hash was not found, new edge created. */
	if (matchingEdge.id == -1) {
		newNode = sxNode(nodeId, <i, 0>, [], -1);
		root.childeren += [newNode];
		nodeId += 1;
		remainder -= 1;
		
	/* hash found, store this edge to follow it in the next step. */
	} else {
		aP = <root, matchingEdge, 1, i>;
		/* Remainder in not decremented, because we still need to add this hash to the tree. */
	}
}
		
/* Check if the current hash can be found on the activeEdge. */
/* If so, we keep following this edge. If not, we create an internal node. */
private void activeEdgeExtension(int i) {
	/* Check if current hash matches with the next on the activeEdge. */
	if (hashedCode[aP.aL + aP.aE.edge.left] == hashedCode[i]) {
		/* Check the length of the active edge. */
		int edgeLength;
		if (aP.aE.edge.right == 0) {
			edgeLength = i - aP.aE.edge.left;
		} else {
			edgeLength = aP.aE.edge.right - aP.aE.edge.left;
		}
		/* If the edge ends, we set the active point to search a new edge in the next step. */
		if (edgeLength < aP.aL + 1) {
			aP.aN = aP.aE;
			aP.aE = nullNode;
			aP.aL = 0;
			aP.aH = -1;
		} else {
			aP.aL += 1;
		}
		/* Remainder in not decremented, because we still need to add this hash to the tree. */
	} else {
		int oldSubTreeId = aP.aN.id;
		SXNODE newSubtree = createInternalNode(i);
		root = replaceSubtree(root, newSubtree, oldSubTreeId);
		
		/* Check if a new suffix link has to made. */
		if (linkedNode != 0) {
			root = addLink(root, linkedNode, newLinkedNode);
		}
		linkedNode = newLinkedNode;
		
		/* Rule 3 */
		if (aP.aN.id != 0) {
			if (aP.aN.link == -1) {
				aP.aN = root;
			} else {
				aP.aN = findNode(root, aP.aN.link);
			}
			aP.aE = findHash(aP.aN, aP.aH, hashedCode);
		} else {
			aP.aL -= 1;
			aP.aH += 1;
			aP.aE = findHash(aP.aN, aP.aH, hashedCode);
		}
		
		remainder -= 1;
		/* Do this step again with a new activePoint. */
		step(i);
	}
}

private void internalNodeExtension(int i) {
	/* Search for the hash on leaving edges. */
	SXNODE matchingEdge = findHash(aP.aN, i, hashedCode);
	/* hash was not found, new edge created. */
	if (matchingEdge.id == -1) {
		newNode = sxNode(nodeId, <i, 0>, [], -1);
		nodeId += 1;
		aP.aN.childeren += [newNode];
		root = replaceSubtree(root, aP.aN, aP.aN.id);
		
		aP.aN = findNode(root, aP.aN.link);
		aP.aE = nullNode;
		remainder -= 1;
		
	/* hash found, store this edge to follow it in the next step. */
	} else {
		aP.aE = matchingEdge;
		aP.aL += 1;
		aP.aH = i;
		/* Remainder in not decremented, because we still need to add this hash to the tree. */
	}
}

/*
After splitting an edge from an active_node that is not the root node, 
we follow the suffix link going out of that node, if there is any, 
and reset the active_node to the node it points to. If there is no suffix link, 
we set the active_node to the root. active_edge and active_length remain unchanged. 
*/
public SXNODE createInternalNode(int i) {
	/* Remove old node from tree. */
	aP.aN = removeChild(aP.aN, aP.aE.id);
	
	/* Create and add the new internal node. */
	newNode = sxNode(nodeId + 1, <i, 0>, [], -1);
	tuple[int left, int right] internalEdge = <aP.aE.edge.left, aP.aE.edge.left + aP.aL - 1>;
	aP.aE.edge.left += aP.aL;
	newInternalNode = sxNode(nodeId, internalEdge, [newNode, aP.aE], -1);
	nodeId += 2;
	aP.aN.childeren += [newInternalNode];
	
	/* Set newLinkedNode for suffix link. */
	newLinkedNode = newInternalNode.id;
	
	return aP.aN;
}
    
