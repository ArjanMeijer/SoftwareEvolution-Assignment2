let width = window.innerWidth;
let height = window.innerHeight;
let _radius = 150
let radius = 0;
let NUMBER_OF_TESTFILES = 150;
let files = [];
let angleDist = 10;
let cloneClasses = [];
let leftOffset = 0;
let backgroundColour = 10;
var selectedClone = 0;
var showAll = false;

var AllClones = [];

var fileIndex = {};
var fileCounter = 0;

function preload() {
  // files = RascalResult.files;
  // ;

  files =[];
  classes = [];

  for(var i = 0; i < RascalResult.length; i++) {
    var cloneClass = RascalResult[i];
    var cloneIDs = [];

    for(var j = 0; j < RascalResult[i].occurences.length; j++){
        var fileName = RascalResult[i].occurences[j][2];

        // If file is not in fileIndex
        if(fileIndex[fileName] == undefined) {
          fileIndex[fileName] = fileCounter;

          var split = fileName.split("/");
          files.push(split[split.length - 1]);
          //files.push(fileName);
          fileCounter++;
        }

        cloneIDs.push(fileIndex[fileName]);

        // Replace the fileName with an Index;
        RascalResult[i].occurences[j][2] = fileIndex[fileName];
    }
    cloneClasses.push(sort(cloneIDs));
  }
}


function setup() {
    createCanvas(width, height);
    angleMode(DEGREES);
    textAlign(LEFT, CENTER);
    background(backgroundColour);

    angleDist = 360/files.length;

    initiate();

    // Create some HTML elements
    var button = createButton('Toggle');
    button.position(20, 20);
    button.mousePressed(function(){
      showAll = !showAll;
    });
}

function initiate() {

  let size = windowHeight > windowWidth ? windowHeight : windowWidth;
  radius = (size / 2) * 0.3;
  //radius = _radius;

  colorMode(RGB);
  push();
  fill(255);
  noStroke();
  translate((width/2) + leftOffset, (height/2));
  drawFileNames();
  pop();

  colorMode(HSB, 100);
  drawCloneClassLabels();
}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
  colorMode(RGB);
  background(backgroundColour);
  translate(-width/2, -height/2);

  width = windowWidth;
  height = windowHeight;

  initiate();
}

function draw() {
  // Define the center of the window as the origin.
  translate((width/2) + leftOffset, (height/2));

  // Clear the inner circle
  clearInnerCircle();
  noFill();

  if(showAll) {
    for(var i = 0; i < cloneClasses.length; i++){
      setCloneClassColour(i);
      drawCloneClass(cloneClasses[i]);
    }
  } else {
    setCloneClassColour(selectedClone);
    drawCloneClass(cloneClasses[selectedClone]);
  }
}

function clearInnerCircle() {
  colorMode(RGB);
  fill(backgroundColour);
  noStroke();
  ellipse(0,0, radius * 2);
  colorMode(HSB);
}

function drawFileNames() {
  textSize(map(files.length, 150, 10, 2, 20));
  fill(255, 255, 255, 200);

  for(var i = 0; i < files.length; i++){
    text(files[i], radius + 5, 0);
    rotate(angleDist);
  }
}

function mousePressed() {
  //Check if a class label is clicked
  let labelX = 20;
  let labelY = 80

  for(var i = 0; i < cloneClasses.length; i++){
    setCloneClassColour(i, "fill");

    if(labelY > height-50){
      labelX += 100;
      labelY = 80;
    }

    if(mouseX > labelX && mouseX < (labelX + 100) && mouseY > labelY && mouseY < labelY + 20) {
      if(showAll)
        showAll = false;

      selectedClone = i;
      drawCode(RascalResult[i]);

      console.log(i, RascalResult[i]);
    }

    labelY += 20;
  }
}

function drawCloneClassLabels() {
  noStroke();
  let labelX = 20;
  let labelY = 80

  for(var i = 0; i < cloneClasses.length; i++){
    setCloneClassColour(i, "fill");

    if(labelY > height-50){
      labelX += 100;
      labelY = 80;
    }

    text("Clone class " + (i + 1), labelX, labelY);
    labelY += 20;
  }
}

function drawCloneClass(cloneClass) {

    cloneClass = Array.from(new Set(cloneClass));
    for(var i = 0; i < cloneClass.length - 1; i++){
      let from = cloneClass[i] * angleDist;
      let to = cloneClass[i + 1] * angleDist;

      drawClonePair(from, to);
    }

    let from = cloneClass[cloneClass.length - 1] * angleDist;
    let to = cloneClass[0] * angleDist;
    drawClonePair(from, to);
}

function drawCode(cloneClass) {
  let codeWidth = 300;
  push();
  translate(-width/2, -height/2);

  let startX = width - codeWidth;
  let startY = 0;

  noStroke();
  colorMode(RGB);
  fill(backgroundColour);
  rect(startX, startY, codeWidth, height);


  fill(255);
  rect(startX, startY, codeWidth, (cloneClass.occurences.length + cloneClass.code.length) * 14);

  fill(0);
  startY += 10;
  text("Files containing this clone: ", startX, startY);
  startY += 15;
  for(var i = 0; i < cloneClass.occurences.length; i++){
    var occ = cloneClass.occurences[i];
    text("\t" + files[occ[2]] + " at " + occ[0], startX, startY);
    startY += 12;
  }

  startY += 20;


  for(var i = 0; i < cloneClass.code.length; i++){
        text(cloneClass.code[i], startX + 10, startY);
        startY += 10;
  }

  colorMode(HSB);
  pop();
}



function drawClonePair(from, to){
  let fromCoord = angleToCoordinate(from);
  let toCoord = angleToCoordinate(to);

  bezier(fromCoord.x, fromCoord.y, 0, 0, 0, 0, toCoord.x, toCoord.y);
}

function angleToCoordinate(t) {
  let radian = radians(t);
  let x = radius* Math.cos(radian);
  let y = radius* Math.sin(radian);

  return {x:x, y:y};
}

function setCloneClassColour(cloneClassIndex, type = "stroke"){
    if(type == "stroke"){
      stroke(map(cloneClassIndex, 0, cloneClasses.length, 0, 100), 100, 100);
    } else if (type == "fill") {
      fill(map(cloneClassIndex, 0, cloneClasses.length, 0, 100), 100, 100);
    }
}
