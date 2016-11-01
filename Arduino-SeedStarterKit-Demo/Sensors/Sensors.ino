

#include <Wire.h>
#include "rgb_lcd.h"
#include <Servo.h>

// MODE
// 1 is sensors to Console
// 2 is matching servo to rotation sensor
// 3 match backlight to room lighting
// 4 pulse LED
#define MODE 4




const int rotationPin = A0;
// Connect the Grove - Button
const int pinButton = 7; // D7
// Connect the Grove - LED
const int pinLed    = 6; // D6
// Defines the pins to which the light sensor and LED are connected.
const int pinLight = A3;
// Echo Pin and Trigger Pin (need both for ping)
const int echoPin = 3; // D3
const int trigPin = 4; // D4
const int servoPin = 2; // D2
const String out_prefix = "Sensors:";

int maximumRange = 200; // Maximum range needed
int minimumRange = 0; // Minimum range needed
int minLightLevel = 1023;
int maxLightLevel = 0;
String outbuff;
Servo myservo;  // create servo object to control a servo

rgb_lcd lcd;

int pos = 0;    // variable to store the servo position

void setup() {
  // Default output string
  outbuff = "";
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
  pinMode(pinButton, INPUT);
  pinMode(pinLed, OUTPUT);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  myservo.attach(servoPin);

  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
  // Print a message to the LCD.
  lcd.print("hello, world!");

}

void loop() {

  if ( MODE == 1) {
    doSensors();
    
  } else if (MODE == 2) {
    doSetServo();
    
  } else if (MODE == 3) {
    doSetBacklight();
    
  } else if (MODE == 4) {
    doPulseLED();
    
  } else {
    delay(10);
    Serial.println("nothing");
  }

}

void doPulseLED() {

  // Get the value the rotation sensor

  int delayValue, rotValue;
  for (int i = 0; i < 256; i++)
  {
    rotValue = analogRead(rotationPin);
    // This takes values from 0 to 1024 and "maps" them to...
    delayValue = map(rotValue, 0 , 1025, 1, 10); //adjust the value...

    lcd.clear();
    lcd.print("r: " + String(rotValue));
    lcd.print(" d: " + String(delayValue));

    analogWrite(pinLed, i);
    delay(delayValue);
  }
  delay(delayValue*20);

  for (int i = 254; i >= 0; i--)
  {

    rotValue = analogRead(rotationPin);
    // This takes values from 0 to 1024 and "maps" them to...
    delayValue = map(rotValue, 0 , 1025, 1, 10); //adjust the value...

    lcd.clear();
    lcd.print("r: " + String(rotValue));
    lcd.print(" d: " + String(delayValue));
    analogWrite(pinLed, i);
    delay(delayValue);
  }
  delay(delayValue*30);
}



int detectLight() {
  // Gets from 0 - 1023
  int lightValue = analogRead(pinLight);
  // Track the minimum recorded light level
  if (lightValue < minLightLevel) {
    minLightLevel = lightValue;
  }
  if (lightValue > maxLightLevel) {
    maxLightLevel = lightValue;
  }
  return lightValue;
}

void doSetBacklight() {

  int lightValue = detectLight();

  // Use the minimum light level so we use the full range
  unsigned char backlight = map(lightValue, minLightLevel, maxLightLevel, 255, 0); //adjust the value to 0-255

  addToBuff("back", backlight);
  printBuff();

  lcd.setPWM(REG_RED, backlight);
  lcd.setPWM(REG_GREEN, backlight);
  lcd.setPWM(REG_BLUE, backlight);

  lcd.clear();
  lcd.print("lv: " + String(lightValue));
  lcd.print(" bl: " + String(backlight));
  //lcd.print("foo");

  delay(10);

}


void setServo( int deg ) {
  // WARNING, do not set above 180 or below 0.
  if (deg < 0 | deg > 180 ) return;
  myservo.write(deg);
  delay(30);
}

void doSetServo() {
  
  int rotValue = analogRead(rotationPin);
  // This takes values from 0 to 1024 and "maps" them to 0 to 180.
  pos = map(rotValue, 0 , 1024, 0, 180); //adjust the value to 0-180

  // send the servo to the position
  setServo(pos);
}


void doSensors() {

  int buttonValue = digitalRead(pinButton);

  // Read the value of the light sensor. The light sensor is an analog sensor.
  int lightValue = analogRead(pinLight);

  int pingValue = pingDistance();

  int rotValue = analogRead(rotationPin);

  addToBuff( "button", buttonValue );
  addToBuff( "light", lightValue );
  addToBuff( "ping", pingValue );
  addToBuff( "rot", rotValue );


  // Debug outputs
  printBuff();

  delay(50);        // delay in between reads for stability
}

void printBuff() {
  Serial.println(outbuff);
  outbuff = "";
  return;
}
void addToBuff( String nam, int val) {
  outbuff += nam;
  outbuff += ": ";
  outbuff += val;
  outbuff += " ";
  return;
}



long pingDistance() {

  long duration, distance; // Duration used to calculate distance
  /* The following trigPin/echoPin cycle is used to determine the
    distance of the nearest object by bouncing soundwaves off of it. */
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);

  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);

  //Calculate the distance (in cm) based on the speed of sound.
  distance = duration / 58.2;

  if (distance >= maximumRange || distance <= minimumRange) {
    /* Send a negative number to computer and Turn LED ON
      to indicate "out of range" */
    //Serial.println("-1 out of range");
    //digitalWrite(LEDPin, HIGH);
    distance = -1;
  }
  else {
    /* Send the distance to the computer using Serial protocol, and
      turn LED OFF to indicate successful reading. */
    //Serial.println(distance);
    //digitalWrite(LEDPin, LOW);
  }

  return distance;

}



