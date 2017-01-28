# Setting up the kit to work with this code.

* Make sure you have an Arduino working.
* Get the [Grove Starter Kit](http://wiki.seeed.cc/Grove_Starter_Kit_v3/) in the green box.
* Put the Grove shield on top of the Arduino.
* Attach the pluggable cables according to the pins mentioned in the Sensors.ino code, near the top (see the "const int" variables).
* The motor was jury-rigged: We used one of the grove cables coming out of the grove shield, but then plugged bare ends of 
 wires from a servo into the appropriate open end of the cable from the grove shield. This is probably the trickiest part.
* The Grove LCD display hooks to one of the `I2C` ports. It shouldn't matter which.


# Using the code

* make sure the Arduino is plugged into a USB port
* Run Arduino IDE program.
* Open up the Sensors.ino file.
* Change the `#define MODE` to be one of the numbers (1-4) depending on what you want to demo.
* Run/Upload the code.

# Demos

1. // 1 is sensors to Console  
  Open up the menu called Tools (or similar) and open the Serial Monitor. The values of four of the sensors are shown. 
  Button is button. Light is the light sensor. Ping is the ultrasonic distance sensor. Rot is the rotation sensor.
2. // 2 is matching servo to rotation sensor  
  Twist the rotation sensor and the servo should match the position.
3. // 3 match backlight to room lighting  
  I don't know if this demo works. It's supposed to make the LCD backlight brighter in dim light.
4. // 4 pulse LED
  Pulse the LED. Trick question for students: "*Any* LED can only be told to turn completely on or completely off. 
  So, how does the Arduino code manage to create what _seems_ to be different levels of brightness of the LED?" 
  Hint: "Pulse Width Modulation": Quickly turn on/off (flicker) the LED so that it's not on 100% of the time. The more time it
  spends on, the brighter it appears. It's too fast to notice, though, so we see it as a dim light.
