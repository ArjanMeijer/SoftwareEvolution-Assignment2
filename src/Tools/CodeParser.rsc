module Tools::CodeParser

import String;
import List;
import IO;

public list[str] RemoveComments(str line){
	bool isString = false;
	bool isComment = false;
	bool isMComment = false;
	str result = "";
	str lastChar = "";
	str lastAdded = "";
	list[str] res = [];
	int skip = 0;
	int lines = 1;
	for(int index <- [0 .. size(line)]){
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
				res += result;
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
				res += result;
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
			res += result;
			result = "";
		} else
			result += lastChar;
		res += result;
	}
	return res;
}