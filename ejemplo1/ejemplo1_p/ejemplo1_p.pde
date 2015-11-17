import processing.serial.*; //Libreria para utilizar el puerto serial
import cc.arduino.*;
Arduino arduino;

void setup() {
  size(400, 400);     //creación de la ventana para el diseño de la interfaz
  background(200);    //fondo de la ventana
  textSize(20);       //tamaño del texto para la interfaz

  // Modify this line, by changing the "0" to the index of the serial
  // port corresponding to your Arduino board (as it appears in the list
  // printed by the line above).
  arduino = new Arduino(this, "/dev/tty.usbmodem1411", 57600);
  
  // Alternatively, use the name of the serial port corresponding to your
  // Arduino (in double-quotes), as in the following line.
  //arduino = new Arduino(this, "/dev/tty.usbmodem621", 57600);
  
  // Set the Arduino digital pins as inputs.
  for (int i = 0; i <= 13; i++)
    arduino.pinMode(i, Arduino.INPUT);
}
 
void draw(){
background(200);    
if(arduino.digitalRead(2) == Arduino.HIGH)
{
    stroke(0,255,0);
    fill(0,255,0);
    ellipse(width/2, height/2, 100,100);
    fill(0);
    textAlign(CENTER);
    text("EL PUSH BUTTON NO ESTÁ PRESIONADO",width/2,100);
}
else
{
  stroke(255,0,0);
  fill(255,0,0);
  ellipse(width/2, height/2, 80,80);
  fill(0);
  textAlign(CENTER);
  text("EL PUSH BUTTON ESTÁ PRESIONADO",width/2,100);
}
}