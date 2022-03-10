
boolean debug = false;
boolean debugViaSerial = false;

// motors are invertet (m1 connected to 5v and m2 connected to 3,3V)
int m1 = 10;
int m2 = 11;

// communicaiton vars

int buf = 0;

int valueOne = 255;
int valueTwo = 255;

char identifyerOne = 'a';
char identifyerTwo = 'b';


void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  if (debug)Serial.print("init board");

  pinMode(m1, OUTPUT);
  pinMode(m2, OUTPUT);

}

void loop() {
  
  // checkSerial For Data
  if(Serial.available()>0){
    byte temp = Serial.read();

    if(debugViaSerial)Serial.print("Received command: ");
    if(debugViaSerial)Serial.write(temp);
    if(debugViaSerial)Serial.println(" ");

    serialIn(temp);
  }
 
  analogWrite(m1, valueOne);
  analogWrite(m2, valueTwo);

}

void serialIn(byte _in) {

  if (_in >=48 && _in <=57) {    // a number
    // add event to buffer
    buf = buf*10 + _in-48;
  } 
  else if(_in == identifyerOne){     // fist value
    valueOne = buf;
    buf = 0;
    if(debugViaSerial)Serial.print("Set vaule One: ");
    if(debugViaSerial)Serial.println(valueOne);
  } 
  else if(_in == identifyerTwo){     // second value
    valueTwo = buf;
    buf = 0;
    if(debugViaSerial)Serial.print("Set vaule two: ");
    if(debugViaSerial)Serial.println(valueTwo);
  } 
}
