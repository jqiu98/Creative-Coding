void setup() {
  size(800, 800);
  background(0);
}

void draw() {
  background(#C9D8F3);
  float headX = width/2;
  float headY = height/4 + 50;

  //ears
  fill(#00C9F1);
  stroke(0);
  strokeWeight(3);
  ears(headX, headY);

  //head
  fill(#9e2b56);
  head(headX, headY);
  
  //eyes
  fill(#FFFFFF);
  stroke(#FF0000);
  strokeWeight(5);
  eyes(headX, headY);

  //mouth
  strokeWeight(3);
  stroke(0);
  mouth(headX, headY);

  //legs
  fill(#9e2b56);
  legs(headX, headY);
  
  //arms
  arms(headX, headY);

  //body
  fill(#FFFFFF);
  body(headX, headY);
  
  //tie
  fill(#6217A1);
  noStroke();
  tie(headX, headY);
  
  //blazer
  fill(0);
  blazer(headX, headY);
  
  //button
  fill(#6217A1);
  button(headX, headY);
}


void ears(float headX, float headY) {
  triangle(headX - 90, headY-30, headX - 175, headY - 70, headX - 100, headY+10);
  triangle(headX + 90, headY-30, headX + 175, headY - 70, headX + 100, headY+10);
}

void head(float headX, float headY) {
  ellipse(headX, headY, 200, 180);
}

void eyes(float headX, float headY) {
  ellipse(headX - 50, headY - 15, 45, 80);
  ellipse(headX + 50, headY - 5, 45, 60);
}


void mouth(float headX, float headY) {
  arc(headX, headY+50, 60, 40, 0, PI, CHORD);
}

void legs(float headX, float headY) {  
  for (int i = -1; i < 2; i+=2){
      triangle(headX-25*i, headY+225, headX-45*i, headY+260, headX-5*i, headY+260); //left leg top
      triangle(headX-25*i, headY+370, headX-45*i, headY+260, headX-5*i, headY+260); //left leg bot
  }   
}

void arms(float headX, float headY) {  
  for (int i = -1; i < 2; i+=2){
    triangle(headX-35*i, headY+130, headX-70*i, headY+150, headX-70*i, headY+110); //left inner
    triangle(headX-180*i, headY+130, headX-70*i, headY+150, headX-70*i, headY+110); //left outer
  }   
}

void body(float headX, float headY) {
  rect(headX - 50, headY+90, 100, 150);
}

void tie(float headX, float headY) {
  triangle(headX, headY+100, headX-15, headY+190, headX+15, headY+190); // middle triangle
  triangle(headX-20, headY+90, headX+20, headY+90, headX, headY+110); // beginning triangle
  triangle(headX-15, headY+190, headX+15, headY+190, headX, headY+210); // end tie triangle
}

void blazer(float headX, float headY) {
  for (int i = -1; i < 2; i+=2){
      triangle(headX-20*i, headY+90, headX-50*i, headY+90, headX-50*i, headY+240); //left top side
      triangle(headX-50*i, headY+175, headX-50*i, headY+240, headX+15*i, headY+240); //left bot side
  }
}

void button(float headX, float headY) {
  ellipse(headX, headY+232, 8, 8);
}
