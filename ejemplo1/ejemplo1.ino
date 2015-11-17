void setup() {
  pinMode(2, INPUT); // Configuración del pin 2 como entrada
  Serial.begin(9600); //Inicialización de comunicación serial a 9600 baudios
}
 
void loop() {
  // Transfiere a través del puerto serial el estado digital del pin 2
  Serial.print(digitalRead(2));
  delay(100); //retardo de 100 milisegundos
}
