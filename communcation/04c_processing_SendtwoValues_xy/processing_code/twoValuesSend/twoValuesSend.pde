import processing.serial.*;


Serial arduino;

int x = 0;
int y = 0;

void setup() {
  size(255, 255);

  println(Serial.list());
  //arduino = new Serial(this, "COM3", 9600);
  arduino = new Serial(this, Serial.list()[11], 9600);
}

void draw() {

  background(30); 

  // get the mouse Position (relative to window)
  x = mouseX;
  y = mouseY;

  stroke(255);
  line(x, 0, x, height);
  
  stroke(255);
  line(0, y, width, y);
   
  sendXy();

  // listen to serial arduino for feedback  
  while (arduino.available () > 0) {
    int inByte = arduino.read();
    print(char(inByte));
  }

  // sleep for a while, because there is nothing else to do
  try {
    Thread.sleep(250);
  } 
  catch (InterruptedException e) {
    e.printStackTrace();
  }
}


public void sendXy() {

  arduino.write(Integer.toString(x));
  arduino.write('a');

  arduino.write(Integer.toString(y));
  arduino.write('b');
}

