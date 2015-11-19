#include <Operacion.h>
int sensorValue = 0;

int life1 = 1;
int life2 = 2;
int life3 = 3;
int life4 = 4;
int life5 = 5;

int lightSensorPin0 = A0;
int lightSensorPin1 = A1;
int lightSensorPin2 = A3;
int lightSensorPin3 = A4;
//OPERACIONES
Operacion op;

void setup() {
  Serial.begin(9600);
  // Pin Mode Lifes
  pinMode(life1, HIGH);
  pinMode(life2, HIGH);
  pinMode(life3, HIGH);
  pinMode(life4, HIGH);
  pinMode(life5, HIGH);
 
}

void loop() {
  
  // put your main code here, to run repeatedly:
  sensorValue = analogRead(lightSensorPin0);
  Serial.println(sensorValue);
  delay(800);
  
  sensorValue = analogRead(lightSensorPin1);
  Serial.println(sensorValue);
  delay(800);
  
  sensorValue = analogRead(lightSensorPin2);
  Serial.println(sensorValue);
  delay(800);
  
  sensorValue = analogRead(lightSensorPin3);
  Serial.println(sensorValue);
  delay(800);
  
  Serial.println("DONE");
}

