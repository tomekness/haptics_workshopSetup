
byte incomingByte = 0;  

int count = 0;
int incom = 0;

void setup() {
  
  Serial.begin(9600);
  Serial.write("1");  
}

void loop() {

	// send data only when you receive data:
	if (Serial.available() > 0) {
		// read the incoming byte:
		incomingByte = Serial.read();
                incom  = incomingByte - 48;
	}

        if(count < incom) {
        
        count = incom +1;
        Serial.print(count);
        }	
        delay(1000);
}

