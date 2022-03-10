// import lib 
import processing.serial.*;




//// arduino vars
Serial arduinoR;
Serial arduinoL;

String nameR = "COM4";
String nameL = "COM5";

int baudrate = 9600;

void setup() {

  println(Serial.list());
  arduinoR = new Serial(this, nameR, baudrate);  // mac
  arduinoL = new Serial(this, nameL, baudrate);  // mac
}


void draw() {

  while (arduinoL.available () > 0) {
    int inByte = arduinoL.read();
    print("left say: ");
    print(char(inByte));
    arduinoR.write(inByte);
  }

  while (arduinoR.available () > 0) {
    int inByteR = arduinoR.read();
    print("right say: ");
    print(char(inByteR));
    arduinoL.write(inByteR);
  }
}

