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

float xFactor_mouseSlowing = 0.9f;
float yFactor_mouseSlowing = 0.9f ;


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

  int xStep = (int)(abs(mouseX-pmouseX) * xFactor_mouseSlowing);
  if (mouseX>pmouseX) {
    _mousePos.x = pmouseX + xStep;
  } else {
    _mousePos.x = pmouseX - xStep;
  }

  int yStep =  (int)(abs(mouseY-pmouseY) * yFactor_mouseSlowing);
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
