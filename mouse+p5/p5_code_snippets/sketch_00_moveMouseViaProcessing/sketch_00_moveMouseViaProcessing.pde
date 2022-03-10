
import java.awt.AWTException;
import java.awt.Robot;


Robot robby;

float xFactor_mouseSlowing = 1.5f;
float yFactor_mouseSlowing = 1.5f ;

void setup()
{
  //size(1440, 900);
  fullScreen();
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

void draw()
{

  PVector newMousePos =  new PVector(0,0);
  
  int xStep = (int)(abs(mouseX-pmouseX) / xFactor_mouseSlowing);
  if (mouseX>pmouseX) {
    newMousePos.x = pmouseX + xStep;
  } else {
    newMousePos.x = pmouseX - xStep;
  }

  int yStep =  (int)(abs(mouseY-pmouseY) / yFactor_mouseSlowing);
  if (mouseY>pmouseY) {
    newMousePos.y = pmouseY + yStep;
  } else {
    newMousePos.y = pmouseY - yStep;
  }

    robby.mouseMove((int)newMousePos.x, (int)newMousePos.y);


//println("mx: " + mouseX + " pmx: " + pmouseX + " xStep: " + xStep + " nmx: " + newMousePos.x);
println("my: " + mouseY + " pmy: " + pmouseY + " YStep: " + yStep + " nmy: " + newMousePos.y);
 
}
