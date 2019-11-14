class Wall {
	constructor(position, width_, height_, color_, stroke_, effect) {
		this.position = position;
		this.width = width_;
		this.height = height_;
		this.color = color_;
		this.stroke = stroke_;
		this.effect = effect;
	}

	Display() {
		push();
		rectMode(CENTER);
		strokeWeight(4);
		fill(this.color);
		stroke(this.stroke);
		rect(this.position.x, this.position.y, this.width, this.height);
		pop();
	}
}