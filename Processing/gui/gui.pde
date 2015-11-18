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
textSize(50);

///Primeros dos digitos
fill(255,0,0);//Rojo
text("9", 109,80);
fill(0,0,255);//Azul
text("9", 141,80);

//Signo
stroke(0,0,0);
text("+", 174,75);

//Segundos dos digitos
fill(255,0,0);//Rojo
text("1", 109,135);
fill(0,0,255);//Azul
text("2", 141,135);

//text("_____", 125,135);

stroke(0,0,0);
line(70, 145, 180, 145);
line(69, 146, 181, 146);
line(69, 147, 181, 147);
line(70, 148, 180, 148);