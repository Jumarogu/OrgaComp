import processing.serial.*; //Libreria para utilizar el puerto serial
import cc.arduino.*;
Arduino arduino;

size(1000, 620);
background(201,89,13);
noStroke();

fill(102);//Cuadro de operacion
rect(25, 25, 200, 200);

fill(252,166,3);//Cuadro de explicacion
rect(250, 25, 725, 200);

fill(148,73,179);//Primer cuadro
rect(25, 250, 462, 160);

fill(52,203,205);//Segundo cuadro
rect(515, 250, 462, 160);

fill(101,191,61);//Tercer cuadro
rect(25, 435, 462, 160);
          
fill(254,53,82);//Cuarto cuadro
rect(515, 435, 462, 160);



textAlign(CENTER);
textSize(32);
text("12+12", 125,25);

void setup(){

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

}