
import processing.sound.*;
AudioIn in;

// Declare the processing sound variables 

FFT fft;
AudioDevice device;

// Declare a scaling factor
int scale = 5;

// Define how many FFT bands we want
int bands = 128;

// declare a drawing variable for calculating rect width
float r_width;

// Create a smoothing vector
float[] sum = new float[bands];

// Create a smoothing factor
float smooth_factor = 0.2;

void setup() {
  size(640, 360);
  background(255);

  // Create the Input stream
  in = new AudioIn(this, 0);
  in.start();
  //in.add(0.2);
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

void draw() {
  // Set background color, noStroke and fill color
  background(204);
  fill(0, 0, 255);
  noStroke();

  fft.analyze();
  for (int i = 0; i < bands; i++) {
    // Smooth the FFT data by smoothing factor
    sum[i] += (fft.spectrum[i] - sum[i]) * smooth_factor;
    
    // You will have the sum array to work with.
    
    println(sum[i]);

    // Draw the rects with a scale factor
    rect( i*r_width, height, r_width, -sum[i]*height*scale );
  }
}