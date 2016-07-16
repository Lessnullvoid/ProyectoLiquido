#include <Stepper.h>
//int led = 11;
int led1 = 10;
int led2 = 9;
int led3 = 8;

// change this to the number of steps on your motor
#define STEPS 200

// create an instance of the stepper class, specifying
// the number of steps of the motor and the pins it's
// attached to
Stepper stepper(STEPS, 2, 3, 5, 6);


void setup()
{
  Serial.begin(9600);
  Serial.println("Stepper test!");
 // pinMode(led, OUTPUT);
  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);
  pinMode(led3, OUTPUT);

  // set the speed §of the motor to 30 RPMs
  stepper.setSpeed(3);
}

void loop()
{
  stepper.step(STEPS);
  digitalWrite(led, HIGH);
  

  stepper.step(STEPS);
  digitalWrite(led, LOW);
  digitalWrite(led1, HIGH);

  stepper.step(STEPS);
  digitalWrite(led1, LOW);
  digitalWrite(led2, HIGH);

  stepper.step(STEPS);
  digitalWrite(led2, LOW);
  digitalWrite(led3, HIGH);

  stepper.step(STEPS);
  digitalWrite(led3, LOW);
  digitalWrite(led2, HIGH);

  stepper.step(STEPS);
  digitalWrite(led2, LOW);
  digitalWrite(led1, HIGH);

  stepper.step(STEPS);
  digitalWrite(led1, LOW);
  digitalWrite(led, HIGH);

  stepper.step(STEPS);
  digitalWrite(led, LOW);
  digitalWrite(led1, HIGH);

  stepper.step(STEPS);
  digitalWrite(led1, LOW);
  digitalWrite(led3, HIGH);

  stepper.step(STEPS);
  digitalWrite(led3, LOW);
  digitalWrite(led, HIGH);



}
