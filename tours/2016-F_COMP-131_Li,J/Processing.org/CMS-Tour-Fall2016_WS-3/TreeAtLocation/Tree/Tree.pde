/**
 * Recursive Tree
 * by Daniel Shiffman.  
 * 
 * Renders a simple tree-like structure via recursion. 
 * The branching angle is calculated as a function of 
 * the horizontal mouse location. Move the mouse left
 * and right to change the angle.
 */

float theta;   

void setup() {
  size(640, 360);
}

void draw() {
  background(0);
  frameRate(200);
  stroke(100, 250, 0);
  // Let's pick an angle 0 to 90 degrees based on the mouse position
  float a = (mouseX / (float) width) * 90f;
  // Convert it to radians
  theta = radians(a);
  
  drawTree( width / 4 );
}

void drawTree(int xpos) {
  // Save the entering frame of reference.
  pushMatrix();
  
  // Start the tree from the bottom of the screen
  // This moves the coordinate system down and to the right (centered).
  translate(width / 2, height);
  // Draw a line 120 pixels
  // Negative numbers go up on the screen.
  line(0, 0, 0, -120);
  // Move to the end of that line
  pushMatrix();
  translate(0, -120);
  // Start the recursive branching!
  float b = (mouseY / 3);
  println(b);
  branch(b);
  
  popMatrix();
  
  // Restore the original frame of reference.
  popMatrix();
}

void branch(float h) {
  // Each branch will be 2/3rds the size of the previous one
  h *= 0.66;

  // All recursive functions must have an exit condition!!!!
  // Here, ours is when the length of the branch is 2 pixels or less
  if (h > 6) {
    pushMatrix();    // Save the current state of transformation (i.e. where are we now)
    rotate(theta);   // Rotate by theta
    line(0, 0, 0, -h);  // Draw the branch
    translate(0, -h); // Move to the end of the branch
    branch(h);       // Ok, now call myself to draw two new branches!!
    popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state

    // Repeat the same thing, only branch off to the "left" this time!
    pushMatrix();
    rotate(-theta);
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h);
    popMatrix();
  }
}