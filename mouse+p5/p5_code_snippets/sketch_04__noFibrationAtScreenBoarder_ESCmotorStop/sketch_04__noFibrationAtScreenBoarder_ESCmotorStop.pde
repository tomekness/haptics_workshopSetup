import processing.serial.*;

//imports to slow down the mouse
import java.awt.AWTException;
import java.awt.Robot;

boolean debug = true;

PImage map;

// which file to load
String imageFile = "img/path_01.jpg"; //"img/greyScale-2d_1440x900.png";

int lastPixelValue = 0;

Serial arduino;

// it's a or b
char useMotor = 'a';

//////////// vars for slowing down the mosue

Robot robby;

float xFactor_mouseScale = 0.5f;
float yFactor_mouseScale = 0.5f ;


void setup() {

  // setup canvas, images and cursor

  fullScreen();
  //size(1440, 900);

  background(255);
  if (debug)println("screen width: " + width + " screen hight: " + height);

  map = loadImage(imageFile);
  image(map, 0, 0, width, height);

  cursor(CROSS);

  // setup arduino

  println(Serial.list());
  //arduino = new Serial(this, "COM3", 9600);
  arduino = new Serial(this, Serial.list()[3], 115200);

  // init robot to move mouse

  try
  {
    robby = new Robot();
  }
  catch (AWTException e)
  {
    println("Robot class not supported by your system!");
    exit();
  }
}

void draw() {

  // get mouse Pos
  PVector  mousePos = new PVector(mouseX, mouseY);

  // adjust mouse position
  mousePos = adjustMousePos(mousePos);

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
}

public PVector adjustMousePos(PVector  _mousePos) {

  int xStep = (int)(abs(mouseX-pmouseX) * xFactor_mouseScale);
  if (mouseX>pmouseX) {
    _mousePos.x = pmouseX + xStep;
  } else {
    _mousePos.x = pmouseX - xStep;
  }

  int yStep =  (int)(abs(mouseY-pmouseY) * yFactor_mouseScale);
  if (mouseY>pmouseY) {
    _mousePos.y = pmouseY + yStep;
  } else {
    _mousePos.y = pmouseY - yStep;
  }

  robby.mouseMove((int)_mousePos.x, (int)_mousePos.y);

  //println("mx: " + mouseX + " pmx: " + pmouseX + " xStep: " + xStep + " nmx: " + _mousePos.x);
  //println("my: " + mouseY + " pmy: " + pmouseY + " YStep: " + yStep + " nmy: " + _mousePos.y);
  return _mousePos;
}



/////////// motor controll functions


/// the an value to one motor 
public void sendValue(int _v, char _id) {

  arduino.write(Integer.toString(_v));
  arduino.write(_id);
}

// send different values to each motor in one function 
public void sendAandB(int _a, int _b) {

  arduino.write(Integer.toString(_a));
  arduino.write('a');

  arduino.write(Integer.toString(_b));
  arduino.write('b');
}

// send same values to both motors 
public void sendBoth(int _value) {

  arduino.write(Integer.toString(_value));
  arduino.write('a');

  arduino.write(Integer.toString(_value));
  arduino.write('b');
}

//// stop motors on exit 
    void exit() {
      println("exiting");
      sendBoth(255);
      super.exit();
    }
