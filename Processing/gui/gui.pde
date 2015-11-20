import processing.serial.*; //Libreria para utilizar el puerto serial
import cc.arduino.*;

//Sensores
int lightS1;
int lightS2;
int lightS3;
int lightS4;
int intensidadLuz;

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

boolean jugar = false; //////////////////////////////Cambiar a True
boolean mUnidades = true;
boolean mDecenas = false;
int rangoMostrar = 1;// es para el Substring
int tmpRango = 1;// Tiene que ser Copia de rangoMostrar
int rangoDer = 2;

//Objeto Operación y Board
Operacion op;
Board board;

//Variables booleanas
boolean gameOver;
boolean opOver;

void setup(){
  size(1000, 620);
  background(201,89,13);
  //Seting boolean variables to false
  gameOver = false;
  opOver = false;
  intensidadLuz =4;
  
  /*Creación objeto Arduino
   *Set the Arduino digital pins as OUTPUTS.
   *Set HIGH digital pins LIFE
   *Set the value for every light sensor
  */
  //arduino = new Arduino(this, "COM3", 57600); //Windows Depende el COM
  /*//////////////////////////////////////////////////////////////////////////////////// descomentar esto
  arduino = new Arduino(this, "/dev/tty.usbmodem1411", 57600);//Mac
  for (int i = 1; i < 6; i++){
    arduino.pinMode(i, Arduino.OUTPUT);
    arduino.digitalWrite(i, Arduino.HIGH);
  }
  */
  lightS1 = 1;
  lightS2 = 2;
  lightS3 = 3;
  lightS4 = 4;
  
  /*Generación de número aleatorios 
   *creación de objeto Operación  */
  generarNumeros();
  opOver = false;
  numero1 = num1 + "" +num2;
  numero2 = num3 + "" +num4;
  val1 = Integer.parseInt(numero1);
  val2 = Integer.parseInt(numero2);
  op = new Operacion(val1, val2);
  println(val1 + " + " + val2 + " = " + (val1+val2));
  board = new Board(op);
  
  ///Runnable
  Runnable runnable = new BasicThread2();
  Thread thread = new Thread(runnable);
  thread.start();
}

void draw(){
  
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
  textSize(100);
  fill(52,203,205);
  calcularRango(0);
  text((board.getResultados()[0]+"").substring(rangoMostrar,rangoDer),300 ,360);
  //text(board.getResultados()[0],300 ,360);

  fill(52,203,205);//Segundo cuadro RECTANGULO
  rect(515, 250, 462, 160, 10);
  fill(100); 
  rect(553, 290, 80, 80);
  fill(148,73,179);
  calcularRango(1);
  text((board.getResultados()[1]+"").substring(rangoMostrar,rangoDer),790 ,360);
  //text(board.getResultados()[1],790 ,360);
  
  fill(101,191,61);//Tercer cuadro TRIANGULO
  rect(25, 435, 462, 160, 10);
  fill(100);
  triangle(103, 475, 63, 555, 143, 555);
  fill(254,53,82);
  calcularRango(2);
  text((board.getResultados()[2]+"").substring(rangoMostrar,rangoDer),300 ,545);
  //text(board.getResultados()[2],300 ,545);
  
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
  fill(101,191,61);
  calcularRango(3);
  text((board.getResultados()[3]+"").substring(rangoMostrar,rangoDer),790 ,545);
  //text(board.getResultados()[3],790 ,545);
  /*text(board.getResultados()[3],790 ,545);
  println((test+"").substring(0,1) + " - ");
  */
  
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
  
  //Respuesta
  fill(255,0,0);//Rojo
  text("?", 109,195);
  fill(0,0,255);//Azul
  text("?", 141,195);

  stroke(0,0,0);
  line(70, 145, 180, 145);
  line(69, 146, 181, 146);
  line(69, 147, 181, 147);
  line(70, 148, 180, 148);
//FIN RECUADRO SUPERIOR-IZQUIERDO

//RECUADRO SUPERIOR-DERECHO ***************

////////
  ///Bolitas para contar************************
  fill(255,0,0);//Unidades
  rect(275, 50, 180, 150, 10);
  fill(252,166,3);
  rect(280, 55, 170, 140, 10);
  line(280, 124, 450, 124);
  line(280, 126, 450, 126);
  
  fill(0,0,255);//Decenas
  rect(495, 50, 180, 150, 10);
  fill(252,166,3);
  rect(500, 55, 170, 140, 10);
  line(500, 124, 670, 124);
  line(500, 126, 670, 126);
  
  textSize(20);
  fill(255,0,0);
  text("Decenas", 365,45);
  fill(0,0,255);
  text("Unidades", 585,45);
  textSize(50);
  //////////////Primer digito Decenas
  int dist=0;
  int posY = 0;
  if(num1 != 0){
    if(num1 < 5){
      dist = 170/ num1;
      posY +=12;
    }else{
      dist = 170 / 5;
    }
  }
  int posX = dist;
  fill(255,0,0);
  for(int i = 0; i < num1; i++){
    ellipse(280 + (posX - dist/2),80 + (posY),20,20);
    posX+=dist;
    if(i == 4 && num1 != 5){
      dist = 170 / (num1 - 5);
      posX = dist;
      posY += 25;
    }
  }
  //////////////Segundo Digito Decenas
  dist=0;
  posY = 0;
  if(num3 != 0){
    if(num3 < 5){
      dist = 170/ num3;
      posY +=12;
    }else{
      dist = 170 / 5;
    }
  }
  posX = dist;
  for(int i = 0; i < num3; i++){
    ellipse(280 + (posX - dist/2),145 + (posY),20,20);
    posX+=dist;
    if(i == 4 && num3 != 5){
      dist = 170 / (num3 - 5);
      posX = dist;
      posY += 25;
    }
  }
  //////////////Primer digito Unidades
  dist=0;
  posY = 0;
  if(num2 != 0){
    if(num2 < 5){
      dist = 170/ num2;
      posY +=12;
    }else{
      dist = 170 / 5;
    }
  }
  posX = dist;
  fill(0,0,255);
  for(int i = 0; i < num2; i++){
    ellipse(500 + (posX - dist/2),80 + (posY),20,20);
    posX+=dist;
    if(i == 4 && num2 != 5){
      dist = 170 / (num2 - 5);
      posX = dist;
      posY += 25;
    }
  }
  //////////////Segundo digito Unidades
  dist=0;
  posY = 0;
  if(num4 != 0){
    if(num4 < 5){
      dist = 170/ num4;
      posY +=12;
    }else{
      dist = 170 / 5;
    }
  }
  posX = dist;
  for(int i = 0; i < num4; i++){
    ellipse(500 + (posX - dist/2),145 + (posY),20,20);
    posX+=dist;
    if(i == 4 && num4 != 5){
      dist = 170 / (num4 - 5);
      posX = dist;
      posY += 25;
    }
  }
  //checar();
  //println(arduino.analogRead(1));
}

void checar(){
  
   while(!opOver){
     delay(200);
     println(arduino.analogRead(lightS1) + " - " + arduino.analogRead(lightS2) + " - " + arduino.analogRead(lightS3) + " - " + arduino.analogRead(lightS4));
    if(arduino.analogRead(lightS1) <= intensidadLuz){
      if(board.getResultados()[0] == op.getResultado()){
         print("Correcto!!");
         opOver = true;
      }
      else{
        print("Respuesta incorrecta!!");
        print("Intenta de nuevo!");
      }
    }
    else if(arduino.analogRead(lightS2) <= intensidadLuz){
      if(board.getResultados()[1] == op.getResultado()){
         print("Correcto!!"); 
         opOver = true;
      }
      else{
        print("Respuesta incorrecta!!");
        print("Intenta de nuevo!");
      }
    }
    else if(arduino.analogRead(lightS3) <= intensidadLuz){
      if(board.getResultados()[2] == op.getResultado()){
        print("Correcto!!"); 
        opOver = true;  
      }
      else{
        print("Respuesta incorrecta!!");
        print("Intenta de nuevo!");
      }
    }
    else if(arduino.analogRead(lightS4) <= intensidadLuz){
      if(board.getResultados()[3] == op.getResultado()){
        print("Correcto!!");
        opOver = true;
      }
      else{
        print("Respuesta incorrecta!!");
        print("Intenta de nuevo!");
      }
    }
  }
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
    this.resultado = num1 + num2;
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
  
  Board(Operacion op){
    this.op = op;
    this.resultados = new int[4];
    for(int i = 0; i<4; i++){
      resultados[i] = 0;
    }
    this.resultados = generaResultados(this.op.getResultado());
    for(int i = 0; i<4; i++){
      println(this.resultados[i]);
    }

  }
  //Get resultados
  int[] getResultados(){
    return this.resultados;
  }
  //Método generaResultados
  int[] generaResultados(int resultado){

    for(int i = 0; i< 4; i++){
      this.resultados[i] = int(random(1,100)); 
    }
    this.resultados[int(random(4))] = resultado;
    return this.resultados;
  }
}


class BasicThread2 implements Runnable {
    // This method is called when the thread runs
    public void run() {
      while(jugar){
        delay(1000);
        checar();
        println("Nueva Operacion!");
        delay(1000);
        crearOperacion();
      }
    }
}


void crearOperacion(){
  /*Generación de número aleatorios 
   *creación de objeto Operación  */
  generarNumeros();
  opOver = false;
  numero1 = num1 + "" +num2;
  numero2 = num3 + "" +num4;
  val1 = Integer.parseInt(numero1);
  val2 = Integer.parseInt(numero2);
  op = new Operacion(val1, val2);
  println(val1 + " + " + val2 + " = " + (val1+val2));
  board = new Board(op);
}
void calcularRango(int rang){
  if(board.getResultados()[rang] < 10 ){
    rangoMostrar = 0;
    rangoDer = 1;
  }else{
    rangoDer = 2;
    rangoMostrar = tmpRango;
  }
}
void cambiarRango(boolean rang){
  if(rang){
    rangoMostrar = tmpRango = 0;
    rangoDer = 1;
  }else{
    rangoMostrar = tmpRango = 1;
    rangoDer = 2;
  }
}
boolean digito(int dig1, int dig2, boolean tipo){//True para Decenas
  //(dig1+"").substring(rangoMostrar,rangoDer);
  int rIzq1;
  int rDer1;
  int rIzq2;
  int rDer2;
  
  if(!tipo){
    if(dig1 > 9 && dig2 > 9){
      rIzq1 = 1;
      rDer1 = 2;
      rIzq2 = 1;
      rDer2 = 2;
    }else if(dig1 > 9 && dig2 < 10){
      rIzq1 = 1;
      rDer1 = 2;
      rIzq2 = 0;
      rDer2 = 1;
    }else if(dig1 < 10 && dig2 > 9){
      rIzq1 = 0;
      rDer1 = 1;
      rIzq2 = 1;
      rDer2 = 2;
    }else{
      rIzq1 = 0;
      rDer1 = 1;
      rIzq2 = 0;
      rDer2 = 1;
    }
  }else{
    rIzq1 = 0;
    rDer1 = 1;
    rIzq2 = 0;
    rDer2 = 1;
  }
  if((dig1+"").substring(rIzq1,rDer1).equals((dig2+"").substring(rIzq2,rDer2))){
    println("true");
    return true;
  }else{
    println((dig1+"").substring(rIzq1,rDer1)  + " + " +   (dig2+"").substring(rIzq2,rDer2) + " = false");
    return false;
  }
  
  
  
  
}