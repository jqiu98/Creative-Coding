//
/*
 Johnny Qiu
 Sketch_3
 
 ================================[OBJECTIVE]========================================
 To imitate a brush-esk feature using a pattern. Our brushes have 3 bristles.
 For this program, your mouse is the "brush" and a mouse-click is used to "paint"
 ==================================[HOW-TO]=========================================
 Move the mouse around the canvas. Click and drag to paint. Unclick to stop.
 There are different settings that can be toggled ON/OFF for varying effects.
 Once unclicked, the drawing is permanant and will no longer be affected by effects.
 New clicks will start another drawing ontop of the old.
 =================================[TOGGLES]=========================================
 Refresh (Key r)
 Brush Mode (Key b)
 Grow (Key g)
 Bubble-Pop (Key p)
 Bubble-Fractal (Key f)
 Auto-Rotate (Key a)
 Rotation Rate (Arrow-Keys LEFT/RIGHT)
 Bubble Limit (Arrow-Keys UP/DOWN, Key 0)
 ===========================[TOGGLE DESCRIPTIONS]===================================
 Refresh (Key r):
 Cleans the canvas
 
 Brush Mode (Key b):
 ON - Enables the drag brush feature
 OFF - Disables the drag brush feature (One click = One drawing)
 
 Grow (Key g):
 ON - The pattern will grow in size while the mouse is held down
 OFF - Disables the grow feature
 
 Bubble-Pop (Key p):
 ON - After growing to a certain size, the pattern will "pop" and disappear
 OFF - Disables the pop feature
 
 Bubble-Fractal (Key f):
 ON - After growing to a certain size, new patterns will fractal around it
 Each pattern will only fractal once
 OFF - Disables the fractal feature
 
 Auto-Rotate (Key a):
 ON - Rotation of pattern being drawn is randomized
 OFF - Disables randomized rotation. Rotation is based on the specified degree
 
 Rotation Rate (Arrow-Keys LEFT/RIGHT):
 LEFT: Decrement rotation degree
 RIGHT: Increment rotation degree
 
 Bound limit of 0-359
 Allows you to decide the rotation of the pattern being drawn.
 When Auto-Rotate is on, rotation is set to AUTO.
 
 Bubble Limit (Arrow-Keys UP/DOWN, Key 0):
 UP: Increment pattern limit
 DOWN: Decrement pattern limit
 0: Pattern limit changed to MAX
 
 Bound limit of 0 - 10000(MAX)
 Allows you to decide the limit of patterns drawn. Fractaled patterns count as well.
 However, LIMIT DOES NOT AFFECT FRACTALIZATION.
 ==================================================================================
 */

// CONSTANT VARIABLES
final float AREA = 40; // Boundary in which patterns will draw around the mouse
final float GROWTH_RATE = 0.5; // Growth rate for the length of the pattern
final float FRACTAL_SIZE = 25; // Size in which patterns start to fractal

// Dynamic Variables for State
int count; // Total count of all patterns on the canvas
int limit; // Limit for the # of patterns on the canvas
int rotationRate; // Degrees in which the pattern is rotated

// Toggles & Flags
boolean pressed; // Flag to know when the mouse is being pressed
boolean brush; // Toggle for the Brush-Mode feature
boolean grow; // Toggle for the Grow feature
boolean bubblePop; // Toggle for the Bubble-Pop feature
boolean bubbleFractal; // Toggle for the Bubble-Fractal feature
boolean autoRotate; // Toggle for the Auto-Rotate feature

// Arrays to keep track of the State
ArrayList<ArrayList<Pattern>> canvas; // Holds all patterns drawn during a session
ArrayList<Pattern> drawing; // Holds the current brush stroke being drawn
ArrayList<Pattern> fracList; // Holds the newly created patterns during fractalization

// Non-Initializing Variables
float randNum; // Used later to randomly assign pattern sizes
int patRotation; // Used later to randomly assign pattern rotations

void setup() {
  //Initializing Variables
  count = 0;
  limit = 10000;
  rotationRate = 90;

  // Initializing Toggles
  pressed = false;
  brush = true;
  grow = true;
  bubblePop = true;
  bubbleFractal = true;
  autoRotate = true;

  // Initializing State
  canvas = new ArrayList<ArrayList<Pattern>>();
  drawing = new ArrayList<Pattern>();
  canvas.add(drawing); // Adds current drawing onto the canvas
  fracList = new ArrayList<Pattern>();

  size(1000, 750);
  frameRate(25); // Slow down the FR or else it'll create too many
  strokeWeight(1);
}

void draw() {
  background(#A7E8E8);
  fill(255);

  if (pressed) { // Mouse pressed
    if (grow) incNode(); // Increase the pattern size
    if (brush && count < limit) createNode(mouseX, mouseY, 0); // Create a new pattern
  }

  if (bubblePop || bubbleFractal) fractal(); // Fractalize if need be

  //Draw everything
  displayPattern();
  displaySetting();
}

void mousePressed() {
  pressed = true;
  if (!brush) { // Only draws once since brush is toggled off
    for (int i = 0; i < 3; i++) createNode(mouseX, mouseY, 0);
  }
}

void mouseReleased() {
  pressed = false;

  // Resets for the next drawing
  drawing = new ArrayList<Pattern>();
  canvas.add(drawing);
}

void keyPressed() { // Setting Toggles
  if (key == 'r') {
    background(#A7E8E8);
    count = 0; // Resets count
    drawing.clear(); // Clear any current drawing
    canvas.clear(); // Clears all drawings done thus far
    canvas.add(drawing); // Resets
  } else if (key == 'g') grow = !grow;
  else if (key == 'p') bubblePop = !bubblePop;
  else if (key == 'f') bubbleFractal = !bubbleFractal;
  else if (keyCode == UP) changeLimit(10);
  else if (keyCode == DOWN) changeLimit(-10);
  else if (key == '0') changeLimit(0);
  else if (key == 'b') brush = !brush;
  else if (key == 'a') autoRotate = !autoRotate;
  else if (keyCode == RIGHT) changeRotation(5);
  else if (keyCode == LEFT) changeRotation(-5);
}

void changeLimit(int amt) { // Updates the pattern limit
  if (amt == 0) limit = 10000; // Set to MAX
  else if (limit == 10000) limit = 0; // If key not MAX and is currently MAX, set to 0
  if (amt == 10 && limit < count) limit = count - amt; // Makes it so limit is = to count
  limit += amt;
  if (limit < 0) limit = 0; // Lower boundary of 0, negatives don't make sense
}

void changeRotation(int amt) { // Updates the pattern rotation
  rotationRate += amt;
  if (rotationRate == 0) rotationRate = 359; // Upper boundary of 359
  else if (rotationRate == 360) rotationRate = 0; // Lower boundary of 0
}

void incNode() { // Increase the size of the patterns
  for (Pattern aNode : drawing) {
    aNode.len += GROWTH_RATE;
    aNode.radius += GROWTH_RATE;
  }
}

void fractal() { // Fractalization of pattern
  int node = 0; // Array index
  while (node < drawing.size()) { // While there's still pattern nodes to look at
    Pattern aNode = drawing.get(node);
    if (aNode.len > FRACTAL_SIZE) { // If a pattern is big enough to fractal
      if (bubbleFractal && !aNode.fractal) {
        aNode.fractal = true; // Set fractal to true so it cannot fractal again
        for (int times = 0; times < 3; times++) { // Fractals into 3 new ones
          createNode(aNode.x, aNode.y, 1);
        }
      }
      if (bubblePop) {
        drawing.remove(node); // Removes pattern node from the drawing since it popped
        count--; // Decrement count
      } else node++; // Increment index
    } else node++; // Increment index
  }
  drawing.addAll(fracList); // Add the fractals into the current drawing
  fracList.clear(); // Reset the fractal list for next time
}

void drawPattern(float x, float y, float lineLen, float circLen) { // Draws pattern
  stroke(#35AADD);
  line(x-lineLen, y-lineLen, x+lineLen, y+lineLen); // Upper-Left to Lower-Right Line
  line(x+lineLen, y-lineLen, x-lineLen, y+lineLen); // Upper-Right to Lower-Left Line

  stroke(#0DCFAA);
  fill(#C8FCFC);
  ellipse(x+lineLen, y+lineLen, circLen, circLen); // Circle at Lower-Right tip
  fill(255);
}

void createNode(float x, float y, int mode) { // Create a pattern to drawn later
  randNum = random(10); // Randomize size for pattern
  if (autoRotate) patRotation = (int)random(0, 360); // Randomize rotation for pattern
  else patRotation = rotationRate; // Auto-Rotate is off, use specified rotation
  Pattern node = new Pattern(x + random(-AREA, AREA), y + random(-AREA, AREA), 
    randNum, randNum, patRotation);
  count ++; // Increment count
  if (mode == 0) drawing.add(node); // Mode 0 => Created by user
  else fracList.add(node); // mode 1 => Created by fractalization
}

void displayPattern() { // Draws all patterns onto the screen
  for (ArrayList<Pattern> adrawing : canvas) {
    for (Pattern aNode : adrawing) {
      pushMatrix();
      translate(aNode.x, aNode.y); // Translate so rotation origin is at pattern's center
      rotate(radians(aNode.rotation));
      drawPattern(0, 0, aNode.len, aNode.radius); // Draws pattern centered at 0,0
      popMatrix();
    }
  }
}

void displaySetting() { // Draws all the toggle setting options at the top left screen
  String s_refresh = "(r) - Refresh";
  String s_brush = "(b) - Brush Mode: ";
  String s_grow = "(g) - Grow: ";
  String s_pop = "(p) - Bubble-Pop: ";
  String s_fractal = "(f) - Bubble-Fractal: ";
  String s_rotate = "(a) - Auto-Rotate: ";
  String s_rotationRate = "(LEFT/RIGHT) - Rotation Rate: ";
  String s_limit = "(UP/DOWN) - Bubble limit: ";
  String s_count = "Bubble count: ";
  int textY = 10; // Y position of the text, it's incremented by 15 per line

  displayText(s_refresh, 0, textY);
  textY += 15;

  displayText(s_brush, 0, textY);
  displayText(mode(brush), textWidth(s_brush), textY);
  textY += 15;

  displayText(s_grow, 0, textY);
  displayText(mode(grow), textWidth(s_grow), textY);
  textY += 15;

  displayText(s_pop, 0, textY);
  displayText(mode(bubblePop), textWidth(s_pop), textY);
  textY += 15;

  displayText(s_fractal, 0, textY);
  displayText(mode(bubbleFractal), textWidth(s_fractal), textY);
  textY += 15;

  displayText(s_rotate, 0, textY);
  displayText(mode(autoRotate), textWidth(s_rotate), textY);
  textY += 15;

  displayText(s_rotationRate, 0, textY);
  displayTextNum("rotation", rotationRate, textWidth(s_rotationRate), textY);
  textY += 15;

  displayText(s_limit, 0, textY);
  displayTextNum("limit", limit, textWidth(s_limit), textY);
  textY += 15;

  displayText(s_count, 0, textY);
  displayTextNum("count", count, textWidth(s_count), textY);
  textY += 15;
}

String mode(boolean flag) { // Changes a boolean toggle to ON/OFF string
  if (flag) return "ON";
  else return "OFF";
}

void displayText(String word, float w, float h) { // Changes color of alpha text
  if (word == "ON") fill(0, 190, 0); // Green for ON
  else if (word == "OFF") fill(255, 0, 0); // Red for OFF
  else fill(0); // Black for normal text
  text(word, w, h); // Draws the text to screen
}

void displayTextNum(String word, int num, float w, float h) { // Changes color of # text
  fill(0, 0, 255); // Blue
  if (word == "limit" && limit == 10000) word = "MAX";
  else if (word == "rotation" && autoRotate) word = "AUTO";
  else word = str(num); // Typecast to string in order to use function text()
  text(word, w, h);
}
