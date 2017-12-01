module Main

import IO;

// To run this application from the console you should use this command:
//		java -Xmx1G -Xss32m -jar libs/rascal-shell-stable.jar Main.rsc args*
// This command assumes the .jar file is placed in the right folder.

public void main(list[str] args) {
	println("Clone Detector by Arjan Meijer and Niels Boerkamp");
	
	for(a <- args){
		println(a);
	}
}