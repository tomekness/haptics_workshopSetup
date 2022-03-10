/*
 *  complex_protocol
 *  
 *  Sends the values of a potentiometer 
 *  to the serial 
 *  processing is receiving 
 *    and draws a graphical representation.
 * 
 *  the file is based on the Arduino meets Procesing Project  
 *  by Melvin Ochsmann for Malm� University
 *
 *  copyleft tomek_n | for HfG Schwäbisch Gmünd | 2012
 *
 */


int poti = A0;
int potiLastVal = 0;

int ldr = A1;
int ldrLastVal = 0;

boolean sendToP5 = false;

void setup() {

  Serial.begin(9600);

}


void loop() {


  //check the inputs
  int tmpVal = analogRead(poti);
  if(tmpVal != potiLastVal) {
    sendToP5 = true;
    potiLastVal = tmpVal;
  }
  
  int tmpVal2 = analogRead(ldr); 
  if(tmpVal2 != ldrLastVal) {
    sendToP5 = true;
    ldrLastVal = tmpVal2;
  }

  digitalWrite(13, sendToP5);


  // just send the data when there was a change in the values

  if(sendToP5) {

    // send value
    Serial.print(potiLastVal);
    // send id
    Serial.print('a');  // ascii code for end of line

    // send value
    Serial.print(ldrLastVal);
    // send id
    Serial.print('b');  // ascii code for end of line

    sendToP5 = false;
  }


}



