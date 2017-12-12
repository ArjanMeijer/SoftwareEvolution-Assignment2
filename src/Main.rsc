module Main

import IO;					// Println
import List; 				// indexOf
import String; 				// toLocation
import Exception;			// Try Catch
import util::ValueUI;

import STrie;
import Ukkonen;

// To run this application from the console you should use this command:
//		java -Xmx1G -Xss32m -jar libs/rascal-shell-stable.jar Main.rsc 0 1 C:/user/meije/test.txt
// This command assumes the .jar file is placed in the right folder.

// Args input:
// 	0) Type of clone, [0,1,2]
//  1) [0] Small Project, [1] Large project
//  2) Output file location
public void main(list[str] args) {
	println("Clone Detector by Arjan Meijer and Niels Boerkamp");
	DetectClones(0,0,|home:///henk|);
	/*	
	bool isValidInput = true;
	if(size(args) == 3){
		int cloneType = indexOf(["0","1","2"], args[0]);
		int projectID = indexOf(["0","1"], args[1]);
		loc outputFile;
		
		try
			outputFile = toLocation("file:///<args[2]>");
		catch : isValidInput = false;
		
		if(cloneType != -1 && projectID != -1 && isValidInput)
			DetectClones(cloneType, projectID, outputFile);	
	} else {
		isValidInput = false;
	};
	
	if(!isValidInput){
		println("invalid input!");
	}*/
}

private void DetectClones(int cloneType, int projectID, loc outputFile)
{
	//loc project = [|project://smallsql0.21_src|,|project://hsqldb-2.3.1|][projectID];
	//CreateTrie("abcabxabcd");
	//println("Detected clones!");
	//CreateUkkonen("abcabxabcd");
	println(CreateUkkonen("abcabxabcd"));//abcabxabcd
}