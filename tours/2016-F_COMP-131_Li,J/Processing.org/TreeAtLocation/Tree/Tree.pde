/**
 * Recursive Tree
 * by Daniel Shiffman.  
 * 
 * Renders a simple tree-like structure via recursion. 
 * The branching angle is calculated as a function of 
 * the horizontal mouse location. Move the mouse left
 * and right to change the angle.
 */
 
 import processing.sound.*;
AudioIn in;




float theta;
float other_theta;

void setup() {
  size(1920, 1080);
}

void draw() {
  background(0);
  frameRate(30);
  stroke(255);
  // Let's pick an angle 0 to 90 degrees based on the mouse position
  float a = (mouseX / (float) width) * 90f;
  
  float b = (mouseY / (float) height) * 90f;
  // Convert it to radians
  theta = radians(a);
  other_theta = radians(b);
  drawTree( width / 4 );
}

void drawTree(int xpos) {
  // Save the entering frame of reference.
  pushMatrix();
  
  // Start the tree from the bottom of the screen
  // This moves the coordinate system down and to the right (centered).
  translate(xpos, height);
  // Draw a line 120 pixels
  // Negative numbers go up on the screen.
  line(0, 0, 0, -mouseY);
  // Move to the end of that line
  pushMatrix();
  translate(0, -mouseY);
  // Start the recursive branching!
  branch(120, .73);
  
  popMatrix();
  
  // Restore the original frame of reference.
  popMatrix();
}

void drawTree_2(int xpos) {
  // Save the entering frame of reference.
  pushMatrix();
  
  // Start the tree from the bottom of the screen
  // This moves the coordinate system down and to the right (centered).
  translate(xpos, height);
  // Draw a line 120 pixels
  // Negative numbers go up on the screen.
  line(0, 0, 0, mouseX);
  // Move to the end of that line
  pushMatrix();
  translate(0, mouseY);
  // Start the recursive branching!
  branch(120, .65);
  
  popMatrix();
  
  // Restore the original frame of reference.
  popMatrix();
}

void branch(float h, float ratio) {
  // Each branch will be 2/3rds the size of the previous one
  h *= ratio;

  // All recursive functions must have an exit condition!!!!
  // Here, ours is when the length of the branch is 2 pixels or less
  if (h > 2) {
    pushMatrix();    // Save the current state of transformation (i.e. where are we now)
    rotate(theta);   // Rotate by theta
    rotate(other_theta);
    line(0, 0, 0, -h);  // Draw the branch
    translate(0, -h); // Move to the end of the branch
    branch(h, ratio);       // Ok, now call myself to draw two new branches!!
    popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state

    // Repeat the same thing, only branch off to the "left" this time!
    pushMatrix();
    rotate(-theta);
    rotate(-other_theta);
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h, ratio);
    popMatrix();
  }
}