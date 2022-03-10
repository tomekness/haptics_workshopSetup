
/* simple one byte communicaiton */
/* from processing to arduino */
/* 2012 - tomek_n - for hfg gmuend */

// import lib 
import processing.serial.*;

//// arduino vars
Serial arduino;
int baudrate = 9600;

void setup() {

  size(200,200);    // canvas size

  println(Serial.list());  
  
  // init the serial connection
  arduino = new Serial(this, Serial.list()[0], baudrate);  // mac
  //arduino = new Serial(this, "COM4", baudrate);  // pc // put in the right comport 
  
  noStroke();
}


void draw() {

  fill(255,0,0);
  rect(0, 0, 100, 200);
  fill(0,255,0);
  rect(100,0,100,200);

  if(mouseX <= width/2) {
    arduino.write('r');
  } 
  else {
    arduino.write('g');
  }
  
  //print incoming data
  while (arduino.available() > 0) {
    int inByte = arduino.read();
    print(char(inByte));
  }

  // sleep for a while, because there is nothing else to do
  try {
    Thread.sleep(50);
  } 
  catch (InterruptedException e) {
    e.printStackTrace();
  }

}

