import processing.serial.*;

boolean debug = true;

PImage map;

// which file to load
String imageFile = "img/greyScale-2d_1440x900.png";

int lastPixelValue = 0;

Serial arduino;

// it's a or b
char useMotor = 'a';

void setup() {

  // setup canvas, images and cursor

  fullScreen();
  //size(1440, 900);

  background(180);
  if (debug)println("screen width: " + width + " screen hight: " + height);

  map = loadImage(imageFile);
  image(map, 0, 0);

  cursor(CROSS);

  // setup arduino

  println(Serial.list());
  //arduino = new Serial(this, "COM3", 9600);
  arduino = new Serial(this, Serial.list()[3], 115200);
}

void draw() {

  // get mouse Pos

  PVector  mousePos = new PVector(mouseX, mouseY);
  //if(debug)println("mouse x: " + mousePos.x + " mouse y: " + mousePos.y);

  color pixel_rgb = get(int(mousePos.x), int(mousePos.y));

  int pixelValue = ((int)(red(pixel_rgb))+(int)(green(pixel_rgb))+(int)(blue(pixel_rgb))) / 3;

  if (debug)println("pixelValue: " + pixelValue + " m.x: " + mousePos.x + " m.y: " + mousePos.y );

  if (pixelValue != lastPixelValue) {
    sendValue(pixelValue, useMotor);
    lastPixelValue = pixelValue;
  }

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

public void sendValue(int _v, char _char) {

  arduino.write(Integer.toString(_v));
  arduino.write(_char);
}

public void sendB(int _v) {

  arduino.write(Integer.toString(_v));
  arduino.write('b');
}


public void sendAb(int _a, int _b) {

  arduino.write(Integer.toString(_a));
  arduino.write('a');

  arduino.write(Integer.toString(_b));
  arduino.write('b');
}
