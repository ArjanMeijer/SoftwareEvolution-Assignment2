module Tools::CodeParser

import String;
import List;
import IO;

public lrel[str,int] RemoveComments(str line){
	bool isString = false;
	bool isComment = false;
	bool isMComment = false;
	str result = "";
	str lastChar = "";
	str lastAdded = "";
	lrel[str, int] res = [];
	int skip = 0;
	int currentLine = 0;
	for(int index <- [0 .. size(line)]){
		if(line[index] == "\n")
			currentLine += 1;
	
		str c = line[index];
		// Toggle string
		if(c == "\"" && !isComment)
			isString = !isString;
		
		// Start comment check
		if(!isString){
			if(lastChar == "/")
			{
				if(c == "/")
					isComment = true;
				else if(c == "*")
					isMComment = true;
			// End line comment Check
			} else if(isComment && lastChar == "\n"){
				isComment = false;
				res += <trim(result),currentLine>;
				result = "";
				skip = 1;
			// End multilineComment check
			} else if(isMComment && lastChar == "*" && c == "/")
			{
				isMComment = false;
				skip = 2;
			};
		};
		
		if((lastAdded == "\n" || (lastAdded == "" && skip == 0)) && lastChar == "\n")
			skip += 1;
		 
		// Add character to result
		if(!isComment && !isMComment && skip == 0 && lastChar != "\t" && lastChar != "\r")
		{
			lastAdded = lastChar;
			//result += lastChar;
			if(lastChar == "\n")
			{
				res += <trim(result), currentLine>;
				result = "";	
			} else
				result += lastChar;
		}
		else if(skip > 0)
			skip -= 1;
		
		// Update Last value
		lastChar = c;
	};
	
	// Add last value to result
	if(!isComment && !isMComment && skip == 0 && lastChar != "\t" && lastChar != "\r")
	{
		if(lastChar == "\n")
		{
			res += <trim(result), currentLine>;
			result = "";
		} else
			result += lastChar;
		res += <trim(result), currentLine>;
	}
	return res;
}