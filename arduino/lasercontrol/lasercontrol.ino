#include <Stepper.h>

const int STEPS = 200;
const int NUM_READINGS = 10;
const int NUM_SENSORS = 5;

// PINS
int laserPin[NUM_SENSORS] = {3, 4, 5, 6, 9};  // output pins for lasers
int sensorPin[NUM_SENSORS] = {1, 2, 3, 4, 5}; // analog input pins for sensors
const int LASER_POT_PIN = 6;                  // analog input for laser pwm control

// SENSOR VARIABLES
int readings[NUM_SENSORS][NUM_READINGS]; // reading values for each sensor
int readingIndex[NUM_SENSORS];           // index of current reading, per sensor
int readingSum[NUM_SENSORS];             // running sum of readings, per sensor
int readingAverage[NUM_SENSORS];         // average value of last readings, per sensor
int ambientLight[NUM_SENSORS];           // ambient light threshold value, per sensor

// LASER VARIABLES
int laserPotValue;
int laserOutput[NUM_SENSORS];

// MOTOR
const int MOTORCONTROL = 7;
const int MOTOR = 10;
Stepper stepper(STEPS, 4, 5, 6, 7);

void setup() {
  Serial.begin(9600);
  Serial.println("stepper runing");
  stepper.setSpeed(30);

  // set up laser pins as output
  for (int i = 0; i < NUM_SENSORS; i++) {
    pinMode(laserPin[i], OUTPUT);
  }

  // init sensor reading arrays
  for (int i = 0; i < NUM_SENSORS; i++) {
    readingIndex[i] = 0;
    readingSum[i] = 0;
    readingAverage[i] = 0;

    // determine ambient light values for each sensor
    for (int j = 0; j < NUM_READINGS; j++) {
      readings[i][j] = 0;
      readingSum[i] += analogRead(sensorPin[i]);
      delay(1);
    }
    ambientLight[i] = readingSum[i] / NUM_READINGS;
    readingSum[i] = 0;
  }
}

void loop() {
  Serial.println("Forward");
  stepper.step(STEPS);
  //Serial.println("Backward");
  //stepper.step(-STEPS);

  //Laser control
  laserPotValue = analogRead(LASER_POT_PIN);
  for (int i = 0; i < NUM_SENSORS; i++) {
    int laserValue = map(laserPotValue, 0, 1024, 0, 255);
    analogWrite(laserPin[i], laserValue);
  }

  // sensor smoothing
  for (int i = 0; i < NUM_SENSORS; i++) {
    readingSum[i] -= readings[i][readingIndex[i]];
    readings[i][readingIndex[i]] = analogRead(sensorPin[i]) - ambientLight[i];
    readingSum[i] += readings[i][readingIndex[i]];
    readingIndex[i] += 1;
    if (readingIndex[i] >= NUM_READINGS)
      readingIndex[i] = 0;
  }

  // calculate the readingAverage and print:
  for (int i = 0; i < NUM_SENSORS; i++) {
    readingAverage[i] = readingSum[i] / NUM_READINGS;
  }

  // print values to serial
  for (int i = 0; i < NUM_SENSORS; i++) {
    Serial.print("\t Sensor[");
    Serial.print(i);
    Serial.print("]: ");
    Serial.print(readingAverage[i]);
  }

  delay(10);
  // agregar libreria y controlar el motor por driver
}


