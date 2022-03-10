
boolean debug = true;

// motors are invertet (m1 connected to 5v and m2 connected to 3,3V)
int m1 = 10;
int m2 = 11;

int aValue = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  //if (debug)Serial.print("init board");

  pinMode(m1, OUTPUT);
  pinMode(m2, OUTPUT);

}

void loop() {

  aValue = (aValue+1) % 255;

  analogWrite(m1, aValue);
  analogWrite(m2, aValue);

  delay(40);

  if (debug)Serial.println(aValue);

}
