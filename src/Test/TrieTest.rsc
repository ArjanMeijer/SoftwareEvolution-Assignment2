module Test::TrieTest

import Ukkonen;
import Nodes;

test bool SimpleCase(){
	return CreateUkkonen("abc") == [<("a":<0,-1,-3>,"b":<1,-1,-3>,"c":<2,-1,-3>),-2>];
}

test bool MediumCase(){
	NodeList result = CreateUkkonen("abcabx");
	NodeList correct = [<("a":<0,2,1>,"b":<1,1,2>,"c":<2,-1,-3>,"x":<5,-1,-3>),-2>,<("c":<2,-1,-3>,"x":<5,-1,-3>),2>,<("c":<2,-1,-3>,"x":<5,-1,-3>),-2>];
	return result == correct;
}

test bool NormalCase(){
	return CreateUkkonen("abcabxabcd") == [<("a":<0,2,1>,"b":<1,1,2>,"c":<2,1,5>,"d":<9,-1,-3>,"x":<5,-1,-3>),-2>,<("c":<2,1,3>,"x":<5,-1,-3>),2>,<("c":<2,1,4>,"x":<5,-1,-3>),-2>,<("a":<3,-1,-3>,"d":<9,-1,-3>),4>,<("a":<3,-1,-3>,"d":<9,-1,-3>),5>,<("a":<3,-1,-3>,"d":<9,-1,-3>),-2>];
}

test bool Rule1Test(){
	return <0,1,1> == Rule1(<0,0,2>);
}

test bool Rule2Test(){
	return [<("a":<0,-1,-3>),1>,<("b":<1,-1,-3>),-2>] == Rule2(1, [<("a":<0,-1,-3>),-2>,<("b":<1,-1,-3>),-2>]);
}

test bool Rule3Test(){
	return <2,0,0> == Rule3(<1,0,0>, [<("a":<0,-1,-3>), -2>,<("b":<1,-1,-3>), 2>,<("c":<2,-1,-3>), -2>]);
}

test bool Branch(){
	NodeList inputList = [<("a":<0,-1,-3>),-2>];
	Pointer inputPointer = <0,0,2>;
	NodeList correct = [<("a":<0,2,1>), -2>];
	return Branch(inputList, inputPointer, "abcd") == correct;
}

test bool InsertTest(){
	NodeList inputList = [<("a":<0,-1,-3>),-2>];
	Pointer inputPointer = <0,0,2>;
	NodeList correct = [<("a":<0,2,1>), -2>,<("c":<2,-1,-3>,"e":<4,-1,-3>), -2>];
	return Insert(inputList, inputPointer, "abcdef", 4) == correct;
}