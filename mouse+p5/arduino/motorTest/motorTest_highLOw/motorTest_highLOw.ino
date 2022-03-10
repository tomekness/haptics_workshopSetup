
boolean debug = true;

// motors are invertet (m1 connected to 5v and m2 connected to 3,3V)
int m1 = 10;
int m2 = 11;

void setup() {
  // put your setup code here, to run once:
Serial.begin(115200);
if(debug)Serial.print("init board");

pinMode(m1, OUTPUT);
pinMode(m2, OUTPUT);

}

void loop() {

if(debug)Serial.println("HIGH");

digitalWrite(m1, HIGH);
digitalWrite(m2, HIGH);

delay(1000);

if(debug)Serial.println("LOW");

digitalWrite(m1, LOW);
digitalWrite(m2, LOW);

delay(1000);
  
}
