
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
boolean sendToP5 = false;

void setup() {

  Serial.begin(9600);

}


void loop() {

  //check the inputs
  
  int newValue = analogRead(poti);
  
  if(newValue != potiLastVal) {
    sendToP5 = true;
    potiLastVal = newValue;
  }
  
  digitalWrite(13, sendToP5);  // yeah led 

  
  // just send the data when there was a change in the values
  if(sendToP5) {

    Serial.print(potiLastVal);
    
    // end of transmission sign (stop byte) 
    Serial.write(10);  // ascii code for end of line

    sendToP5 = false;
  }


}



