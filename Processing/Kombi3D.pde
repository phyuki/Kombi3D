import processing.sound.*;

final int h_side = 500;
final int v_side = 500;

//Variação por pixel de cada movimentação, seja de limpador de parabrisa, seja do retrovisor
final float dx_Limp = 2;
final float dy_Retro = 0.15;
final float dx_Haste = 0.15;
final float dy_Haste = 0.3;

//Variáveis que funcionam como interruptores, guardam a informação caso alguma função esteja ativada ou desativada
int switch_Farol = 0;
int switch_PiscaEsq = 0;
int switch_PiscaDir = 0;
int switch_Alerta = 0;
int switch_Retrovisor = 0;
int switch_Limpador = 0;
int switch_Motor = 0;

//Tempo guardado para quando for ativada cada instrução, como um pisca-alerta ou ligar a seta pela esquerda ou direita
int temp_PiscaEsq = 0;
int temp_PiscaDir = 0;
int temp_Alerta = 0;
int temp_Motor = 0;

//Gatilhos que servem para marcar se o loop do motor foi ou nao ativado
int gatilho_A = 0;
int gatilho_B = 0;

//Guardam a direção do movimento do parabrisa, seja para esquerda ou pela direita
int direcaoEsq = 0;
int direcaoDir = 0;

color white = color(255, 255, 255);
color almost_white = color(230, 230, 230);
color gray = color(150, 150, 150);
color black = color(0, 0, 0);
color glass_blue = color(148, 213, 251);
color dark_cyan = color(37, 189, 177);
color cyan = color(0, 253, 255);
color turquoise = color(52, 161, 173);
color beige = color(197, 158, 129);
color light_orange = color(255, 193, 0);
color orange = color(246, 99, 4);
color dark_orange = color(208, 81, 0);
color darkgray = color(71, 68, 75);
color deep_sky_blue = color(0, 191, 255);
color blue = color(13,11,178);

// Dimensoes da roda
int wid_roda = 50;
int heig_roda = 55;

//Dimensoes do para-choque
int wid_parachq = 380;
int heig_parachq = 30;

//Dimensoes da placa da kombi
int wid_placa = 86;
int heig_placa = 40;

//Dimensoes da lataria
int wid_lataria = 200;
int heig_lataria = 240;

//Dimensoes do topo
int wid_topo = 300;
int heig_topo = 20;

//Dimensoes barra topo
int wid_barra_topo = 310;
int heig_barra_topo = 9;

//Dimensoes Janela
int wid_janela = 145;
int heig_janela = 110;

//Dimensoes do Retrovisor
int wid_retrovisor = 27;
int heig_retrovisor = 48;

//Dimensoes Limpador de Parabrisa
int wid_limpador = 3;
int heig_limpador = 80;

//Dimensoes dos farois pequenos e grandes
int d_farolP = 32;
int d_farolG = 72;

//Dimensoes das listras do farol pequeno
int heig_listra = 8;
int heig_listG = 3*heig_listra/2;

//Arquivos de som utilizados para motor, buzina, as setas, o pisca-alerta e o limpador de para-brisa
SoundFile motorInicio, motorLoop, motorFinal, buzina, seta, limpador;
PImage floor;

void setup(){
  size(500, 500, P3D);
  frameRate(60);
  floor = loadImage("floor.jpg");
  motorInicio = new SoundFile(this, "MotorSound_inicio.mp3");
  motorLoop = new SoundFile(this, "MotorSound_loop.mp3");
  motorFinal = new SoundFile(this, "MotorSound_final.mp3");
  buzina = new SoundFile(this, "HornSound.mp3");
  seta = new SoundFile(this, "SetaSound.mp3");
  limpador = new SoundFile(this, "LimpadorSound.mp3");
}

//Funcao que é ativada a cada tecla ativada pelo teclado e em seu interior, serão feitas análises para cada instrução
//--------------------------------------------------------
void keyTyped(){
  if(key == 'F' || key == 'f'){
    if(switch_Farol == 1) switch_Farol = 0;
    else switch_Farol = 1;
  }
  
  if(key == 'R' || key == 'r'){
    if(switch_Retrovisor == 1) switch_Retrovisor = 0;
    else switch_Retrovisor = 1;
  }
  
  if(key == 'L' || key == 'l'){
    limpador.loop();
    if(switch_Limpador == 1){
      switch_Limpador = 0;
    }
    else switch_Limpador = 1;
  }
  
  if(key == '4'){
    seta.loop();
    temp_PiscaEsq = millis();
    if(switch_PiscaEsq == 1){ 
      switch_PiscaEsq = 0;
      seta.pause();
    }
    else{ 
      switch_PiscaDir = 0;
      switch_Alerta = 0;
      switch_PiscaEsq = 1;
    }  
  }
  
  if(key == '6'){
    seta.loop();
    temp_PiscaDir = millis();
    if(switch_PiscaDir == 1){
      switch_PiscaDir = 0;
      seta.pause();
    }
    else{
      switch_PiscaEsq = 0;
      switch_Alerta = 0;
      switch_PiscaDir = 1;
    }  
  }
  
  if(key == 'a' || key == 'A'){
    seta.loop();
    temp_Alerta = millis();
    if(switch_Alerta == 1){
      switch_Alerta = 0;
      seta.pause();
    }
    else{
      switch_PiscaDir = 0;
      switch_PiscaEsq = 0;
      switch_Alerta = 1;
    }  
  }
  
  if(key == 'm' || key == 'M'){
    if(switch_Motor == 1){
      if(motorInicio.isPlaying()){
        motorInicio.pause();
        temp_Motor = 0;
        gatilho_A = 0;
      }
      motorLoop.pause();
      motorFinal.play();
      switch_Motor = 0;
    }
    else{
      motorInicio.play();
      gatilho_B = 1;
      temp_Motor = millis();
      switch_Motor = 1;
    }
  }
  if(key == 'b' || key == 'B'){
    buzina.play();
  }
}
//--------------------------------------------------------

//Variáveis declaradas para o uso das classes de cada peça da kombi que possuam movimentação em suas animações
Limpador limpaEsq = new Limpador(240);
Limpador limpaDir = new Limpador(240);
Retrovisor retro = new Retrovisor(0);
Haste haste = new Haste(0, 0);

void draw(){
  background(deep_sky_blue);
  
  //Movimento da camera
  camera(2*mouseX-(width/2), mouseY-25, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);
  
  //Luzes
  lights();
  pointLight(51, 102, 126, mouseX, mouseY, 0);
  
//If para contar quando tempo se passou desde o inicio do play do motorInicio ate o tempo necessario para dar play no motorLoop  
  if(millis() > temp_Motor+14500 && millis() < temp_Motor+15000 && gatilho_A == 0 && gatilho_B == 1){
      motorLoop.loop();
      gatilho_A = 1;
      gatilho_B = 0;
  }
//Rodas
//--------------------------------------------------------
  //Roda esquerda Frente
  pushMatrix();
  translate(80, 410, -77);
  Roda rodaEsq = new Roda();
  rodaEsq.display();
  rotateY(radians(90));
  translate(28, 0, 0);
  circle(0, 30, 95);
  translate(0, 0, 49);
  circle(0, 30, 95);
  translate(-12, 43);
  popMatrix();
  
  //Roda direita Frente
  pushMatrix();
  translate(80, 410, -77);
  translate(290, 0);
  Roda rodaDir = new Roda();
  rodaDir.display();
  rotateY(radians(90));
  translate(28, 0, 0);
  circle(0, 30, 95);
  translate(0, 0, 49);
  circle(0, 30, 95);
  popMatrix();
  
  //Roda esquerda Tras
  pushMatrix();
  translate(80, 410, -547);
  Roda rodaEsqT = new Roda();
  rodaEsqT.display();
  rotateY(radians(90));
  translate(28, 0, 0);
  circle(0, 30, 95);
  translate(0, 0, 49);
  circle(0, 30, 95);
  popMatrix();
  
  //Roda direita Tras
  pushMatrix();
  translate(80, 410, -547);
  translate(290, 0);
  Roda rodaDirT = new Roda();
  rodaDirT.display();
  rotateY(radians(90));
  translate(28, 0, 0);
  circle(0, 30, 95);
  translate(0, 0, 49);
  circle(0, 30, 95);
  popMatrix();
//--------------------------------------------------------

//Para-choque da kombi
//--------------------------------------------------------
  pushMatrix();
  translate(0, 0, 5);
  for(int i = 0;i <= 3;i++){
    stroke(black);
    fill(gray);
    if(i == 0) translate(57, v_side-105);
    rect(0, 0, wid_parachq+6, heig_parachq, 10);
    translate(0, 0, 1);
  }
  translate(0, 0, 1);
  stroke(black);
  fill(white, 200);
  rect(10, heig_parachq/2-7, 100, 14, 60);
  stroke(black, 150);
  fill(black, 200);
  translate(0, 0, 1);
  rect(15, heig_parachq/2-3, 90, 6, 60);
  
  translate(wid_parachq/2+69, 0);
  stroke(black);
  fill(white, 200);
  translate(0, 0, -1);
  rect(10, heig_parachq/2-7, 100, 14, 60);
  stroke(black, 150);
  fill(black, 200);
  translate(0, 0, 1);
  rect(15, heig_parachq/2-3, 90, 6, 60);
  popMatrix();
//--------------------------------------------------------
  
//Parte de cima da lataria da kombi
//--------------------------------------------------------
  pushMatrix();
  noStroke();
  fill(black);
  translate(60, v_side-105);
  translate(0, 20);
  rect(0, 0, wid_parachq, -heig_lataria);
  
  pushMatrix();
  translate(190, -311, -300);
  box(wid_lataria*2-105, heig_lataria/2, 600);
  popMatrix();
  
  pushMatrix();
  translate(190, -211, -300);
  box(wid_lataria*2-105, heig_lataria/2, 600);
  popMatrix();
  
  pushMatrix();
  translate(22, -306, -300);
  rotate(PI/10.0);
  box(0, heig_lataria/2+16, 600);
  popMatrix(); 
  
  pushMatrix();
  translate(359, -306, -300);
  rotate(-(PI/10.0));
  box(0, heig_lataria/2+16, 600);
  popMatrix(); 
//--------------------------------------------------------

//Frente da Kombi - Lataria
//--------------------------------------------------------
  noStroke();
  
  pushMatrix();
  fill(dark_cyan);
  translate(190, -120, -301);
  box(wid_lataria*2-20, heig_lataria+5, 600);
  popMatrix();
  
  translate(0, 0, 1);
  arc(0, 0, 2*wid_lataria, 2*heig_lataria, TWO_PI-HALF_PI, TWO_PI);
  line(0, 0, 0, -heig_lataria);
  line(0, 0, wid_parachq, 0);
  
  translate(wid_parachq, 0);
  arc(0, 0, 2*wid_lataria, 2*heig_lataria, PI, TWO_PI-HALF_PI);
  line(0, 0, 0, -heig_lataria);
  
  rect(-wid_lataria-5, -46, 10, 46);
  rect(-wid_lataria+5, -66, 10, 20);
  popMatrix();
//--------------------------------------------------------

//Topo da Kombi
//--------------------------------------------------------
  noStroke();
  fill(black);
  quad(100, 45, 400, 45, 440, 175, 60, 175);
//--------------------------------------------------------

//Janelas
//--------------------------------------------------------
  pushMatrix();
  translate(0, 0, 1);
  //Janela 1
  stroke(gray);
  fill(glass_blue);
  rect(100, 60, wid_janela, heig_janela, 7);
  translate(0, 0, 1);
  fill(gray, 200);
  rect(100+wid_janela-30, 80, 40, 30, 7);
  translate(0, 0, -1);
  translate(155,0); 
  
  //Janela 2
  fill(glass_blue);
  rect(100, 60, wid_janela, heig_janela, 7);
  fill(gray, 200);
  translate(0, 0, 1);
  fill(gray, 200);
  rect(90, 80, 40, 30, 7);
  translate(0, 0, -1);
  
  stroke(black);
  fill(black);
  translate(0, 0, 2);
  rect(90, 78, 10, 33);
  translate(0, 0, -2);
  popMatrix();
  
  //janela lateral esquerda
  pushMatrix();
  fill(glass_blue);
  translate(96, 60, -30);
  rotate(PI/10.0);
  rotateY(radians(90));
  rect(0, 0, 200, heig_janela-5, 7);
  popMatrix(); 
  
  //janela lateral direita
  pushMatrix();
  fill(glass_blue);
  translate(404, 60, -30);
  rotate(-PI/10.0);
  rotateY(radians(90));
  rect(0, 0, 200, heig_janela-5, 7);
  popMatrix(); 
  
  //janela lateral fundo esquerda
  pushMatrix();
  fill(glass_blue);
  translate(96, 60, -260);
  rotate(PI/10.0);
  rotateY(radians(90));
  rect(0, 0, 300, heig_janela-5, 7);
  popMatrix(); 
  
  //janela lateral direita
  pushMatrix();
  fill(glass_blue);
  translate(404, 60, -260);
  rotate(-PI/10.0);
  rotateY(radians(90));
  rect(0, 0, 300, heig_janela-5, 7);
  popMatrix(); 
//--------------------------------------------------------

//Portas
//--------------------------------------------------------
  //Porta esquerda
  stroke(darkgray);
  strokeWeight(2);
  noFill();
  pushMatrix();
  translate(60, 174, -20);
  rotateY(radians(90));
  rect(0, 0, 230, 210, 7);
  stroke(black, 100);
  strokeWeight(1);
  translate(-2, 0);
  rect(0, 0, 234, 212, 7);
  popMatrix();
  
  //Maçaneta
  noStroke();
  fill(black, 35);
  pushMatrix();
  rotateY(radians(90));
  translate(190, 215, 62);
  ellipse(0, 0, 40, 25);
  stroke(black);
  fill(gray);
  translate(-26, -2, -2);
  rect(0, 0, 40, 5);
  translate(37, -2.5, 1);
  rect(0, 0, 20, 10); 
  popMatrix();
  
  //Porta direita
  stroke(darkgray);
  strokeWeight(2);
  noFill();
  pushMatrix();
  translate(378, 0);
  translate(63, 174, -20);
  rotateY(radians(90));
  rect(0, 0, 230, 210, 7);
  stroke(black, 100);
  strokeWeight(1);
  translate(-2, 0);
  rect(0, 0, 234, 212, 7);
  popMatrix();
  
  //Maçaneta
  noStroke();
  fill(black, 35);
  pushMatrix();
  translate(380, 0, 0);
  rotateY(radians(90));
  translate(190, 215, 62);
  ellipse(0, 0, 40, 25);
  stroke(black);
  fill(gray);
  translate(-26, -2, 2);
  rect(0, 0, 40, 5);
  translate(37, -2.5, -1);
  rect(0, 0, 20, 10); 
  popMatrix();
//--------------------------------------------------------
//Retrovisores
//--------------------------------------------------------
  //Espelhos
  pushMatrix();
  translate(64, 0, -5);
  stroke(black);
  fill(gray);
  if(switch_Retrovisor == 1){
    if(retro.getRetroY() <= 10)    //Movimento de subida do retrovisor
       retro.move(1);
       rotateY(-radians(90));
       translate(10, 0, 15);
  }
  else{
    if(retro.getRetroY() > 0)      //Movimento de descida do retrovisor
       retro.move(2);
       rotateY(-radians(45));
       translate(-10, 0, 15);
  }
  for(int i = 0; i <= 2; i++){
    retro.display();
    translate(0, 0, -1);
  }
  fill(glass_blue);
  retro.display();
  
  popMatrix();
  pushMatrix();
  
  translate(75, 0, -5);
  fill(gray);
  translate(2*wid_lataria-1, 0);
  if(switch_Retrovisor == 1){
    if(retro.getRetroY() <= 10)    //Movimento de subida do retrovisor
       retro.move(1);
       rotateY(radians(90));
       translate(20, 0, -20);
  }
  else{
    if(retro.getRetroY() > 0)      //Movimento de descida do retrovisor
       retro.move(2);
       rotateY(radians(45));
       translate(10, 0, -10);
  }
  for(int i = 0; i <= 2; i++){
    retro.display();
    translate(0, 0, -1);
  }
  fill(glass_blue);
  retro.display();
  
  translate(0, 0, 3);
  popMatrix();
  fill(gray);
  pushMatrix();
  translate(0, 0, -1);
  
  if(switch_Retrovisor == 1){
    if(retro.getRetroY() <= 10)     //Movimento de subida da haste do retrovisor
       haste.move(1);
    }
  else{
    if(retro.getRetroY() > 0)       //Movimento de descida da haste do retrovisor
       haste.move(2);
  }
  for(int i = 0; i <= 2; i++){
    haste.display();
    translate(0, 0, -1);
  }
  popMatrix();
//--------------------------------------------------------

//Limpadores de Parabrisa
//--------------------------------------------------------
  pushMatrix();
  translate(0, 0, 5);
  stroke(black);
  fill(gray);
  
  if(switch_Limpador == 1){
    if(limpaEsq.getLimpX() <= 240 && limpaEsq.getLimpX() >= 104 && direcaoEsq == 0){
       limpaEsq.move(2);
       if(limpaEsq.getLimpX() == 104) direcaoEsq = 1;
    }
    else{
      limpaEsq.move(1);
      if(limpaEsq.getLimpX() == 240) direcaoEsq = 0;
    }
  }
  else if (switch_Limpador == 0 && limpaEsq.getLimpX() != 240){
    if(limpaEsq.getLimpX() <= 240 && limpaEsq.getLimpX() >= 104 && direcaoEsq == 0){
       limpaEsq.move(2);
       if(limpaEsq.getLimpX() == 104) direcaoEsq = 1;
    }
    else{
      limpaEsq.move(1);
    }
  }
  else{
    direcaoEsq = 0;
    if(limpador.isPlaying()) limpador.pause();  
  }
  limpaEsq.display();
  
  stroke(black);
  translate(wid_janela+10, 0);
  if(switch_Limpador == 1){
    if(limpaDir.getLimpX() <= 240 && limpaDir.getLimpX() >= 104 && direcaoDir == 0){
       limpaDir.move(2);
       if(limpaDir.getLimpX() == 104) direcaoDir = 1;
    }
    else{
      limpaDir.move(1);
      if(limpaDir.getLimpX() == 240) direcaoDir = 0;
    }
  }
  limpaEsq.display();
  popMatrix();
//--------------------------------------------------------

//Farois frontais
//--------------------------------------------------------
  //Pisca esquerdo
  pushMatrix();
  translate(110, 225, 2);
  Pisca piscaEsq = new Pisca();
  if(switch_PiscaEsq == 1) piscaEsq.piscar(1, millis(), 1);
  if(switch_Alerta == 1) piscaEsq.piscar(1, millis(), 3);
  piscaEsq.display();
  
  //Pisca direito
  translate(280, 0);
  Pisca piscaDir = new Pisca();
  if(switch_PiscaDir == 1) piscaDir.piscar(1, millis(), 2);
  if(switch_Alerta == 1) piscaDir.piscar(1, millis(), 4);
  piscaDir.display();
  popMatrix();
  
  //Farol esquerdo
  pushMatrix();
  translate(140, 300, 2);
  Farol farolEsq = new Farol();
  if(switch_Farol == 1) farolEsq.ligar();
  farolEsq.display();

  //Farol direito
  translate(220, 0);
  Farol farolDir = new Farol();
  if(switch_Farol == 1) farolDir.ligar();
  farolDir.display();
  popMatrix();
//--------------------------------------------------------

//Placa
//--------------------------------------------------------
  stroke(black, 150);
  fill(gray);
  pushMatrix();
  translate(h_side/2-50, v_side-104);
  translate(0, 0, 8);
  for(int i = 0; i <= 4; i++){
    rect(-120, -18, 10, 17, 5);
    rect(210, -18, 10, 17, 5);
    translate(0, 0, 1);  
  }
  translate(0, 0, -5);
  for(int i = 0; i <= 4; i++){
    if(i == 0) translate(0, 0, 2);
    rect(-120, -21, 340, 10, 65);
    translate(0, 0, 1);  
  }
  translate(0, 0, 5);
  for(int i = 0; i <= 4; i++){
    stroke(black, 150);
    rect(-21, -36, 18, heig_parachq+35, 60);
    rect(102, -36, 18, heig_parachq+35, 60);
    translate(0, 0, 1);  
  }
  translate(-49, 0, -1);
  stroke(black);
  fill(white);
  translate(100-wid_placa/2+(wid_placa-1)/2, -11+heig_placa/2);
  box(wid_placa-1, heig_placa, 4);
  popMatrix();
  
  pushMatrix();
  translate(-52, -30, 27);
  fill(blue);
  quad(260,415,345,415,345,426,260,426);
  fill(black);
  textSize(10);
  translate(0, 0, 1);
  text("BRASIL", 285, 425);
  textSize(18);
  translate(0, 5, -1);
  text("K0MB13D", 260, 440);
  popMatrix();
//--------------------------------------------------------

//Volume do som do motor do carro
//--------------------------------------------------------
  float amplitude;
  if(mouseX <= 100)
    amplitude = map(mouseX, 0, 100, 0.4, 0.2);
  else if(mouseX >= 400)
    amplitude = map(mouseX, 400, width, 0.2, 0.4);
  else
    amplitude = 0.2;
    
  motorInicio.amp(amplitude);
  motorLoop.amp(amplitude);
  motorFinal.amp(0.4);
//--------------------------------------------------------  

//Chão
//--------------------------------------------------------
  noStroke();
  pushMatrix();
  textureMode(IMAGE);
  translate(-500, 480, -3000);
  rotateX(radians(90));
  for(int i = 0; i <= 14; i++){
    for(int j = 0; j <= 5; j++){
      beginShape();
      texture(floor);
      vertex(0, 0, 0, 0);
      vertex(0, 250, 250, 0);
      vertex(250, 250, 250, 250);
      vertex(250, 0, 0, 250);
      endShape();
      translate(250, 0);
    }
    translate(-1500, 250);
  }
  popMatrix();
//--------------------------------------------------------
}
//--------------------------------------------------------
//Classe responsável pela haste do retrovisor e sua movimentação
//--------------------------------------------------------
class Haste{
  float x, y;
  
  Haste(float new_x, float new_y){
    x = new_x;
    y = new_y;
  }
  
  void move(int escolha){
    if(escolha == 1){
      x -= dx_Haste;
      y -= dy_Haste;
    }
    else{
      x += dx_Haste;
      y += dy_Haste;
    }
  }
  
  void display(){
    quad(45-x, 130+y, 49-x, 130+y, 90, 160, 80, 160);
    quad(451+x, 130+y, 455+x, 130+y, 425, 160, 415, 160);
  } 
}
//--------------------------------------------------------

//Classe responsável pelo retrovisor e sua movimentação
//--------------------------------------------------------
class Retrovisor{
  float y;
  
  Retrovisor(float new_y){
    y = new_y;
  }
  
  float getRetroY(){
    return y;
  }
  
  void move(int escolha){
    if(escolha == 1){
      y += dy_Retro;
    }
    else{
      y -= dy_Retro;
    }
  }
  
  void display(){
    stroke(black);
    rect(-wid_retrovisor, 130+y-heig_retrovisor/2, wid_retrovisor, heig_retrovisor-y, 7);
  } 
}
//--------------------------------------------------------

//Classe responsável pelo limpador de parabrisa e sua movimentação
//--------------------------------------------------------
class Limpador{
  float x;
  
  Limpador(float new_x){
    x = new_x;
  }
  
  float getLimpX(){
    return x;
  }
  
  void move(int escolha){
    if(escolha == 1){
      x += dx_Limp;
    }
    else{
      x -= dx_Limp;
    }
  }
  
  void display(){
    ellipse(x, 110, wid_limpador, heig_limpador);
    quad(x-2, 116, x, 110, 170, 170, 175, 170);
    stroke(gray);
    line(170, 170, 175, 170);
  } 
}
//--------------------------------------------------------

//Classe responsável pelo desenho de cada roda
//--------------------------------------------------------
class Roda{  
    Roda(){
    }
    
    void display(){
      noStroke();
      fill(black);
      rect(0, 0, wid_roda, heig_roda+25, 0, 0, 12, 12);      
    }
  }
//--------------------------------------------------------

//Classe responsável pelas linhas de reflexo do vidro
//-------------------------------------------------------- 
class LinhaReflexo{
    LinhaReflexo(){
    }
    
    void display(){
      line(110, 65, 105, 73);
      line(116, 63, 104, 82);
      line(120, 67, 113, 78);
    }
  }
//--------------------------------------------------------

//Classe responsável pelo pisca-alerta e as setas de comando da kombi, além de sua animação quando ativadas
//--------------------------------------------------------
class Pisca{
  color cor;
  
  Pisca(){
   cor = orange;
  }
  
  void piscar(int resp, int temp, int escolha){
    if (resp == 1){ 
      if(escolha == 1 && (temp - temp_PiscaEsq)%950 <= 475){ 
        cor = light_orange;
      }
      if(escolha == 2 && (temp - temp_PiscaEsq)%950 <= 475){ 
        cor = light_orange;
      }
      if(escolha == 3 && (temp - temp_Alerta)%950 <= 475){ 
        cor = light_orange;
      }
      if(escolha == 4 && (temp - temp_Alerta)%950 <= 475){ 
        cor = light_orange;
      }
    }
    else cor = orange;
  }
  
  void display(){
    stroke(black, 180);
    fill(white);
    circle(0, 0, d_farolP);
    
    stroke(dark_orange);
    strokeWeight(3.5);
    line(0, -heig_listG, 0, heig_listG);
    line(-heig_listra, -heig_listra, -heig_listra, heig_listra);
    line(heig_listra, -heig_listra, heig_listra, heig_listra);
    strokeWeight(1);
    
    noStroke();
    fill(cor, 210);
    sphere(d_farolP-20);
  }
}
//--------------------------------------------------------

//Classe responsável pelos faróis e sua animação de ligar e desligar
//--------------------------------------------------------
class Farol{
  color corCircMaior, corCircMenor;
  
  Farol(){
    corCircMaior = black;
    corCircMenor =  gray;
  }
  
  void ligar(){
    corCircMaior = almost_white;
    corCircMenor = white;
  }
  
  void desligar(){
    corCircMaior = black;
    corCircMenor =  gray;
  }
  
  void display(){    
    stroke(black, 180);
    fill(white);
    circle(0, 0, d_farolG);
    
    pushMatrix();
    translate(0, 0, -10);
    noStroke();
    fill(corCircMaior, 150);
    sphere(d_farolG-40);
    popMatrix();
    
    pushMatrix();
    translate(0, 0, 8);
    noStroke();
    fill(corCircMenor);
    sphere(15);
    popMatrix();
  }
}
//--------------------------------------------------------
