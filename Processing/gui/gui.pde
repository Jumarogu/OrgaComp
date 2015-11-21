import processing.serial.*; //Libreria para utilizar el puerto serial
import cc.arduino.*;
import javax.swing.JOptionPane;

//Sensores
int lightS1;
int lightS2;
int lightS3;
int lightS4;
int intensidadLuz1;
int intensidadLuz2;
int intensidadLuz3;
int intensidadLuz4;
boolean calibrado1 = false;
boolean calibrado2 = false;
boolean calibrado3 = false;
boolean calibrado4 = false;
boolean calibrar = true;//////////////////////////////////////////////Cambiar a True
boolean respErr1 = false;
boolean respErr2 = false;
boolean respErr3 = false;
boolean respErr4 = false;

int luzOrg1;
int luzOrg2;
int luzOrg3;
int luzOrg4;


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
String mostrar1 = "?", mostrar2 = "?";
int val1;
int val2;
int random;

boolean jugar = true; /////////////////////////////////////////////////Cambiar a True
boolean mDecenas = false;//////////////////////////////////////////////sive para el if de digito() Cambiar a False
int rangoMostrar = 1;// es para el Substring
int tmpRango = 1;// Tiene que ser Copia de rangoMostrar

//Objeto Operación y Board
Operacion op;
Board board;


//Variables booleanas
boolean gameOver;
boolean opOver;
boolean pressBot = false;
int ultimoBot = 5;


void setup(){
  /*

  cambiarRango(true);
  JOptionPane.showMessageDialog(null, "Primer paso, Cual es la suma de las centenas?\n" + "Segundo paso, Cual es la respuesta de la operación?\n" + "                              SUERTE!!");
  */
  size(1000, 620);
  background(201,89,13);
  //Seting boolean variables to false
  gameOver = false;
  opOver = false;
  
  /*Creación objeto Arduino
   *Set the Arduino digital pins as OUTPUTS.
   *Set HIGH digital pins LIFE
   *Set the value for every light sensor
  /*/
  String platformName = System.getProperty("os.name");
  platformName = platformName.toLowerCase();
  if (platformName.indexOf("mac") != -1) {
    println("Detectado: Mac");
    arduino = new Arduino(this, "/dev/tty.usbmodem1411", 57600);//Mac
  }else if(platformName.indexOf("windows") != -1) {
    println("Detectado: Windows.");
    arduino = new Arduino(this, "COM3", 57600); //Windows Depende el COM
  }
  //arduino = new Arduino(this, "COM3", 57600); //Windows Depende el COM
  //arduino = new Arduino(this, "/dev/tty.usbmodem1411", 57600);//Mac
  
  for (int i = 1; i < 6; i++){
    arduino.pinMode(i, Arduino.OUTPUT);
    arduino.digitalWrite(i, Arduino.HIGH);
  }
  
  
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
  //Fondo
  fill(201,89,13);
  rect(0,0,1000,620);

  fill(102);//Cuadro de operacion
  rect(25, 25, 200, 200, 10);

  fill(252,166,3);//Cuadro de explicacion
  rect(250, 25, 725, 200, 10);

  fill(254,53,82);//Primer cuadro HEXAGONO
  rect(25, 250, 462, 160, 10);
  fill(100);
  noStroke();
  triangle(72, 290, 128, 290, 149, 330);//Triangulos para llenar el Hexagono
  triangle(149, 330, 128, 370, 72, 370);
  triangle(72, 370, 51, 330, 72, 290);
  triangle(72, 290, 149, 330, 72, 370);
  stroke(1);
  line(72, 290, 128, 290); // Superior
  line(128, 290, 149, 330); // Derecha Superior
  line(149, 330, 128, 370); // Derecha Inferior
  line(128, 370, 72, 370); // Inferior
  line(72, 370, 51, 330); // Izquierda Inferior
  line(51, 330, 72, 290); // Izquierda Superior
  
  textSize(100);
  fill(52,203,205);
  calcularRango(0);
  text((board.getResultados()[0]+"").substring(rangoMostrar,rangoMostrar+1),300 ,360);
  //text(board.getResultados()[0],300 ,360);

  fill(101,191,61);//Segundo cuadro TRIANGULO
  rect(515, 250, 462, 160, 10);
  fill(100); 
  triangle(553, 370, 593, 290, 633, 370);
  fill(148,73,179);
  calcularRango(1);
  text((board.getResultados()[1]+"").substring(rangoMostrar,rangoMostrar+1),790 ,360);
  //text(board.getResultados()[1],790 ,360);
  
  fill(52,203,205);//Tercer cuadro CUADRADO
  rect(25, 435, 462, 160, 10);
  fill(100);
//  triangle(103, 475, 63, 555, 143, 555);
  rect(63, 475, 80, 80);
  fill(254,53,82);
  calcularRango(2);
  text((board.getResultados()[2]+"").substring(rangoMostrar,rangoMostrar+1),300 ,545);
  //text(board.getResultados()[2],300 ,545);
  
  fill(148,73,179);//Cuarto cuadro CIRCULO
  rect(515, 435, 462, 160, 10);
  fill(100);
  ellipse(591, 516, 80, 80);
  
  fill(101,191,61);
  calcularRango(3);
  text((board.getResultados()[3]+"").substring(rangoMostrar,rangoMostrar+1),790 ,545);
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
  text(mostrar2, 109,195);
  fill(0,0,255);//Azul
  text(mostrar1, 141,195);

  stroke(0,0,0);
  line(70, 145, 180, 145);
  line(69, 146, 181, 146);
  line(69, 147, 181, 147);
  line(70, 148, 180, 148);
//FIN RECUADRO SUPERIOR-IZQUIERDO

//RECUADRO SUPERIOR-DERECHO ***************

  //Opacar Respuestas Erroneas
  color c = color(0, 160);
  fill(c);
  if(respErr4){//Circulo
    rect(515, 435, 462, 160, 10);
  }
  if(respErr3){//Cuadrado
    rect(25, 435, 462, 160, 10);
  }
  if(respErr1){//Hexagono
    rect(25, 250, 462, 160, 10);
  }
  if(respErr2){//Triangulo
    rect(515, 250, 462, 160, 10);
  }
  fill(0);

////////
  ///Bolitas para contar************************
  if(respErr1 || respErr2 || respErr3 || respErr4){
    fill(255,0,0);//Decenas
    rect(275, 50, 180, 150, 10);
    fill(252,166,3);
    rect(280, 55, 170, 140, 10);
    line(280, 124, 450, 124);
    line(280, 126, 450, 126);
    
    /*fill(0,0,255);//Unidades
    rect(495, 50, 180, 150, 10);
    fill(252,166,3);
    rect(500, 55, 170, 140, 10);
    line(500, 124, 670, 124);
    line(500, 126, 670, 126);*/
    fill(0,0,255);//Unidades
    rect(595, 50, 180, 150, 10);
    fill(252,166,3);
    rect(600, 55, 170, 140, 10);
    line(600, 124, 770, 124);
    line(600, 126, 770, 126);
    
    textSize(20);
    fill(255,0,0);
    text("Decenas", 365,45);
    fill(0,0,255);
    text("Unidades", 685,45);
    textSize(50);
    fill(0);
    text("=", 810, 140);
    text("=", 490, 140);
    fill(0,0,255);
    text(mostrar1, 850, 140);//Unidades
    fill(255,0,0);
    text(mostrar2, 530, 140);//Decenas
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
      ellipse(600 + (posX - dist/2),80 + (posY),20,20);
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
      ellipse(600 + (posX - dist/2),145 + (posY),20,20);
      posX+=dist;
      if(i == 4 && num4 != 5){
        dist = 170 / (num4 - 5);
        posX = dist;
        posY += 25;
      }
    }
  }else{
    textSize(40);
    text("Tu puedes! cual es \n la suma de " + ((mDecenas)?num1:num2) + "+" + ((mDecenas)?num3:num4) + "?", 600, 120);
    if(mDecenas){
      fill(255,0,0);
    }else{
      fill(0,0,255);
    }
    text(((mDecenas)?num1:num2), 680, 180);
    text(((mDecenas)?num3:num4), 737, 180); 
  }
  
  if(calibrar){
    textSize(50);
    fill(100);
    rect(0,0, 1000, 620);
    fill(0,0,255);
    rect(400,270, 200, 80,20);
    fill(0);
    text("Jugar!", 500, 325);
    
    textSize(13);
    text("Para empezar a jugar pasa tu mano por las cuatro figuras \t hasta que veas cuatro 'OK'", 500, 380);
    
    noStroke();
    fill(254,53,82);
    triangle(156, 430, 196, 430, 216, 470);
    triangle(216, 470, 196, 510, 156, 510);
    triangle(156, 510, 136, 470, 156, 430);
    triangle(156, 429, 217, 470, 156, 511);
    stroke(1);
    line(156, 430, 196, 430);//Superior
    line(196, 430, 216, 470);//Superior Derecha
    line(216, 470, 196, 510);//Inferior Derecha
    line(196, 510, 156, 510);//Inferior
    line(156, 510, 136, 470);//Inferior Izquierda
    line(136, 470, 156, 430);//Superior Izquierda
    fill(101,191,61);
    triangle(392, 430, 352, 510, 432, 510);
    fill(52,203,205);
    rect(568, 430,80,80);
    fill(148,73,179);
    ellipse(824,470,80,80);
    
    textSize(40);
    fill(0,0,255);
    if(calibrado1){
      text("OK!", 180, 485);
    }
    if(calibrado2){
      text("OK!", 396, 485);
    }
    if(calibrado3){
      text("OK!", 611, 485);
    }
    if(calibrado4){
      text("OK!", 828, 485);
    }
    if(calibrado1 && calibrado2 && calibrado3 && calibrado4){
      calibrar = false;
    }
  }
}

void checar(){
   while(!opOver){
     delay(200);
     println(pressBot + " - " + ultimoBot + " - " + arduino.analogRead(lightS1) + " - " + arduino.analogRead(lightS2) + " - " + arduino.analogRead(lightS3) + " - " + arduino.analogRead(lightS4));
     if(ultimoBot == 1){
       if(arduino.analogRead(lightS1) > intensidadLuz1){
         pressBot = false;
         ultimoBot = 5;
       }
     }else if(ultimoBot == 2){
       if(arduino.analogRead(lightS2) > intensidadLuz2){
         pressBot = false;
         ultimoBot = 5;
       }
     }else if(ultimoBot == 3){
       if(arduino.analogRead(lightS3) > intensidadLuz3){
         pressBot = false;
         ultimoBot = 5;
       }
     }else if(ultimoBot == 4){
       if(arduino.analogRead(lightS4) > intensidadLuz4){
         pressBot = false;
         ultimoBot = 5;
       }
     }
     if(!pressBot){
      if(arduino.analogRead(lightS1) <= intensidadLuz1){
        pressBot = true;
        ultimoBot = lightS1;
        if(digito(board.getResultados()[0],op.getResultado())){
        //if(board.getResultados()[0] == op.getResultado()){
           print("Correcto!!");
           if(mDecenas){
             cInterrogacion(op.getResultado());
             delay(1000);
             opOver = true;
           }else{
             cInterrogacion(op.getResultado());
             delay(1000);
             cambiarRango(true);
           }
        }
        else{
          print("Respuesta incorrecta!!");
          print("Intenta de nuevo!");
          respErr1 = true;
        }
      }
      else if(arduino.analogRead(lightS2) <= intensidadLuz2){
        pressBot = true;
        ultimoBot = lightS2;
        if(digito(board.getResultados()[1],op.getResultado())){
           print("Correcto!!"); 
           if(mDecenas){
             cInterrogacion(op.getResultado());
             delay(1000);
             opOver = true;
           }else{
             cInterrogacion(op.getResultado());
             delay(1000);
             cambiarRango(true);
           }
        }
        else{
          print("Respuesta incorrecta!!");
          print("Intenta de nuevo!");
          respErr2 = true;
        }
      }
      else if(arduino.analogRead(lightS3) <= intensidadLuz3){
        pressBot = true;
        ultimoBot = lightS3;
        if(digito(board.getResultados()[2],op.getResultado())){
          print("Correcto!!"); 
          if(mDecenas){
             cInterrogacion(op.getResultado());
             delay(1000);
             opOver = true;
           }else{
             cInterrogacion(op.getResultado());
             delay(1000);
             cambiarRango(true);
           }
        }
        else{
          print("Respuesta incorrecta!!");
          print("Intenta de nuevo!");
          respErr3 = true;
        }
      }
      else if(arduino.analogRead(lightS4) <= intensidadLuz4){
        pressBot = true;
        ultimoBot = lightS4;
        if(digito(board.getResultados()[3],op.getResultado())){
          print("Correcto!!");
          
          if(mDecenas){
             cInterrogacion(op.getResultado());
             delay(1000);
             opOver = true;
           }else{
             cInterrogacion(op.getResultado());
             delay(1000);
             cambiarRango(true);
           }
        }
        else{
          print("Respuesta incorrecta!!");
          print("Intenta de nuevo!");
          respErr4 = true;
        }
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
  int[] cambiaResultados(){
    int temp = 0;
    int posA = int(random(4));
    int posB = int(random(4));
    for(int i = 0; i < 10; i++){
      temp = this.resultados[posA];
      this.resultados[posA] = this.resultados[posB];
      this.resultados[posB] = temp;
      posA = int(random(4));
      posB = int(random(4));
    }
    return this.resultados;
  }
}


class BasicThread2 implements Runnable {
    // This method is called when the thread runs
    public void run() {
      delay(1000);
      
      luzOrg1 = arduino.analogRead(lightS1);
      luzOrg2 = arduino.analogRead(lightS2);
      luzOrg3 = arduino.analogRead(lightS3);
      luzOrg4 = arduino.analogRead(lightS4);
      /*
      luzOrg1 = 30;
      luzOrg2 = 30;
      luzOrg3 = 30;
      luzOrg4 = 30;
      */
      while(calibrar){
        delay(1000);
        calibrarBotones();
      }
      while(jugar){
        checar();
        println("Nueva Operacion!");
        delay(1000);
        crearOperacion();
      }
    }
}
void calibrarBotones(){
  
  if(luzOrg1 > arduino.analogRead(lightS1)/2){
    intensidadLuz1 = arduino.analogRead(lightS1) + 5;
    calibrado1 = true;
  }
  if(luzOrg2 > arduino.analogRead(lightS2)/2){
    intensidadLuz2 = arduino.analogRead(lightS2) + 5;
    calibrado2 = true;
  }if(luzOrg3 > arduino.analogRead(lightS3)/2){
    intensidadLuz3 = arduino.analogRead(lightS3) + 5;
    calibrado3 = true;
  }
  if(luzOrg4 > arduino.analogRead(lightS4)/2){
    intensidadLuz4 = arduino.analogRead(lightS4) + 5;
    calibrado4 = true;
  }
  
}

void crearOperacion(){
  /*Generación de número aleatorios 
   *creación de objeto Operación  */
  cambiarRango(false);
  generarNumeros();
  opOver = false;
  mostrar1 = mostrar2 = "?";
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
    //println("RangoMostrar = 0  ->" + board.getResultados()[rang]);
  }else{
    //println("Rango Mostrar = TMP (" + tmpRango + ")");
    rangoMostrar = tmpRango;
  }
  println(rangoMostrar);
}
void cambiarRango(boolean rang){
  //println("CambiarRango(" + rang + ")");
  if(rang){
    rangoMostrar = tmpRango = 0;
    mDecenas = true;
  }else{
    rangoMostrar = tmpRango = 1;
    mDecenas = false;
  }
  respErr1 = false;
  respErr2 = false;
  respErr3 = false;
  respErr4 = false;
}
  boolean digito(int dig1, int dig2){//True para Decenas
  int rIzq1;
  int rDer1;
  int rIzq2;
  int rDer2;
  
  if(mDecenas){
    if(dig1 > 9 && dig2 > 9){
      //println("Primero");
      rIzq1 = 0;
      rDer1 = 1;
      rIzq2 = 0;
      rDer2 = 1;
    }else if(dig1 > 9 && dig2 < 10){
      //println("Seg");
      rIzq1 = 1;
      rDer1 = 2;
      rIzq2 = 0;
      rDer2 = 1;
    }else if(dig1 < 10 && dig2 > 9){
      //println("Ter");
      rIzq1 = 0;
      rDer1 = 1;
      rIzq2 = 1;
      rDer2 = 2;
    }else{
      //println("Cuar");
      rIzq1 = 0;
      rDer1 = 1;
      rIzq2 = 0;
      rDer2 = 1;
    }
  }else{
    //println("quint");
    rIzq1 = 1;
    rDer1 = 2;
    rIzq2 = 1;
    rDer2 = 2;
  }
  //println("");
  if((dig1+"").substring(rIzq1,rDer1).equals((dig2+"").substring(rIzq2,rDer2))){
    println((dig1+"").substring(rIzq1,rDer1)  + " = " + (dig2+"").substring(rIzq2,rDer2) + " => True");
    if(!mDecenas){
      board.cambiaResultados();
    }
    return true;
  }else{
    println((dig1+"").substring(rIzq1,rDer1)  + " = " + (dig2+"").substring(rIzq2,rDer2) + " => False");
    return false;
  }
}
void cInterrogacion(int num){
  if(mDecenas){
    mostrar2 = (num+"").substring(0,1);
  }else{
    mostrar1 = (num+"").substring(1,2);
  }
}