module Test::TrieTest

import Main;
import Ukkonen::STEdge;

test bool SimpleCase(){
	return RunDetection([<[<"a", 0>, <"b", 1>, <"c", 2>], |tmp:///NA|>], testing = true) == (0:(1:stEdge(1,3,0,2),3:stEdge(3,3,0,4),2:stEdge(2,3,0,3),0:stEdge(0,3,0,1)));
}

test bool MediumCase(){
	return RunDetection([<[<"a", 0>, <"b", 1>, <"c", 2>, <"a", 3>, <"b", 4>, <"x", 5>], |tmp:///NA|>], testing = true) ==  (4:(3:stEdge(5,6,4,5),2:stEdge(2,6,4,1)),6:(3:stEdge(5,6,6,7),2:stEdge(2,6,6,2)),0:(1:stEdge(1,1,0,6),3:stEdge(5,6,0,8),2:stEdge(2,6,0,3),4:stEdge(6,6,0,9),0:stEdge(0,1,0,4)));
}

test bool HardCase(){
	return RunDetection([<[<"a", 0>, <"b", 1>, <"c", 2>, <"a", 3>, <"b", 4>, <"x", 5>, <"a", 6>, <"b", 7>, <"c", 8>, <"d", 9>], |tmp:///NA|>], testing = true) == (
  13:(
    4:stEdge(9,10,13,14),
    0:stEdge(3,10,13,3)
  ),
  9:(
    4:stEdge(9,10,9,10),
    0:stEdge(3,10,9,1)
  ),
  4:(
    3:stEdge(5,10,4,5),
    2:stEdge(2,2,4,9)
  ),
  11:(
    4:stEdge(9,10,11,12),
    0:stEdge(3,10,11,2)
  ),
  6:(
    3:stEdge(5,10,6,7),
    2:stEdge(2,2,6,11)
  ),
  0:(
    5:stEdge(10,10,0,16),
    1:stEdge(1,1,0,6),
    3:stEdge(5,10,0,8),
    2:stEdge(2,2,0,13),
    4:stEdge(9,10,0,15),
    0:stEdge(0,1,0,4)
  )
);
}

test bool GenerateTests() {
	
	BFTest(1000, 50);
	
	// If we make it this far we can say it has been succesful.
	return true;
}