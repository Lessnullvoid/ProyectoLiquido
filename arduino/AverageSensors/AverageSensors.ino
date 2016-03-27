#define NUMSENSORS 5
#define NUMREADINGS 10

int readings[NUMSENSORS][NUMREADINGS];      // the readings from the analog input
int Myindex = 0;                            // the index of the current reading
float total = 0;                            // the running total
float average[NUMSENSORS];                      // the average
float totalAverage;
int i, j;
int ambientLight;
int inputPin[NUMSENSORS] = {1, 2, 3, 4, 5};
int reading;
int control = 6;

void setup()
{
  Serial.begin(9600);
  int sum = 0;
  for (i = 0; i < NUMSENSORS; i++)
  {
    for (j = 0; j < NUMREADINGS; j++)
    {
      readings[i][j] = 0;    // Clear the data
      sum = sum + analogRead(inputPin[i]);
      delay(1);
    }
  }

  ambientLight = sum / NUMREADINGS;
}

void loop()
{
  for (i = 0; i < NUMSENSORS; i++)   // This handles the data for each sensor
  {
    for (j = 0; j < NUMREADINGS - 1; j++)
    {
      readings[i][j + 1] = readings[i][j]; // Shift to make room for the new reading
    }
    readings[i][0] = analogRead(inputPin[i]) - ambientLight; // get the latest value
  }

  for (i = 0; i < NUMSENSORS; i++) // Average each sensor
  {
    total = 0;                    // Reset the total for each sensor
    for (j = 0; j < NUMREADINGS; j++)
      total += readings[i][j];
    average[i] = total / NUMREADINGS;

  }

  total = 0;                    // Reset total again for use with totalAverage

  for (i = 0; i < NUMSENSORS; i++) // Average all sensors together
  {
    total += average[i];
  }

  average[i] = total / NUMSENSORS;

  //totalAverage = total / NUMSENSORS;
  Serial.println(readings[i][0]);      
}
