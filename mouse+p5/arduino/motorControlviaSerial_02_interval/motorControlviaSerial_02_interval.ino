
boolean debug = false;
boolean debugViaSerial = false;

// motors are invertet (m1 connected to 5v and m2 connected to 3,3V)
int m1 = 10;
int m2 = 11;

// communicaiton vars

int buf = 0;
int loopCount = 0;
boolean highTime = true;

// value 1 interval
// value 2 intensitity
int valueOne = 255;
int valueTwo = 150;

int maxIntervalLength = 500; // in microseconds
int interval = 255;

char identifyerOne = 'a';
char identifyerTwo = 'b';


void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  if (debug)Serial.print("init board");

  pinMode(m1, OUTPUT);
  pinMode(m2, OUTPUT);

  analogWrite(m1, 255);
  analogWrite(m2, 255);


}

void loop() {

  // checkSerial For Data
  if (Serial.available() > 0) {
    byte temp = Serial.read();

    if (debugViaSerial)Serial.print("Received command: ");
    if (debugViaSerial)Serial.write(temp);
    if (debugViaSerial)Serial.println(" ");

    serialIn(temp);
  }

  calculateIntervall();
  loopCount++;

  if (highTime) {
    if (loopCount > (maxIntervalLength - interval)) {
      highTime = !highTime;
      loopCount = 0;
    } else {
      analogWrite(m1, valueTwo);
    }
  } else {
    if (loopCount > interval) {
      highTime = !highTime;
      loopCount = 0;
    } else {
      analogWrite(m1, 255);
    }
  }

  // global delay
  delay(1);

}

void calculateIntervall() {
  interval = ((double)valueOne * (double)maxIntervalLength) / (double)255;
  //Serial.println(interval);
}


void serialIn(byte _in) {

  if (_in >= 48 && _in <= 57) {  // a number
    // add event to buffer
    buf = buf * 10 + _in - 48;
  }
  else if (_in == identifyerOne) {   // fist value
    valueOne = buf;
    buf = 0;
    if (debugViaSerial)Serial.print("Set vaule One: ");
    if (debugViaSerial)Serial.println(valueOne);
  }
  else if (_in == identifyerTwo) {   // second value
    valueTwo = buf;
    buf = 0;
    if (debugViaSerial)Serial.print("Set vaule two: ");
    if (debugViaSerial)Serial.println(valueTwo);
  }
}
