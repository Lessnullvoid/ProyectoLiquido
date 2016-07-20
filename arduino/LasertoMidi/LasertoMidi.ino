//Mapeo sensor1 99 - 130
//sensor 2 96 - 122
// sensor 3 102 - 128
// sensor 4 100 - 133

#include <MIDI.h>
int CV1 = A1;
int CV2 = A2;
int CV3 = A3;
int CV4 = A4;

int led = 8;
int led1 = 10;
int led2 = 11;


const int channel = 1;
int CV1val;
int CV2val;
int CV3val;
int CV4val;


int sensorValue1 = 0;
int sensorValue2 = 0;
int sensorValue3 = 0;
int sensorValue4 = 0;




void setup() {
  // put your setup code here, to run once:
  MIDI.begin();
  pinMode(led, OUTPUT);
  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);


}

void loop() {

  //CONTROLAR LOS LEDS CON CADA UNO DE LOS INPUTS PARA VISUALIZAR LA SENAL
 digitalWrite(led, HIGH);
  digitalWrite(led1, HIGH);
  digitalWrite(led2, HIGH);

  int note1;
  int note2;
  int note3;
  int note4;

  CV1val = map(sensorValue1, 0, 1023, 99, 130);
  CV2val = map(sensorValue2, 0, 1023, 99, 122);
  CV3val = map(sensorValue3, 0, 1023, 102, 128);
  CV4val = map(sensorValue4, 0, 1023, 100, 133);



  // put your main code here, to run repeatedly:
  sensorValue1 = analogRead(CV1);
  sensorValue2 = analogRead(CV2);
  sensorValue3 = analogRead(CV3);
  sensorValue4 = analogRead(CV4);


  CV1val = note1;
  CV2val = note2;
  CV3val = note3;
  CV4val = note4;

  
  if (sensorValue1 <= 99) {
 //enviar la nota que se genero con la velocida de CV2
  MIDI.sendNoteOn(sensorValue1, sensorValue2, channel);
//const int value = inPitchValue * MIDI_PITCHBEND_MAX * Settings::Toto;
  MIDI.sendPitchBend(CV1val, channel);
  MIDI.send(AfterTouchPoly, sensorValue1, CV2val, channel);
  delay(500);
  MIDI.sendNoteOff(sensorValue1, sensorValue2, channel);
  }
  else if (sensorValue1 <= 130){
  //enviar la nota que se genero con la velocida de CV2
  MIDI.sendNoteOn(sensorValue1*0.5, sensorValue2*0.5, channel);
//const int value = inPitchValue * MIDI_PITCHBEND_MAX * Settings::Toto;
  MIDI.sendPitchBend(CV1val, channel);
  MIDI.send(AfterTouchPoly, sensorValue1, CV2val, channel);
  delay(500);
  MIDI.sendNoteOff(sensorValue1, sensorValue2, channel);
 }

 Serial.print(sensorValue1, DEC);         
  Serial.print("\t S1:");              
  Serial.print(sensorValue2, DEC);    
  Serial.print("\t S2:");                
  Serial.print(sensorValue3, DEC);    
  Serial.print("\t S3:");               
  Serial.print(sensorValue4, DEC);    
  Serial.print("\t S4:"); 
  Serial.print(CV1val, DEC);    
  Serial.print("\t CV1:");  
  Serial.print(CV2val, DEC);    
  Serial.print("\t CV2:");  
  Serial.print(CV3val, DEC);    
  Serial.print("\t CV3:"); 
  Serial.print(CV4val, DEC);    
  Serial.print("\t CV4:"); 
  Serial.println();   

}

