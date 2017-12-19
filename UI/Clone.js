function Clone(files, ) {
  this.code = [];     // list with lines of code
  this.occurences= [];

  this.GetCloneCode = function() {
    var result = "";
    for(var i = 0; i < this.code.length; i++)
      result += this.code[i] + "\n";

    return result;
  }

  this.GetClonedFiles = function() {
    var fileIDs = [];

    // console.log(this.occurences.map(i => i.filenameID));

  }
}

function CloneOccurence() {
  this.filenameID = 0;
  this.filename = "fileX";
  this.start = undefined;  // Actual line where the clone starts
  this.end = undefined;    // Actual line where the clone ends
}
