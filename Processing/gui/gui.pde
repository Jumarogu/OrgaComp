import processing.serial.*; //Libreria para utilizar el puerto serial
import cc.arduino.*;

//Sensores
int lightS0;
int lightS1;
int lightS2;
int lightS3;

//Arduino variables
Arduino arduino;
int life1 = 1;
int life2 = 2;
int life3 = 3;
int life4 = 4;
int life5 = 5;

//Variables para generar numeros para sumar
int num1 = 0;
int num2 = 0;
int num3 = 0;
int num4 = 0;
int res1 = 0;
int res2 = 0;
String signo = "+";
String numero1;
String numero2;
int val1;
int val2;
int random;

//Objeto Operación
Operacion op;

//Variables booleanas
boolean gameOver;
boolean opOver;

void setup(){
  size(1000, 620);
  background(201,89,13);
  //Seting boolean variables to false
  gameOver = false;
  opOver = false;
  
  /*Generación de número aleatorios 
   *creación de objeto Operación  */
  generarNumeros();
  numero1 = num1 + "" +num2;
  numero2 = num3 + "" +num4;
  val1 = Integer.parseInt(numero1);
  val2 = Integer.parseInt(numero2);
  op = new Operacion(val1, val2);
  println(val1 + " + " + val2 + " = " + (val1+val2));
  
  /*Creación objeto Arduino
   *Set the Arduino digital pins as OUTPUTS.
   *Set HIGH digital pins LIFE
   *Set the value for every light sensor
  */
  /*arduino = new Arduino(this, "/dev/tty.usbmodem1411", 57600);
  for (int i = 1; i < 5; i++){
    arduino.pinMode(i, Arduino.OUTPUT);
    arduino.digitalWrite(i, Arduino.HIGH);
  }*/
  lightS0 = 0;
  lightS1 = 1;
  lightS2 = 2;
  lightS3 = 3;
  
}

void draw(){
  
  /*while(!gameOver){
    
    while(!opOver){
      if(arduino.analogRead(lightS0) <= 0){
        print("Funciona!!");
      }
      else if(arduino.analogRead(lightS1) <= 0){
        
      }
      else if(arduino.analogRead(lightS2) <= 0){
        
      }
      else if(arduino.analogRead(lightS3) <= 0){
        
      }
    }
    
  }
  */
//Prueba de sensores
//if(arduino.analogRead(0) <= 0){
//  print("Funciona!!");
//}

//GUI ******************************
  fill(102);//Cuadro de operacion
  rect(25, 25, 200, 200, 10);

  fill(252,166,3);//Cuadro de explicacion
  rect(250, 25, 725, 200, 10);

  fill(148,73,179);//Primer cuadro ELIPSE
  rect(25, 250, 462, 160, 10);
  fill(100);
  ellipse(100, 330, 80, 80);

  fill(52,203,205);//Segundo cuadro RECTANGULO
  rect(515, 250, 462, 160, 10);
  fill(100); 
  rect(553, 290, 80, 80);
  
  fill(101,191,61);//Tercer cuadro TRIANGULO
  rect(25, 435, 462, 160, 10);
  fill(100);
  triangle(103, 475, 63, 555, 143, 555);
  
  fill(254,53,82);//Cuarto cuadro HEXAGONO
  rect(515, 435, 462, 160, 10);
  fill(100);
  noStroke();
  ellipse(591, 516, 91, 91);
  stroke(3);
  line(564, 473, 620, 473); // PRIMERA LINEA SUPERIOR
  line(564, 556, 620, 556); // SEGUNDA LINEA INFERIOR
  line(564, 473, 540, 514); // PRIMERA LINEA IZQUIERDO SUPERIOR
  line(540, 514, 564, 556); // SEGUNDA LINEA IZQUIERDO INFERIOR
  line(620, 473, 644, 514); // PRIMERA LINEA DERECHO SUPERIOR
  line(644, 514, 620, 556); // SEGUNDA LINEA DERECHO INFERIOR
  
  textAlign(CENTER);
  textSize(50);

//FIN GUI 

//RECUADRO SUPERIOR-IZQUIERDO*************
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
  
  //Segundos dos digitos
  fill(255,0,0);//Rojo
  text(res1, 109,195);
  fill(0,0,255);//Azul
  text(res2, 141,195);

  stroke(0,0,0);
  line(70, 145, 180, 145);
  line(69, 146, 181, 146);
  line(69, 147, 181, 147);
  line(70, 148, 180, 148);
//FIN RECUADRO SUPERIOR-IZQUIERDO

//RECUADRO SUPERIOR-DERECHO ***************
 
}
//Método Generar Números *****************
void generarNumeros(){
  num1 = int(random(10));
  num2 = int(random(10));
  num3 = int(random(10));
  num4 = int(random(10));
  
  res1 = num1 + num3;
  res2 = num2 + num4;
  
  if(((res1 >= 10) || (res2 >= 10)) || (num1 < num3) || (num3==0 && num4 == 0) || (num1==0 && num2 == 0)){
    generarNumeros();
  } 
}
//Clase Operacion ******************
class Operacion{
  private int num1;
  private int num2;
  private int resultado;
  
  Operacion(int num1, int num2){
    this.num1 = num1;
    this.num2 = num2;
  }
  boolean isCorrect(int resultado){
    if(this.resultado == resultado){
      return true;
    }
    else{
      return false;
    }
  }
  int getResultado(){
    return this.resultado;
  }
}

// Clase Board ********************
class Board{
  Operacion op;
  boolean resultadosT;
  int[] resultados;
  int rando;
  
  /*Board(Operacion op){
    this.op = op;
    for(int i = 0; i<4; i++){
      resultados[i] = 0;
    }
    generaResultados(this.op.getResultado());
  }
  //Método generaResultados
  int[] generaResultados(int resultado){
<<<<<<< HEAD
     while(!resultados){
      if(this.resultados[random(4)] == null){
        
      }
=======
    int r = 0;
    while(!this.resultadosT){
      rando = int(random(4));
>>>>>>> origin/master
      
      if(this.resultados[rando] == 0){
        if(){
        }
        this.resultados[rando] = int(random(100)); 
        println(this.resultados[i]);
        r++;
      }  
        if(r >= 3){
          this.resultadosT = true;
        }
      }
    }
    return this.resultados;
  }
<<<<<<< HEAD
}

int random(){
  random = int(random(4));*/
=======
>>>>>>> origin/master
}