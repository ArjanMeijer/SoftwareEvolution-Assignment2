module Tools::Reader

import Tools::CodeParser;
import lang::java::jdt::m3::Core;
import IO;

public list[str] GetAllLines(loc project){
	M3 model = createM3FromEclipseProject(project);
	set[loc] projectFiles = files(model);
	return [RemoveComments(readFile(x)) | x <- projectFiles];	
}
