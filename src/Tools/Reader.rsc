module Tools::Reader

import Tools::CodeParser;
import lang::java::jdt::m3::Core;
import IO;
import String;
import List;
import Set;

public tuple[list[list[str]], list[loc]] GetAllLines(loc project){
	M3 model = createM3FromEclipseProject(project);
	set[loc] projectFiles = files(model);
	return <[z | x <- projectFiles, z := [trim(y) | y <- RemoveComments(readFile(x))]], toList(projectFiles)>;	
}
