const int numReadings = 10;

int readings[numReadings];      // the readings from the analog input
int index = 0;                  // the index of the current reading
int total = 0;                  // the running total
int average = 0;                // the average

const byte POTENTIOMETER = 0;
const byte LASER = 9;
int reading;
int value;
int inputPin = A4;
int ambientLight;

void setup() {
  Serial.begin(9600);
  pinMode(LASER, OUTPUT);
  
  int sum = 0;

  for (int thisReading = 0; thisReading < numReadings; thisReading++)
  {  readings[thisReading] = 0; 
   sum = sum + analogRead(inputPin);//hacer lectura del sensor;
    delay(1);
  }

ambientLight = sum / numReadings;

}

void loop() { 
    //Laser control
  reading = analogRead(POTENTIOMETER);
  value = map(reading, 0, 1024, 0, 255);   
  analogWrite(LASER, value);

  //Sensor smoothing 
  total= total - readings[index];         
  readings[index] = analogRead(4) - ambientLight; 
  total= total + readings[index];       
  index = index + 1;                    

  if (index >= numReadings)              
    index = 0;                           

  // calculate the average and print:
  average = total / numReadings;         
  Serial.println(average); 
  Serial.print("\n Photoresistor:");  
  delay(1);        

}

