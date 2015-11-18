int sensorValue = 0;
int lightSensorPin = A0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  sensorValue = analogRead(lightSensorPin);
  delay(1000);

  Serial.println(sensorValue);
}
