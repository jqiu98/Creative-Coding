class Creature 
{
	constructor(position, seekID) 
	{
		this.position = position;
		this.velocity = createVector(random(-8,8), random(-8,8));
		this.acceleration = createVector(0, 0);
		this.scale = 0.2; // Scaled rate for size
		this.speedLim = 8; // Max speed
		this.forceLim = 0.3; // Max force

		// Determine if this creature will be seeking or not
		if (int(random(2)) == 1) this.seekID = seekID;
		else this.seekID = null;
		this.UpdateSize();
	}

	UpdateSize() // Adjust size based on scale
	{ 
		this.width = 360 * this.scale;
		this.height = 460 * this.scale;
	}

	Run(Creatures, Walls) // Does everything to update the creature
	{ 
		this.Update(Creatures, Walls);
		this.CheckBoundary();
		this.Display();
	}

	Update(Creatures, Walls) // Update velocity & position
	{ 
		this.velocity.add(this.acceleration);
		this.velocity.limit(this.speedLim);
		this.acceleration.mult(0);

		// Update the X first, check for collisions, then update Y and check for collisions
		// This allows for respective velocity changes 
		this.position.x += this.velocity.x;
		this.CheckCollisionsX(Creatures, Walls);

		this.position.y += this.velocity.y;
		this.CheckCollisionsY(Creatures, Walls);

	}

	// Calculates a steering force towards a target
	seek(target) 
	{
		this.DrawSeekLine(target); // Draws a line going to the seeked target

		let desired = p5.Vector.sub(target, this.position); // A vector pointing from the location to the target

		desired.normalize();
		desired.mult(this.speedLim);

		// Steering = Desired minus velocity
		let steer = p5.Vector.sub(desired, this.velocity);
		steer.limit(this.forceLim); // Limit to maximum steering force

		this.acceleration.add(steer);
	}

	DrawSeekLine(target) // Draws a line to the target
	{
		push();
		stroke(255, 0, 0, 100);
		line(this.position.x, this.position.y, target.x, target.y);
		pop();
	}



	CheckBoundary() // Check the boundaries of the canvas, bounce if so
	{
		if (this.position.x > width - this.width/2) {
			this.position.x = width - this.width/2;
			this.velocity.x *= -1;
		}
		else if (this.position.x < this.width/2) {
			this.position.x = this.width/2;
			this.velocity.x *= -1;
		}

		if (this.position.y > height - this.height/2) {
			this.position.y = height - this.height/2;
			this.velocity.y *= -1;
		}
		else if (this.position.y < this.height/2) {
			this.position.y = this.height/2;
			this.velocity.y *= -1;
		}
	}

	CheckCollision(other) // Checks if we've collided with another object (wall or creature)
	{
		let xDist = abs(this.position.x - other.position.x) - (this.width + other.width)/2;
		let yDist = abs(this.position.y - other.position.y) - (this.height + other.height)/2;
		return (xDist < 0 && yDist < 0);
	}

	CheckCollisionsX(aCreatures, Walls) // Check for X collisions
	{
		for (let aCreature of Creatures) // Check against creatures
		{
			// Make sure we aren't checking against ourselves
			if (this != aCreature && this.CheckCollision(aCreature)) 
			{
				let xDist = abs(this.position.x - aCreature.position.x);

				// Position adjustment so we aren't inside the other
				let xPen = abs(xDist - this.width/2 - aCreature.width/2);
				if (this.velocity.x > 0) this.position.x -= xPen;
				else this.position.x += xPen;

				this.velocity.x *= -1; // Adjust velocity
			}
		}

		for (let aWall of Walls)
		{
			if (this.CheckCollision(aWall)) 
			{
				let xDist = abs(this.position.x - aWall.position.x);

				// Position adjustment so we aren't inside the other
				let xPen = abs(xDist - this.width/2 - aWall.width/2);
				if (this.velocity.x > 0) this.position.x -= xPen;
				else this.position.x += xPen;

				this.velocity.x *= -1; // Adjust velocity

				this.WallEffect(aWall.effect); // Apply wall's effect
			}
		}
	}

	CheckCollisionsY(Creatures, Walls) // Check for X collisions
	{
		for (let aCreature of Creatures)
		{
			// Make sure we aren't checking against ourselves
			if (this != aCreature && this.CheckCollision(aCreature)) 
			{
				let yDist = abs(this.position.y - aCreature.position.y);

				// Position adjustment so we aren't inside the other
				let yPen = abs(yDist - this.height/2 - aCreature.height/2);
				if (this.velocity.y > 0) this.position.y -= yPen;
				else this.position.y += yPen;

				this.velocity.y *= -1; // Adjust velocity
			}
		}

		for (let aWall of Walls)
		{
			if (this.CheckCollision(aWall)) 
			{
				let yDist = abs(this.position.y - aWall.position.y);

				// Position adjustment so we aren't inside the other
				let yPen = abs(yDist - this.height/2 - aWall.height/2);
				if (this.velocity.y > 0) this.position.y -= yPen;
				else this.position.y += yPen;

				this.velocity.y *= -1; // Adjust velocity

				this.WallEffect(aWall.effect); // Apply wall's effect
			}
		}
	}

	WallEffect(effect) { // Applying a wall's effect
		switch (effect) {
			case "NORMAL":
				break;
			case "DOUBLE_SPEED":
				this.velocity.mult(2);
				break;
			case "RESIZE":
				this.Resize();
				break;
			case "HALF_SPEED":
				this.velocity.mult(0.5);
				break;
		}
	}

	Resize() { // Resizes the creature randomly either +/- by 0.1 in scale
		let multiplier = [-1, 1];
		let randChoice = multiplier[int(random(2))];
		this.scale += randChoice * 0.1;
		if (this.scale == 0) this.scale = 0.1;
		this.UpdateSize();
	}

	Display() { // Draw the creature
		push();
		rectMode(CORNER);
		translate(this.position);
		scale(this.scale);
		strokeWeight(3);

		this.Ears();
		this.Head();
		this.Eyes();
		this.Mouth();
		this.Legs();
		this.Arms();
		this.Body();
		this.Tie();
		this.Blazer();
		this.Button();
		pop();
	}

	Ears() {
		fill("#00C9F1");
		triangle(-90, -170, -175, -210, -100, -130);
		triangle(90, -170, 175, -210, 100, -130);
	}

	Head() {
		fill("#9e2b56");
		ellipse(0, -140, 200, 180);
	}

	Eyes() {
		fill(255);
		push();
		stroke("#FF0000");
		strokeWeight(5);
		ellipse(-50, -155, 45, 80);
		ellipse(50, -145, 45, 60);
		pop();
	}


	Mouth() {
		fill(255);
		arc(0, -90, 60, 40, 0, PI, CHORD);
	}

	Legs() {  
		fill("#9e2b56");
		for (let i = -1; i < 2; i+=2){
		    triangle(-25*i, 85, -45*i, 120, -5*i, 120); //left leg top
		    triangle(-25*i, 230, -45*i, 120, -5*i, 120); //left leg bot
	  }   
	}

	Arms() {
		fill("#9e2b56");
		for (let i = -1; i < 2; i+=2){
			triangle(-35*i, -10, -70*i, 10, -70*i, -30); //left inner
			triangle(-180*i, -10, -70*i, 10, -70*i, -30); //left outer
	  }   
	}

	Body() {
		fill(255);
		rect( -50, -50, 100, 150);
	}

	Tie() {
		fill("#6217A1");
		push();
		noStroke();
		triangle(0, -40, -15, 50, 15, 50); // middle triangle
		triangle(-20, -50, 20, -50, 0, -30); // beginning triangle
		triangle(-15, 50, 15, 50, 0, 70); // end tie triangle
		pop();
	}

	Blazer() {
		fill(0);
		for (let i = -1; i < 2; i+=2){
			triangle(-20*i, -50, -50*i, -50, -50*i, 100); //left top side
			triangle(-50*i, 35, -50*i, 100, +15*i, 100); //left bot side
	  }
	}

	Button() {
		fill("#6217A1");
		ellipse(0, 92, 8, 8);
	}
}