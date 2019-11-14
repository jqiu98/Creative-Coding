/*
=======================[HOW-TO]=======================
MOUSE PRESS & DRAG - create a wall
KEY SHIFT - cancel the wall being drawn above
KEY SPACE - creates a creature at mouse position
KEY r - resets
KEY d - deletes the wall the mouse is hovering over
======================================================
*/


let effects; // Array holding effects for the walls
let Creatures;  // Array holding all creatures created
let Walls; // Array holding all walls created
let showRect; // Toggle to check if the wall being created was canceled or not
let start, end; // Start & end position of the wall being created by user
let wallEffect; // Variable for the current wall's effect
let wallColor; // Variable for the current wall's color
let wallStroke; // Varible for the current wall's border - determined based on their effect

function setup() {
	createCanvas(windowWidth, windowHeight);
	background("#C9D8F3");
	rectMode(CORNERS); // Mode is easier to draw walls based on mouse position

	// Some effects have a higher rate for a smoother/desired visual i.e. NORMAL, DOUBLE_SPEED
	effects = [ "NORMAL", // Basic wall, no effect
				"NORMAL", 
				"DOUBLE_SPEED", // Creatures that touch it gets 2x speed
				"DOUBLE_SPEED", 
				"RESIZE", // Creatures that touch it rescale in size by +/- 0.1
				"HALF_SPEED" ]; // Creatures that touch it gets 1/2x speed

	Creatures = [];
	Walls = [];
	showRect = false;
}

function draw() 
{
	background("#C9D8F3");

	MoveCreatures();
	DisplayWalls();

	if (showRect) wallDraw(); // Wall hasn't been canceled, so draw it
	
}

function MoveCreatures() // Moves/Updates every creature
{
	for (let aCreature of Creatures) 
	{
		// Check if the creature has a seek target assigned. If so, pass in their position
		if (aCreature.seekID != null) aCreature.seek(Creatures[aCreature.seekID].position);

		// Method that will call everything needed to update. Array of creatures & walls
		// are passed in to help check for collisions 
		aCreature.Run(Creatures, Walls);
	}
}

function DisplayWalls() // Draws all the walls onto the canvas
{
	for (let aWall of Walls) 
	{
		aWall.Display();
	}
}

function wallDraw() // Draw the current rectangle being created by the user
{
	push();
	strokeWeight(4);
	fill(wallColor);
	stroke(wallStroke);
	rect(start.x, start.y, end.x, end.y);
	pop();
}

function mousePressed() 
{
	showRect = true; // Toggle to true

	// Initialize the start & end position of the wall to the mouse position
	start = createVector(mouseX, mouseY);
	end = start.copy();

	// Preset the wall's color & effect it'll have
	wallColor = color(random(255), random(255), random(255));
	wallEffect = effects[int(random(effects.length))];
	switch (wallEffect) {
			case "NORMAL":
				wallStroke = color(0);
				break;
			case "DOUBLE_SPEED":
				wallStroke = color(0, 0, 255);
				break;
			case "RESIZE":
				wallStroke = color(255, 0, 0);
				break;
			case "HALF_SPEED":
				wallStroke = color(0, 255, 0);
				break;
		}
}

function mouseDragged() 
{
	end = createVector(mouseX, mouseY); // Update the end wall position to the mouse position
}

function mouseReleased() 
{
	if (showRect) { // We haven't canceled the draw
		createWall(); 
		showRect = false; // Toggle it off since it's been created - wait for the next press
	}
}

function keyPressed() 
{
	if (key == " ") createCreature();
	else if (keyCode == SHIFT) showRect = false; // Cancel the wall being drawn
	else if (key == "r") reset();
	else if (key == "d") deleteWall();
}

function reset() // Resets the canvas
{
	Walls.length = 0;
	Creatures.length = 0;
}

function deleteWall() // Delete walls based on mouse position
{
	for (let i = Walls.length-1; i > -1; i--) {
		if (checkPointCollision(Walls[i])) { // Check if the mouse is within the wall
			Walls.splice(i,1); // Remove if it is
			break; // Only want the first instance being deleted
		}
	}
}

function checkPointCollision(aWall) // Check if the mouse is inside a wall
{
	// Create shorter, more concise variables to make it easier to read
	let halfW = aWall.width/2;
	let halfH = aWall.height/2;
	let p = aWall.position.copy();

	// Wall border check
	return (p.x - halfW < mouseX &&
			p.x + halfW > mouseX &&
			p.y - halfH < mouseY &&
			p.y + halfH > mouseY);
}

function createCreature() // Create a creature
{
	// Assign a random seek target based on all creatures created thus far
	let seekID = int(random(Creatures.length));
	Creatures.push(new Creature(createVector(mouseX, mouseY), seekID));
}

function createWall() // Create a wall (after mouse released)
{
	// Abstract the center point of the wall along with width & height for the Wall class
	let wallWidth = abs(start.x - end.x);
	let wallHeight = abs(start.y - end.y);
	let x = (start.x + end.x) / 2;
	let y = (start.y + end.y) / 2;
	Walls.push(new Wall(createVector(x, y), wallWidth, wallHeight, wallColor, wallStroke, wallEffect));
}