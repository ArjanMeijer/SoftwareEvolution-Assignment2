module FromJava::STEdgeBag

import FromJava::STEdge;

data STEdgeBag = stEdgeBag(map[str, STEdge] dat, list[int] keys, list[STEdge] values);

public STEdgeBag NewEdgeBag(map[str,STEdge] d = (), list[int] k = [], list[STEdge] v = []){
	return stEdgeBag(d,k,v);
}