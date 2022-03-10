
 
/*
 *  complex_protocol
 *  
 *  reads the values of a potentiometer 
 *  from the serial port (arduino) 
 *  and draws a graphical representation.
 * 
 *  the file is based on the Arduino meets Procesing Project  
 *  by Melvin Ochsmann for Malm� University
 *
 *  copyleft tomek_n | for HfG Schwäbisch Gmünd | 2012
 *
 */

// imarduinoing the processing serial class
import processing.serial.*;


// variables for serial connection, arduinoname and baudrate have to be set 
Serial arduino;
int baudrate = 9600;
int buf = 0;

// variables to draw graphics
int ellipseSize = 20;


void setup() {
  // set size and framerate
  size(400, 400); 

  // establish serial arduino connection      
  println(Serial.list());
  arduino = new Serial(this, Serial.list()[0], baudrate);
 //arduino = new Serial(this, "COM4", baudrate);  // pc // put in the right comport 

 //println(arduino);

  noStroke();
  ellipseMode(CENTER);
}


void draw() {

  // listen to serial arduino and trigger serial event  
  while (arduino.available () > 0) {
    serialEvent(arduino.read());
  }

  // draw something nice
  background(255);
  fill(226,119,35);
  ellipse(width/2, height/2, map(ellipseSize, 0, 1023, 0, 200), map(ellipseSize, 0, 1023, 0, 200));
  println( "e" + map(ellipseSize, 0, 1023, 0, 100));

}

void serialEvent(int serial) {
  // if serial event is not a line break 
  print("a-" + char(serial) + " ");

  if (serial!=10) {     // ascii code for end of line
    // add event to buffer
    buf = buf*10 + serial-48;
  } 
  else {
    ellipseSize = buf;
    buf = 0;
  }
}

