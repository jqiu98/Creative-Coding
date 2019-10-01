//Johnny Qiu
//Creative Coding Sketch_2

//Use a single shape/form to create 5 different grid-esk patterns

int mode = 0;
int len = 20;
int half = len / 2;

void setup() {
  size(800, 800);
  frameRate(15);
}

void draw() {
  background(255);
  
  // Calls the appropriate pattern to draw based on the current mode
  if (mode == 0) mode_0();
  else if (mode == 1) mode_1();
  else if (mode == 2) mode_2();
  else if (mode == 3) mode_3();
  else mode_4();
}

void keyReleased() { // Shuffles through the patterns based on LEFT/RIGHT arrow keys
  if (keyCode == LEFT) mode--;
  else if (keyCode == RIGHT) mode++;
  if (mode < 0) mode = 4;
  else if (mode > 4) mode = 0;
}

void mode_0() { // Normal grid pattern
  background(#D3E0E6);
  stroke(0);
  strokeWeight(2);

  for (int x = 0; x < width; x += len+5) {
    for (int y = 0; y < height; y += len+5) {
      line(x, y, x+len, y+len); //Left upper cross
      line(x+len, y, x, y+len); // Right upper cross
      ellipse(x+half, y+half, half, half); // Center circle
    }
  }
}

void mode_1() { // Parts of pattern skips based on divisibility
  background(#D3E0E6);
  strokeWeight(2.5);
  
  for (int x = 0; x < width; x += len+5) {
    for (int y = 0; y < height; y += len+5) {
      stroke(random(255), random(255), random(255));
      if (x % 4 == 0) line(x, y, x+len, y+len); // Skips on columns not divisible by 4
      if (y % 4 == 0) line(x+len, y, x, y+len); // Skips on rows not divisible by 4
      if (x % 4 == 0 && y % 4 == 0) ellipse(x+half, y+half, half, half); // Skips on columns and rows not divisible by 4
    }
  }
}

void mode_2() { // "Twinkle-stars-esk": size changes randomly
  background(0);
  strokeWeight(1.2);
  float modLen;
  float modHalf;

  for (int x = 0; x < width; x += len+5) {
    for (int y = 0; y < height; y += len+5) {
      stroke(random(255), random(255), random(255));
      modLen = (len * y + x) % 7; // Changes the size based on the values in the loops
      modHalf = modLen / 2; // Updating the half size based on modified size
      
      line(x, y, x+modLen, y+modLen);
      line(x+modLen, y, x, y+modLen);
      ellipse(x+modHalf, y+modHalf, modHalf, modHalf);
    }
  }
}

void mode_3() { // "Horizontal-assembly-line-esk": different patterns depending on the row
  background(#D3E0E6);
  strokeWeight(1.5);

  for (int x = 0; x < width; x += len+5) {
    for (int y = 0; y < height; y += len+5) {
      stroke(random(255), random(255), random(255));
      
      if (y % 2 == 0) line(x, y, x+len, y+len); // Displays when divisible by 2
      if (y % 4 == 0) line(x+len, y, x, y+len); // Displays when dibisible by 4
      if (y % 7 == 0) ellipse(x+half, y+half, half, half); // Displays when divisible by 7
    }
  }
}

void mode_4() { // Randomize the pattern placement
  background(#A7E8E8);
  strokeWeight(1.2);
  randomSeed(15); // Specified seed so it's displaying the same thing each draw
  int modLen;

  for (int x = 0; x < width; x += len+5) {
    for (int y = 0; y < height; y += len+5) {
      modLen = (int)random(40); // Randomizes the size
      
      if (modLen % 3 == 0) { // Condition that allows it to pseudo-ranomly place the pattern
        stroke(#35AADD);
        line(x, y, x+modLen, y+modLen);
        line(x+modLen, y, x, y+modLen);
        
        stroke(#0DCFAA);
        fill(#C8FCFC);
        ellipse(x+modLen, y+modLen, modLen, modLen); // Displaces the circle off center
        fill(255);
      }
    }
  }
}
