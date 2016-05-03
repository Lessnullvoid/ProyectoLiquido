#include <Stepper.h>


const int numReadings = 10;

#define STEPS 200

int readings[numReadings];      // the readings from the analog input
int readings2[numReadings];
int readings3[numReadings];
int readings4[numReadings];
int readings5[numReadings];

Stepper stepper(STEPS, 4, 5, 6, 7);

int Myindex = 0; // the index of the current reading
int Myindex2 = 0;
int Myindex3 = 0;
int Myindex4 = 0;
int Myindex5 = 0;

int total = 0;                  // the running total
int total2 = 0;
int total3 = 0;
int total4 = 0;
int total5 = 0;

int average = 0;                // the average
int average2 = 0;
int average3 = 0;
int average4 = 0;
int average5 = 0;

//ADD ARRAY OF LASERS
//ADD ARRAY OF RECEIVERS
//CONTROL STEPER SPEED

int lasers[] = {3, 4, 5, 6, 9};
const byte POTENTIOMETER = 6;
const byte MOTORCONTROL = 7;
const byte MOTOR = 10;

const byte LASER = 3;
const byte LASER2 = 4;
const byte LASER3 = 5;
const byte LASER4 = 6;
const byte LASER5 = 9;

int reading;

int value;
int value2;
int value3;
int value4;
int value5;

int inputPin = 1;
int inputPin2 = 2;
int inputPin3 = 3;
int inputPin4 = 4;
int inputPin5 = 5;

int ambientLight;
int ambientLight2;
int ambientLight3;
int ambientLight4;
int ambientLight5;

void setup() {
  Serial.begin(9600);
  Serial.println("stepper runing");
  stepper.setSpeed(30);

  pinMode(LASER, OUTPUT);
  pinMode(LASER2, OUTPUT);
  pinMode(LASER3, OUTPUT);
  pinMode(LASER4, OUTPUT);
  pinMode(LASER5, OUTPUT);

  int sum = 0;
  int sum2 = 0;
  int sum3 = 0;
  int sum4 = 0;
  int sum5 = 0;


  for (int thisReading = 0; thisReading < numReadings; thisReading++)
  { readings[thisReading] = 0;
    sum = sum + analogRead(inputPin);//hacer lectura del sensor;
    delay(1);
  }


  for (int thisReading = 0; thisReading < numReadings; thisReading++)
  { readings2[thisReading] = 0;
    sum2 = sum2 + analogRead(inputPin2);//hacer lectura del sensor;
    delay(1);
  }

  for (int thisReading = 0; thisReading < numReadings; thisReading++)
  { readings3[thisReading] = 0;
    sum3 = sum3 + analogRead(inputPin3);//hacer lectura del sensor;
    delay(1);
  }

  for (int thisReading = 0; thisReading < numReadings; thisReading++)
  { readings4[thisReading] = 0;
    sum4 = sum4 + analogRead(inputPin4);//hacer lectura del sensor;
    delay(1);
  }

  for (int thisReading = 0; thisReading < numReadings; thisReading++)
  { readings5[thisReading] = 0;
    sum5 = sum5 + analogRead(inputPin5);//hacer lectura del sensor;
    delay(1);
  }

  ambientLight = sum / numReadings;
  ambientLight2 = sum2 / numReadings;
  ambientLight3 = sum3 / numReadings;
  ambientLight4 = sum4 / numReadings;
  ambientLight5 = sum5 / numReadings;


}

void loop() {

  Serial.println("Forward");
  stepper.step(STEPS);
  //Serial.println("Backward");
  //stepper.step(-STEPS);

  //Laser control
  reading = analogRead(POTENTIOMETER);
  value = map(reading, 0, 1024, 0, 255);
  analogWrite(LASER, value);
  analogWrite(LASER2, value2);
  analogWrite(LASER3, value3);
  analogWrite(LASER4, value4);
  analogWrite(LASER5, value5);


  //Sensor smoothing
  total = total - readings[Myindex];
  readings[Myindex] = analogRead(1) - ambientLight;
  total = total + readings[Myindex];
  Myindex = Myindex + 1;

  //Sensor smoothing
  total2 = total2 - readings2[Myindex2];
  readings2[Myindex2] = analogRead(2) - ambientLight2;
  total2 = total2 + readings2[Myindex2];
  Myindex2 = Myindex2 + 1;

  //Sensor smoothing
  total3 = total3 - readings3[Myindex3];
  readings3[Myindex3] = analogRead(3) - ambientLight3;
  total3 = total3 + readings3[Myindex3];
  Myindex3 = Myindex3 + 1;

  //Sensor smoothing
  total4 = total4 - readings4[Myindex4];
  readings4[Myindex4] = analogRead(4) - ambientLight4;
  total4 = total4 + readings4[Myindex4];
  Myindex4 = Myindex4 + 1;

  //Sensor smoothing
  total5 = total5 - readings5[Myindex5];
  readings5[Myindex5] = analogRead(5) - ambientLight5;
  total5 = total5 + readings5[Myindex5];
  Myindex5 = Myindex5 + 1;

  if (Myindex >= numReadings)
    Myindex = 0;

  if (Myindex2 >= numReadings)
    Myindex2 = 0;

  if (Myindex3 >= numReadings)
    Myindex3 = 0;

  if (Myindex4 >= numReadings)
    Myindex4 = 0;

  if (Myindex5 >= numReadings)
    Myindex5 = 0;

  // calculate the average and print:
  average = total / numReadings;
  average2 = total2 / numReadings;
  average3 = total3 / numReadings;
  average4 = total4 / numReadings;
  average5 = total5 / numReadings;


  Serial.print(average);
  Serial.print("\t Sensor1:");
  Serial.print(average2);
  Serial.print("\t Sensor2:");
  Serial.print(average3);
  Serial.print("\t Sensor3:");
  Serial.print(average4);
  Serial.print("\t Sensor4:");
  Serial.print(average5);
  Serial.print("\t Sensor5:");
  Serial.println();
  delay(10);


  //agregar libreria y controlar el motor por driver

}


