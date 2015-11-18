import processing.serial.*; //Libreria para utilizar el puerto serial
import cc.arduino.*;
Arduino arduino;
int num1 = 0;
int num2 = 0;
int num3 = 0;
int num4 = 0;
int resultado = 0;
String signo = "+";

void setup(){
  size(1000, 620);
  background(201,89,13);

  // port corresponding to your Arduino board (as it appears in the list
  // printed by the line above).
  //arduino = new Arduino(this, "/dev/tty.usbmodem1411", 57600);
  
  // Set the Arduino digital pins as inputs.
  //for (int i = 0; i <= 13; i++)
    //arduino.pinMode(i, Arduino.INPUT);
  
}

void draw(){

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
  textSize(50);

  ///Primeros dos digitos
  fill(255,0,0);//Rojo
  text(num1, 109,80);
  fill(0,0,255);//Azul
  text(num2, 141,80);

  //Signo
  stroke(0,0,0);
  text(signo, 174,75);

  //Segundos dos digitos
  fill(255,0,0);//Rojo
  text(num3, 109,135);
  fill(0,0,255);//Azul
  text(num4, 141,135);


  stroke(0,0,0);
  line(70, 145, 180, 145);
  line(69, 146, 181, 146);
  line(69, 147, 181, 147);
  line(70, 148, 180, 148);
}