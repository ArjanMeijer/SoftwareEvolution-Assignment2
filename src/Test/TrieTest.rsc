module Test::TrieTest

import Ukkonen;
import Nodes;

test bool SimpleCase(){
	return CreateUkkonen("abc") == [<("":<0,0,1>),-2,0>,<("a":<0,-1,-3>,"b":<1,-1,-3>,"c":<2,-1,-3>),-2,0>];
}

test bool MediumCase(){
	NodeList result = CreateUkkonen("abcabx");
	NodeList correct = [<("":<0,0,1>),-2,0>,<("a":<0,2,2>,"b":<1,1,3>,"c":<2,-1,-3>,"x":<5,-1,-3>),-2,0>,<("c":<2,-1,-3>,"x":<5,-1,-3>),3,2>,<("c":<2,-1,-3>,"x":<5,-1,-3>),-2,1>];
	return result == correct;
}

test bool Rule1Test(){
	return <1,1,1> == Rule1(<1,0,2>);
}

test bool Rule2Test(){
	return [<("":<0,0,1>), -2,0>,<("a":<0,-1,-3>),2,0>,<("b":<1,-1,-3>),-2,0>] == Rule2(1, [<("":<0,0,1>), -2,0>,<("a":<0,-1,-3>),-2,0>,<("b":<1,-1,-3>),-2,0>]);
}

test bool Rule3Test(){
	return <3,0,0> == Rule3(<2,0,0>, [<("":<0,0,1>), -2, 0>,<("a":<0,-1,-3>), -2, 0>,<("b":<1,-1,-3>), 3, 0>,<("c":<2,-1,-3>), -2, 0>]);
}

test bool Branch(){
	NodeList inputList = [<("":<0,0,1>), -2, 0>, <("a":<0,-1,-3>),-2,0>];
	Pointer inputPointer = <1,0,2>;
	NodeList correct = [<("":<0,0,1>), -2, 0>, <("a":<0,2,2>), -2, 0>];
	return Branch(inputList, inputPointer, "abcd") == correct;
}

test bool InsertTest(){
	// [<("":<0,0,1>),-2,0>,<("a":<0,2,2>,"b":<1,1,3>,"c":<2,-1,-3>,"x":<5,-1,-3>),-2,0>,<("c":<2,-1,-3>,"x":<5,-1,-3>),3,2>,<("c":<2,-1,-3>,"x":<5,-1,-3>),-2,1>] ==> error case
	NodeList inputList = [<("":<0,0,1>), -2, 0>, <("a":<0,-1,-3>),-2,0>];
	Pointer inputPointer = <1,0,2>;
	NodeList correct = [<("":<0,0,1>), -2, 0>, <("a":<0,2,2>), -2, 0>,<("c":<2,-1,-3>,"e":<4,-1,-3>), -2, 2>];
	return Insert(inputList, inputPointer, "abcdef", 4) == correct;
}