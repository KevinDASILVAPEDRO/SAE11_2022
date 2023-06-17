// arkanoid = https://www.dailymotion.com/video/x5f1vv
/////////////////////////////////////////////////////
//
// Arkanoid
// DM2 "UED 131 - Programmation impérative" 2022-2023
// NOM         : DA SILVA PEDRO
// Prénom      : Kévin
// N° étudiant : 20221810
//
// Collaboration avec : 
//
/////////////////////////////////////////////////////
import processing.sound.*;
SoundFile intro;
SoundFile brique;
SoundFile gameover;
SoundFile letsgo;
SoundFile mur;
SoundFile raquette;


//===================================================
// les variables globales
//===================================================

/////////////////////////////
// Pour les effets sonores //
/////////////////////////////

/////////////////////////////
// Pour la balle           //
/////////////////////////////

int balleD = 10;  // diametre de la balle
float balleX = 350;   // positon de la balle en X
float balleY = 570;  // idem en Y
int balleVitesse = 5;
float balleVx; 
float balleVy;  
float newBalleX = 350;  // nouvelle postion de la balle en X
float newBalleY = 570; // idem en Y

/////////////////////////////
// Pour la raquette        //
/////////////////////////////

int raquetteL = 100; //longueur
int raquetteH = 20; //largeur
int raquetteX = 355; //position en X
int raquetteY = 580; //position en Y


/////////////////////////////
// Pour la zone de jeu     //
/////////////////////////////

float minX = 0;   // variables qui delimite la zone de jeu
float maxX = 960;
float minY = 30;
float maxY = 630;
float centreX = 355;  // centre de la zone de jeu


int etat = 0;   // declarations de tout les etats
int INIT = 0;
int GO = 1;
int OVER = 2;


/////////////////////////////
// Pour les briques        //
/////////////////////////////

final int nbLignes = 8;
final int nbColones = 13;
final int  briqueL = 50;
final int briqueH = 25;
int nbBriques = 104;

int[] briqueX;
int[] briqueY;
int[] couleurs;

/////////////////////////////
// Pour le "boss"          //
/////////////////////////////

PImage cage; //importe l'image

/////////////////////////////
// Pour le contrôle global //
/////////////////////////////

////////////////////////////////////
// Pour la gestion de l'affichage //
////////////////////////////////////

PFont fonte; 
PImage arkanoid; // idem
PImage tile;
PImage wall1;
PImage wall2;
PImage top;

int score = 0;
int highscore = 0;
//===================================================
// l'initialisation
//===================================================
void setup() {
  size(960, 630); // taille de la fenetre
  fonte = createFont("joystix.ttf",20); 
  textFont(fonte);  // police de texte
  cage = loadImage("cage.png");
  arkanoid = loadImage("arkanoid.png");
  tile = loadImage("tile.png");
  wall1 = loadImage("wall1.png");
  wall2 = loadImage("wall2.png");
  top = loadImage("top.png");
  intro = new SoundFile(this, "intro.mp3");
  mur = new SoundFile(this, "mur.mp3");
  gameover = new SoundFile(this, "gameover.mp3");   // ici creations des variables pour les images et sons.
  letsgo = new SoundFile(this, "letsgo.mp3");
  raquette = new SoundFile(this, "raquette.mp3");
  brique = new SoundFile(this, "brique.mp3");
  intro.play();  // on joue le son

}

//===================================================
// l'initialisation de la balle et de la raquette
//===================================================
void initBalleEtRaquette() {
  balleX=350; balleY=570; newBalleX=350; newBalleY=570;  // replacer la balle au bon endroit apres avoir perdu
  ellipse(balleX-100,balleY+35,balleD,10);
  balleVx = balleVitesse*cos(random(5*PI/4,7*PI/4));
  balleVy = balleVitesse*sin(random(5*PI/4,7*PI/4));   // ici la balle va se lancer d'un angle random compris entre 5PI/4 et 7PI/4.
}

//===================================================
// l'initialisation des briques                      aide ici
//===================================================

void initBriques() {
  colorMode(HSB); 
  for(int i = 0; i<nbLignes; i++){
    briqueX[i] = 70+i*28;                             // bien placé les briques
    fill(i*40,50,100);                                // hsb pour les briques
  }
  for(int j = 0; j<nbColones; j++){
    briqueX[j] = 30+j*50;                             // bien placé les briques
  }
  colorMode(RGB);
}

//===================================================
// affichage briques                                 aide ici 
//===================================================

void afficheBriques(){
  for(int i = 0; i<nbLignes; i++){                    // parcours des tableaux
    for(int j = 0; j<nbColones; j++){
      colorMode(HSB);                                 // mode de coleur utilisé pour les briques
      fill(i*40, 170, 250);
      rect(30+j*50,120+i*28,briqueL,briqueH,5);       // dimension des briques  
      colorMode(RGB);                                 // couleur des briques
   }
  }
} 

//===================================================
// l'initialisation de la partie
//===================================================
void initJeu() {
 
}

//===================================================
// la boucle de rendu
//===================================================
void draw() {
 afficheJeu();
 
 if (etat == GO){   //si on est dans cette état les fonctions s'effectuent
   deplaceBalle();  
   miseAJourBalle();
   rebondMurs();
   rebondRaquette();
 }

 if (etat == INIT){                 // en fonction de l'etat où l'on ai le message change
   afficheEcran("GET READY");
   initBalleEtRaquette();
 }
 if (etat == OVER){
   afficheEcran("GAME OVER");
 }
}
//===================================================
// gère les rebonds sur les murs
//===================================================
void rebondMurs() {
  if (newBalleX >= maxX-285 || newBalleX <= minX+35) {  //maxX - pour que ca rebondisse bien sur le mur de droite et minX - pareil mais pour le mur de gauche
    balleVx *=-1;   // quand ca touche un mur le sens de la balle change
  }
  if(newBalleY <= minY+8){   // ajustement pour le haut 
    balleVy *=-1; //on a invérsée les vecteurs X,Y
  }
  if (newBalleY > 630 ){  // si on dépasse la hauteur en bas on a perdu
    score = 0;
    gameover.play();
    etat = OVER;
  }
}
//===================================================
// gère le rebond sur la raquette
//===================================================
void rebondRaquette() {
    if (balleY >= height-50-balleD/2) {  //si la balle dépasse la hauteur de la raquette
    
      if (newBalleX >= (mouseX - raquetteL/2) && newBalleX <= (mouseX + raquetteL/2)){  //zone comprise entre le bord droit et gauche de la raquette
        balleVy = balleVy *(-1);  //rebondir
      }
    }
}


//===================================================
// gère le rebond sur une "boîte"                      
// --------------------------------------------------
// (x1, y1) = l'ancienne position de la balle
// (x2, y2) = la nouvelle position de la balle
// (bx, by) = le coin supérieur gauche de la boîte
// (bw, bh) = la largeur et la hauteur de la boîte
// --------
// résultat = vrai si rebond / faux sinon
// --------
// met à jour la vitesse de la balle en fonction du 
// rebond
//===================================================
boolean rebond(float x1, float y1, float x2, float y2, 
  float bx, float by, float bw, float bh) {
    
 //la nouvelle abscisse de la balle est à l’intérieur du rectangle alors que l’ancienne abscisse est à l’extérieur 
    if ((x2 >= bx) && (x1 <= bx) && (y2 <= by+bh) && (y1 >= by)|| 
    (x2 <= bx+bw) && (x1 >= bx+bw) && (y2 <= by+bh) && (y1 >= by)) {
      balleVx *= -1;  //inversement de la vitesse horizontale pour avoir un rebond horizontal
      return true;
  } 
  
  //la nouvelle ordonnée de la balle est à l’intérieur du rectangle alors que l’ancienne ordonnée est à l’extérieur
    if (((y2 >= by)  && (y1 <= by) && (x2 <= bx+bw) && (x1 >= bx))||
    ((y2 <= by+bh) && (y1 >= by+bh) && (x2 <= bx+bw) && (x1 >= bx))) {
      balleVy *= -1;  //inversement de la vitesse vericale pour avoir un rebond vertical
      return true;
  }
  return false;
}
//===================================================
// gère le rebond sur les briques                          
// --------------------------------------------------
// (x1, y1) = l'ancienne position de la balle
// (x2, y2) = la nouvelle position de la balle
//===================================================


//===================================================
// gère le rebond sur le boss
// --------------------------------------------------
// (x1, y1) = l'ancienne position de la balle
// (x2, y2) = la nouvelle position de la balle
//===================================================
void rebondBoss(float x1, float y1, float x2, float y2) {
  if (rebond(x1, y1, x2, y2, 255.0, 100.0, 200.0, 200.0)) {  //appel de la fonction rebond
    score += 10;  //augmentation du score de +10
  }
}

//===================================================
// calcule la nouvelle position de la balle
//===================================================
void deplaceBalle() {
  newBalleX+=balleVx;  // incrémentation de 2 variables
  newBalleY+=balleVy;

}

//===================================================
// met à jour la position de la balle
//===================================================
void miseAJourBalle() {
  balleX = newBalleX;   // on met a jour balle X et Y en les remplacant par les nouvelles valeurs
  balleY = newBalleY;
}

//===================================================
// affiche un écran, avec un message
// --------------------------------------------------
// msg = le message à afficher
//===================================================
void afficheEcran(String msg) {

  image(arkanoid,160,350,400,100);    // placement de l'image avec la position ensuite la taille
  textSize(50);
  fill(255);
  text(msg,180,500);
  textSize(20);
  text("PRESS <SPACE> TO START",180,550);
}

//===================================================
// fait le dessin de pavage au fond
//===================================================
void pavage() {
  PImage tile = (loadImage("tile.png"));  // on importe l'image 
  
  for (int i=0 ; i < 10; i++) {        // on repete 10x horizontalement gauche a droite
    for (int j=0 ; j < 10; j++) {      // on repete aussi 10x mais verticalement
      image(tile,i*130-65,j*76-38);       //on affiche l'image et on réalise les décalages ici
    }
  }
  for (int k=0 ; k < 10; k++) {        // on repete 10x horizontalement gauche a droite
    for (int l=0 ; l < 10; l++) {      // on repete aussi 10x mais verticalement 
      image(tile,k*130,l*76);          // on affiche et on réalise les décalages ici
    }
  }
}

//===================================================
// affiche le cadre
//===================================================
void cadre() {
  PImage wall1 = (loadImage("wall1.png"));
  PImage wall2 = (loadImage("wall2.png"));
  PImage top = (loadImage("top.png"));
  
  fill(128,128,128);
  rect(0,0,30,700);
  rect(680,0,30,700);
  rect(0,0,710,30);
  image(top,0,0);
  
  for (int i=1 ; i < 10; i++) {    // i = 1 pour dessiner le bon mur en 1er
    image(wall1,i+680,i*105);      // mur de droite  +680 le mettre a droite
  }
  for (int j=0 ; j < 10; j++) {   
    image(wall2,j+680,j*105+40);   
  }
  for (int i=1 ; i < 10; i++) {    // i = 1 pour dessiner le bon mur en 1er
    image(wall1,i,i*105);          //mur de gauche  rien pour le laisser a gauche
  }
  for (int j=0 ; j < 10; j++) {  
    image(wall2,j,j*105+40);
  }
}
//===================================================
// formate le score sur 6 chiffres
// --------------------------------------------------
// score = le score à afficher
// --------
// résultat = une chaîne de caractères sur 6 chiffres
//===================================================
String formatScore(int score) {
  return "";
}

//===================================================
// affiche le cartouche de droite
//===================================================
void cartouche() {
  
  fill(0);
  rect(710,0,250,630);
  
  textSize(20);
  fill(255, 0, 0);
  text("1UP", 815, 100); 
  
  textSize(20);
  fill(99, 99, 99);
  text("HIGH SCORE", 760, 200); 
  
  textSize(20);
  fill(99,99,99);
  text("COPYRIGHT",780,550);
  text("K.DASILVAPEDRO",725,570);
  text("® 2022",800,590);
  noFill();
  image(arkanoid,715,10);

  //affiche le score
  text(highscore,830,250);
  text(score,830,150);
  if (highscore > score){
  highscore=score; 
  }
}

//===================================================
// affiche le boss dans sa cage
//===================================================
void boss() {

  stroke(0, 0, 0);
  strokeWeight(3);

//tete+yeux
  fill(4, 255, 0); //couleur tete
  ellipse(180, 180, 200, 170); //cercle tete 

  fill(255, 255, 255); //couleur oeil gauche
  ellipse(110, 170, 40, 40); //oeil gauche
  noFill();

  fill(255, 255, 255); //couleur oeil droit
  ellipse(255, 170, 40, 40); //oeil droit
  noFill();

  fill(0, 0, 0);
  ellipse(260,170,5,5); //point oeil
  ellipse(105,170,5,5);
  noFill();

//nez
  strokeWeight(2); //epaisseur contour
  stroke(11, 158, 31); //couleur contour
  fill(136, 212, 70);  //couleur du nez
  ellipse(175,179,100,90); //nez
  noFill();
  noStroke();

  fill(6, 89, 0); //couleur narine
  ellipse(160,180,25,30); //narine gauche
  ellipse(200,180,20,25); //narine droite
  noFill();
  noStroke();

  stroke(0, 0, 0);
  strokeWeight(3);

//oreille droite
  fill(4, 255, 0);
  ellipse(170,80,35,45);

//oreille gauche
  rotate(-20);
  translate(-150,20);
  ellipse(100,120,35,45);
  translate(150,-20);
  rotate(20);
  noFill();
  noStroke();

//couronne
  stroke(0, 0, 0);
  fill(255, 251, 0);
  rotate(-20);
  translate(-165,125);
  triangle(185, 100, 225, 100, 205, 125);
  triangle(185, 100, 235, 130, 195, 130);
  translate(-5,-35);
  triangle(183, 125, 230, 115, 195, 150);
  noFill();

//point couronne + base couronne
  fill(93, 127, 252);
  strokeWeight(2);
  ellipse(206,142,15,10);
  ellipse(215,165,10,10);
  ellipse(200,120,10,10);
  fill(251, 251, 0);
  quad(190, 123, 204, 166, 170, 165, 163, 127);
  translate(170,-90);
  rotate(20);
  
  image(cage,0,-30);
}


//===================================================
// affiche la balle
//===================================================
void afficheBalle() { 
  fill(255);  //couleur de la balle
  ellipse(balleX,balleY,balleD,10);  // creation de la balle
}

//===================================================
// affiche la raquette
//===================================================
void afficheRaquette() {
  fill(255);
  noStroke();  // pour pas voir le contour
  rect(raquetteX,raquetteY,raquetteL,raquetteH,40); //creation  de la raquette
}

//===================================================
// affiche le jeu
//===================================================
void afficheJeu() {
 background(0,60,130);
 pavage();
 scale(0.5);
 translate(500,300);
 boss();
 translate(-500,-300);
 scale(2);
 cartouche();
 cadre();
 afficheRaquette(); 
 afficheBalle();
 afficheBriques();
}

//===================================================
// gère les interactions clavier
//===================================================
void keyPressed() {
  if (keyCode ==32){           // touche espace
    if (etat == INIT) {       // si on est dans un etat on va dans l'autre
      etat = GO;
      intro.stop();           // on stop le son
    }
    if (etat == OVER) {      // pareil ici
      etat = INIT;
  }
  }
}
//===================================================
// gère les interactions souris
//===================================================
void mouseMoved() {
  raquetteX = max(30,min(mouseX-50,580));   // coordonnées en X de la raquette et -50 pour centrer sur la souris  max droite et min gauche
}
