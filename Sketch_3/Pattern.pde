class Pattern { // Class for my pattern
  // Attributes
  float x, y, len, radius;
  int rotation;
  boolean fractal;

  // Constructor
  Pattern( float xPos, float yPos, float lineLen, float cRadius, int rot) {
    x = xPos; // X-coordinate
    y = yPos; // Y-coordinate
    len = lineLen; // Length of the pattern line
    radius = cRadius; // Size of the circle radius
    rotation = rot; // Rotation of the pattern (Basically position of the circle)
    fractal = false; // Flag for if this pattern has fractalized already or not
  }
}
