
/* simple one byte communicaiton */
/* from processing to arduino */
/* 2012 - tomek_n - for hfg gmuend */

int red = 2;    // led pin
int green = 3;  // led pin

void setup() {

  Serial.begin(9600);  // set serial speed and start communication

  pinMode(red, OUTPUT);
  pinMode(green, OUTPUT);

  digitalWrite(red, LOW);
  digitalWrite(green, LOW);
}
void loop() {

  // when you receive data:
  if (Serial.available() > 0) {

    //read the incoming byte:
    byte incomingByte = Serial.read();

    // say what you've got:
    Serial.print("I received: ");
    Serial.write(incomingByte);	

    if(incomingByte == 'r') {
      digitalWrite(red, HIGH);
      digitalWrite(green, LOW);
      Serial.println(" (means red, isn't it)");	  

    } else if(incomingByte == 'g') {
      digitalWrite(red, LOW);
      digitalWrite(green, HIGH);
      Serial.println(" (means green, isn't it)");
    }


  }


}



