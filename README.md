# Ultrasonic positioning
This project uses Arduino and ultrasonic ranging modules to track the location of an ultrasonic emitter on a plane. Also it uses MATLAB 
and serial port to communicate with system and plot the object trajectory in real time.

## You will need:
1. Arduino Uno
2. 3 Ultrasonic Ranging Modules HC-SR04 or US-015

## Running
Open "ultrasonic_positioning.ino" and fill in lenH and lenW variables with your height of emitters and distance between them respectively.
You need to load "ultrasonic_positioning.ino" on your Arduino (the project used Arduino Uno) and connect pins according to the scheme given 
below:
*here should be scheme*

Connect the Arduino to your computer via USB. Run MatLab "tracking.m" script. Have Fun!
