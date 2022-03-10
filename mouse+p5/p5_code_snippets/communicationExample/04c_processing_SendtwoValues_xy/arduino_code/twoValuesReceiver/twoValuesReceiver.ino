

int buf = 0;

int valueOne = 0;
int valueTwo = 0;

char identifyerOne = 'a';
char identifyerTwo = 'b';

void setup(){
  Serial.begin(9600);

}

void loop(){

  if(Serial.available()>0){
    byte temp = Serial.read();

    Serial.print("Received command: ");
    Serial.write(temp);
    Serial.println(" ");

    serialIn(temp);
  }
  //delay(100);
}


void serialIn(byte _in) {

  if (_in >=48 && _in <=57) {    // a number
    // add event to buffer
    buf = buf*10 + _in-48;
  } 
  else if(_in == identifyerOne){     // fist value
    valueOne = buf;
    buf = 0;
    Serial.print("Set vaule One: ");
    Serial.println(valueOne);
  } 
  else if(_in == identifyerTwo){     // second value
    valueTwo = buf;
    buf = 0;
    Serial.print("Set vaule two: ");
    Serial.println(valueTwo);
  } 
}





