module Tools::Reader

import Tools::CodeParser;
import lang::java::jdt::m3::Core;
import IO;
import String;
import List;
import Set;

public lrel[lrel[str,int], loc] GetAllLines(loc project){
	M3 model = createM3FromEclipseProject(project);
	set[loc] projectFiles = files(model);
	return [<[y | y <- RemoveComments(readFile(x))], x> | x <- projectFiles];	
}
