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

// Declare the processing sound variables 

FFT fft;
AudioDevice device;

// Declare a scaling factor
int scale = 5;

// Define how many FFT bands we want
//int bands = 128;
int bands = 4;


// declare a drawing variable for calculating rect width
float r_width;

// Create a smoothing vector
float[] sum = new float[bands];

// Create a smoothing factor
float smooth_factor = 0.2;


void setupAudio() {

  // Create the Input stream
  in = new AudioIn(this, 0);
  in.start();

  // Delay
  //in.add(0.2);
  // Replay
  //in.play();

  // If the Buffersize is larger than the FFT Size, the FFT will fail
  // so we set Buffersize equal to bands
  device = new AudioDevice(this, 44000, bands);

  // Calculate the width of the rects depending on how many bands we have
  r_width = width/float(bands);

  // Load and play a soundfile and loop it. This has to be called 
  // before the FFT is created.
  //sample = new SoundFile(this, "beat.aiff");
  //sample.loop();

  // Create and patch the FFT analyzer
  fft = new FFT(this, bands);
  fft.input(in);
}


void setup() {
  size(640, 360);

  // Set up audio
  setupAudio();
}

void draw() {
  background(0);
  frameRate(30);
  stroke(255);
  // Let's pick an angle 0 to 90 degrees based on the mouse position
  float a = (mouseX / (float) width) * 90f;
  // Convert it to radians
  float theta = radians(a);


  // Do some sound analysis

  fft.analyze();
  for (int i = 0; i < bands; i++) {
    // Smooth the FFT data by smoothing factor
    sum[i] += (fft.spectrum[i] - sum[i]) * smooth_factor;

    // You will have the sum array to work with.

    //println(sum[i]);

    // Draw the rects with a scale factor
    //rect( i*r_width, height, r_width, -sum[i]*height*scale );

    float power = -sum[i]*height*scale;
    power = -power ;
    if (power > 0.5) power = 0.5;


    // get a location on the x axis based on which i.
    float x_pos = i*r_width;

    println(power);
    drawTree( (int)x_pos, power, theta );

    //drawTree( x_pos, theta);
  }


  // draw a tree
  drawTree( width / 4, 0.66, theta );
}

void drawTree(int xpos, float h_ratio, float theta) {
  // Save the entering frame of reference.
  pushMatrix();

  // Start the tree from the bottom of the screen
  // This moves the coordinate system down and to the right (centered).
  translate(xpos, height);
  // Draw a line 120 pixels
  // Negative numbers go up on the screen.
  //line(0, 0, 0, -120);
  line(0, 0, 0, -height*h_ratio);
  // Move to the end of that line
  pushMatrix();
  //translate(0, -120);
  translate(0, -height*h_ratio);
  // Start the recursive branching!
  branch(120, h_ratio, theta);

  popMatrix();

  // Restore the original frame of reference.
  popMatrix();
}

void branch(float h, float h_ratio, float theta) {
  // Each branch will be 2/3rds the size of the previous one
  h *= h_ratio;

  // All recursive functions must have an exit condition!!!!
  // Here, ours is when the length of the branch is 2 pixels or less
  if (h > 2) {
    pushMatrix();    // Save the current state of transformation (i.e. where are we now)
    rotate(theta);   // Rotate by theta
    line(0, 0, 0, -h);  // Draw the branch
    translate(0, -h); // Move to the end of the branch
    branch(h, h_ratio, theta);       // Ok, now call myself to draw two new branches!!
    popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state

    // Repeat the same thing, only branch off to the "left" this time!
    pushMatrix();
    rotate(-theta);
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h, h_ratio, theta);
    popMatrix();
  }
}