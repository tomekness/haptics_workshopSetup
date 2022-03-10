
PImage map;

boolean debug = true;

void setup() {
  //fullScreen();
  size(1440, 900);


  background(180);
  if(debug)println("screen width: " + width + " screen hight: " + height);


  map = loadImage("img/greyScale-2d_1440x900.png");
  image(map, 0, 0);
  
  cursor(CROSS);
}

void draw() {

  // get mouse Pos

  PVector  mousePos = new PVector(mouseX, mouseY);
  //if(debug)println("mouse x: " + mousePos.x + " mouse y: " + mousePos.y);
  
  color pixel_rgb = get(int(mousePos.x), int(mousePos.y));
  
  int pixelValue = ((int)(red(pixel_rgb))+(int)(green(pixel_rgb))+(int)(blue(pixel_rgb))) / 3; 
  
  if(debug)println("pixelValue: " + pixelValue );  
  
}
