module Tools::Reader

import Tools::CodeParser;			// Remove Comments
import lang::java::jdt::m3::Core;	// Construct M3
import IO;							// Readfile

public lrel[lrel[str,int], loc] GetAllLines(loc project){
	M3 model = createM3FromEclipseProject(project);
	set[loc] projectFiles = files(model);
	return [<[y | y <- RemoveComments(readFile(x))], x> | x <- projectFiles];	
}
