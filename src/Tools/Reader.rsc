module Tools::Reader

import Tools::CodeParser;
import lang::java::jdt::m3::Core;
import IO;
import String;

public list[list[str]] GetAllLines(loc project){
	M3 model = createM3FromEclipseProject(project);
	set[loc] projectFiles = files(model);
	return [[trim(y) | y <- split("\n",RemoveComments(readFile(x))[0])] | x <- projectFiles];	
}
