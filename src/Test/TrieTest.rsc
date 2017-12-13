module Test::TrieTest

import Ukkonen;
import Nodes;

test bool SimpleCase(){
	return CreateUkkonen([0,1,2]) == [<(0:<0,-1,-3>,1:<1,-1,-3>,2:<2,-1,-3>),-2>];
}

test bool MediumCase(){
	NodeList result = CreateUkkonen([0,1,2,3,0,1,4]);//"abcabx");
	NodeList correct = [<(0:<0,2,1>,1:<1,1,2>,2:<2,-1,-3>,4:<5,-1,-3>),-2>,<(2:<2,-1,-3>,4:<5,-1,-3>),2>,<(2:<2,-1,-3>,4:<5,-1,-3>),-2>];
	return result == correct;
}

test bool NormalCase(){
	return CreateUkkonen([0,1,2,0,1,3,0,1,2,4]) == [<(1:<1,1,2>,2:<2,1,5>,0:<0,2,1>),-2>,<(3:<5,-1,-3>,2:<2,1,3>),2>,<(3:<5,-1,-3>,2:<2,1,4>),-2>,<(4:<9,-1,-3>,0:<3,-1,-3>),4>,<(4:<9,-1,-3>,0:<3,-1,-3>),5>,<(4:<9,-1,-3>,0:<3,-1,-3>),-2>];
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