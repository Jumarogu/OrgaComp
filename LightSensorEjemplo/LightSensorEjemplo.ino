int sensorValue = 0;
int lightSensorPin0 = A0;
int lightSensorPin1 = A1;
int lightSensorPin2 = A3;
int lightSensorPin3 = A4;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
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
