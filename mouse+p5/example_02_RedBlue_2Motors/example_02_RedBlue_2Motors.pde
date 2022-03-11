import processing.serial.*;

//imports for scaling mouse movment
import java.awt.AWTException;
import java.awt.Robot;

////////// variables we need but never change

// the heatmap (background image)
PImage map;

// our Serial object we communicate with
Serial arduino;

// to reduce traffic we store the value
//and just send new commands to the arduino if there is a value change
int red_lastPixelValue = 0;
int blue_lastPixelValue = 0;

// this little friend is moving the mouse for us
// so we can scal mousevment to any size we want
Robot robby;

//////////////////////////////////////////////////////

//////////// variables to adjust

// if true we print some information to the terminal
boolean debug = true;
boolean arduinoDebug = false;

// which image to load
String imageFile = "img/rotBlau_test.jpg";
//String imageFile = "img/inferno_googleAI.png";
//String imageFile = "img/plasma-2d_1440x900_2.png";

// which motor to adress it's a or b
char red_useMotor = 'a';
char blue_useMotor = 'b';

// you can limit the motor spped if you like (you could also just change your image : / )
// values should be between 0–255
// keep in mind: the motor controll is inverted --> 0 is on; 255 if off
int red_motorMaxValue = 0;
int red_motorMinvalue = 255;

int blue_motorMaxValue = 0;
int blue_motorMinvalue = 255;


// factor we scale the mouse movment to
// (for example if 0.5 we can move the mouse twice as far)
float xFactor_mouseScale = 0.5f;
float yFactor_mouseScale = 0.5f ;


void setup() {

  ///// setup canvas, images and cursor
  fullScreen();
  //size(1440, 900);  // just for debug reasons
  background(255);
  cursor(CROSS);
  if (debug)println("screen width: " + width + " screen hight: " + height);

  map = loadImage(imageFile);      // load the heat map
  image(map, 0, 0, width, height);    // strech the image across the hole canvas

  ///// setup arduino
  if (debug)println(Serial.list());
  //arduino = new Serial(this, "COM3", 115200);  // for windows
  arduino = new Serial(this, Serial.list()[3], 115200);  // for mac

  //// init robot to move mouse
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

  // pixel color at mouse position
  color pixel_rgb = get(int(mousePos.x), int(mousePos.y));

  // calculate one value from red green blue

  int red_pixelValue = (int)(red(pixel_rgb));
  int blue_pixelValue = (int)(blue(pixel_rgb));

  // here we map the value, just in case you are to lazy to go back to photo shop and change your grafik
  red_pixelValue = (int) map(red_pixelValue, 0, 255, red_motorMaxValue, red_motorMinvalue);
  blue_pixelValue = (int) map(blue_pixelValue, 0, 255, blue_motorMaxValue, blue_motorMinvalue);


  if (debug)println("red_pixelValue: " + red_pixelValue + "blue_pixelValue: " + blue_pixelValue + " m.x: " + mousePos.x + " m.y: " + mousePos.y );

  // if value change send command to arduino
  if (red_pixelValue != red_lastPixelValue) {
    sendValue(red_pixelValue, red_useMotor);
    red_lastPixelValue = red_pixelValue;
  }
  if (blue_pixelValue != blue_lastPixelValue) {
    sendValue(blue_pixelValue, blue_useMotor);
    blue_lastPixelValue = blue_pixelValue;
  }

  // listen to serial arduino for feedback
  while (arduino.available () > 0) {
    int inByte = arduino.read();
    if (arduinoDebug)print(char(inByte));
  }
}


//////////////// helper functins


// function to readjust mouse position
// by moving the mouse not as fast as the user does : )
// yes, it's a bloddy hack, due to the rapoo mouses we use
public PVector adjustMousePos(PVector  _mousePos) {

  int xStep = (int)(abs(mouseX-pmouseX) * xFactor_mouseScale);
  if (mouseX>pmouseX) {  // don't want to think of the proper way to do it… there is no time
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

  // move the mouse
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
