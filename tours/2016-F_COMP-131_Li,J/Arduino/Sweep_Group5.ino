/* Sweep
  by BARRAGAN <http://barraganstudio.com>
  This example code is in the public domain.

  modified 8 Nov 2013
  by Scott Fitzgerald
  http://www.arduino.cc/en/Tutorial/Sweep
*/

#include <Wire.h>
#include "rgb_lcd.h"
#include <Servo.h>

// Defines the pins to which the light sensor and LED are connected.
const int pinLight = A3;
const int pinLed   = 6;

// Defines the light-sensor threshold value below which the LED will turn on.
// Decrease this value to make the device more sensitive to ambient light, or vice-versa.
int thresholdvalue = 400;

Servo myservo;  // create servo object to control a servo
// twelve servo objects can be created on most boards


rgb_lcd lcd;
int sensorPin = 0;
int sensorValue = 0;
int pos = 0;    // variable to store the servo position

void setup() {
  myservo.attach(2);  // attaches the servo on pin 9 to the servo object

  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
  // Print a message to the LCD.
  lcd.print("hello, world!");
}


void setServo( int deg ) {
  // WARNING, do not set above 180 or below 0.
  if (deg < 0 | deg > 180 ) return;
  myservo.write(deg);
}


void loop() {

  sensorValue = analogRead(sensorPin); //read the value from sensor

  // Read the value of the light sensor. The light sensor is an analog sensor.
  int lightVal = analogRead(pinLight);



  // Turn the LED on if the sensor value is below the threshold.
  if (lightVal > thresholdvalue)
  {

    // This takes values from 0 to 1024 and "maps" them to 0 to 180.

    pos = map(sensorValue, 0, 1024, 0, 180); //adjust the value to 0-180

    // send the servo to the position
    setServo(pos);
    lcd.clear();
    lcd.print(String(pos));
    //sweep();

    delay(40);                       // waits 15ms for the servo to reach the position

  }
  else
  {
    sweep();
  }


  return;

}

void sweep() {


  for (pos = 0; pos <= 180; pos += 1) { // goes from 0 degrees to 180 degrees
    // in steps of 1 degree
    myservo.write(pos);  // tell servo to go to position in variable 'pos'
    lcd.clear();
    lcd.print(String(pos));
    delay(20);                       // waits 15ms for the servo to reach the position
  }
  for (pos = 180; pos >= 0; pos -= 1) { // goes from 180 degrees to 0 degrees
    myservo.write(pos);
    lcd.clear();           // tell servo to go to position in variable 'pos'
    lcd.print(String(pos));
    delay(20);                       // waits 15ms for the servo to reach the position
  }

}

