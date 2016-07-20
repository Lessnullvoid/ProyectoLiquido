
const int NUM_READINGS = 10;
const int NUM_SENSORS = 5;
const int MSG_HEADER = 0xAB;

// PINS
int sensorPin[NUM_SENSORS] = {1, 2, 3, 4, 5}; // analog input pins for sensors

// SENSOR VARIABLES
int readings[NUM_SENSORS][NUM_READINGS]; // reading values for each sensor
int readingIndex[NUM_SENSORS];           // index of current reading, per sensor
int readingSum[NUM_SENSORS];             // running sum of readings, per sensor
int readingAverage[NUM_SENSORS];         // average value of last readings, per sensor
int ambientLight[NUM_SENSORS];           // ambient light threshold value, per sensor


// SERIAL COMMUNICATION
byte serialMsg[3];

void setup() {
  Serial.begin(57600);
  serialMsg[0] = serialMsg[1] = serialMsg[2] = 0x00;

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

  // sensor smoothing
  for (int i = 0; i < NUM_SENSORS; i++) {
    readingSum[i] -= readings[i][readingIndex[i]];
    readings[i][readingIndex[i]] = analogRead(sensorPin[i]) - ambientLight[i];
    readingSum[i] += readings[i][readingIndex[i]];

    short readingAverageShort = (short)readings[i][readingIndex[i]];

    // send 3 bytes per value: HHHH_HHHH AAAA_VVVV VVVV_VVVV
    // where HHHH_HHHH = 8-bit fixed header
    //       AAAA = which pin [0,15] (only need [1,5])
    //       VVVV VVVV_VVVV = 12 bits of data [0,4095] (only need [0,1023])
    serialMsg[0] = (MSG_HEADER&0xFF);
    serialMsg[1] = ((sensorPin[i]<<4)&0xF0) | ((readingAverageShort>>8)&0x0F);
    serialMsg[2] = (readingAverageShort&0xFF);

    Serial.write(serialMsg[0]);
    Serial.write(serialMsg[1]);
    Serial.write(serialMsg[2]);
    Serial.flush();

    readingIndex[i] += 1;
    if (readingIndex[i] >= NUM_READINGS)
      readingIndex[i] = 0;
  }

}
