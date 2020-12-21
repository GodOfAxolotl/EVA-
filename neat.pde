//Latest Version v. 2.2, now with full functioning GUI //<>// //<>//
// @author Luca Leuschner
// @version 2.1.3

int populationCount = 1000; // Je nach Rechner, Mindestens 2, da sonst nicht entwickelt wird

int parkour = 0;            //Wähle zwischen 5 Leveln in denen die Punkte das Ziel finden. Alternativ kann man auch eigene bauen.

boolean lineWork = false; 
boolean lineWorkLite = false;   //Linework prüft, ob sich zwischen dem Ziel und dem Dot ein Hindernis befindet und schafft so sogar in komplexen Puzzeln 
boolean lineWorkUltra = false;//einen Weg zu finden. Braucht viel Prozessorleistung, sowie Arbeitsspeicher Ist noch nicht ausgereift und benötigt überarbeitung, da es die Luft noch nicht sieht.
//Blockierte Punkte werden Rot dargestellt. Normale Punkte sind Schwarz.
//Der Grüne Punkt ist der Heron-Punkt, der Punkt, der in der vorherigen Generation am besten abgeschnitten hat.
//Mit G kannst du ein Hindernis greifen und es verschieben. Mit D lässt du es fallen.
//Mit den Zahlentasten wählst du das Hinderniss aus, dass du verschieben willst. Bis zu 10 Stück lassen sich speichern.
//Mit B färbst du die Punkte Weiß, was der Framerate helfen kann.
//p pausiert das Programm, o setzt es fort.

//EIn erweiterter Algorithmus, n9ach der Vorlage und der Anleitung von Code Bullet


Population subject;
Population example;
Goal[] goal;
Obstacle[] obstical;
Button[] button;

float[] goalTemp = new float[populationCount];

int tote;
int errorCode;
int in;

float mutationRate = 0.01;

int I, II, III;
int which = 0;

int hindernisszahl = 1;
int torzahl = 1;

int inta;

boolean started =false;
boolean undefined = true;
boolean blur = true;
boolean buildMode;
boolean beaten = false;
boolean mutationMode;
boolean finalMode;
boolean pause;
boolean noMoreMovement;
boolean trader = true;
boolean specianFailed;
boolean replay = false;

char keykey;





void setup() {
  size(1000, 1000, P2D);
  smooth(8);
  background(245);
  surface.setTitle("EVA");

  for (int i = 0; i < goalTemp.length; i++) {
    goalTemp[i] = 0;
  }
}

//////////////////////////////////////////////////////////////

void draw() {

  if (started) {
    levelSelect();
    if (!blur) {
      background(245);
    }                                          //Der Blur (verschmier) Effekt, ein und ausschaltbar
    noStroke();
    fill(245, 100);
    rect(0, 0, width, height);      //Der Blureffekt
    zeigeStandardtexte();
    for (int i = 0; i < goal.length; i++) {
      goal[i].showGoal();
    }                                          //Zeichnet das Ziel bzw. die Ziele
    steuerung();
    for (int i = 0; i < obstical.length; i++) {
      obstical[i].show();
      if (buildMode)
        if (inta < obstical.length) {
          obstical[inta].changePlace();                  // Diesen Befehl bekommen nur bewegbare Hindernisse
        }
      // G drücken für Grab, D für Drop
      if (obstical[i].checkMode()) {
        subject.stepdeathnt();
      }                                           //Beendet die Schrittbegrenzung nach Zielüberschreitung, wenn der Kurse umgebaut wird.
    }
    if (!pause) {
      subject.update();
      subject.checkEdge();  
      //Aktuelle Population wandert.
    }
    subject.display(); 

    if (subject.allDotsDead()) {
      regeneration();
      //checkSpecies();
      //Hier errechnet sich (WIP), ob eine Spezies scheitert oder nicht. Funktioniert noch nicht.
      for (int i = 0; i < goal.length; i++) {
        float IIII =  dist(subject.dot[i].location.x, subject.dot[i].location.y, goal[0].x, goal[0].y); 
        println(IIII);
        goal[i].goalcount = 0;
      }                                              //Neue Generartion
    }
  } else { 
    background(245);
    menu();
  }
}


//////////////////////////////////////////////////////////////////////////////////


void keyPressed() {

  if (key == ' ') 
    if (pause == true) {
      pause = false;
      surface.setTitle("EVA");
    } else {
      pause = true;
      surface.setTitle("PAUSED");
      //Pausiert das Spiel
    }

  if (key == 's' && !buildMode) {

    save("screenshot" + in + ".png"); //Speichert einen Screenshot
  }

  if (key == 'g') {
    surface.setTitle("BuildMode");
    pause = true;
    buildMode = true;
  }

  if (key == 'd') {
    surface.setTitle("PAUSED");
    buildMode = false;
  }

  if (key == '+') {
    if (replay == true) {
      replay = false;
      pause = true;
      surface.setTitle("PAUSE");
    } else {
      replay = true;
      which = 0;
      surface.setTitle("REPLAY MODE!");
    }
  }

  if (key == 'i' && !mutationMode) {
    if (finalMode == true) {
      mutationRate = 0.01; 
      finalMode = false;
    } else {
      mutationRate = 0; 
      finalMode = true;
    }
  }


  if (key == 'e' && !finalMode) {

    if (mutationMode == true) {
      mutationRate = 0.01;
      mutationMode = false;
    } else {
      mutationRate = 0.01; 
      mutationMode = true;
    }
  }
}

/////////////////////////////////////////////////////////////////////////////////

void checkSpecies() {


  for (int i=0; i < subject.dot.length; i++) {
    for (int j=0; j < goalTemp.length; j++) {
      if (subject.dot[i].goalDistance == goalTemp[j]) {
        III++;
        break;
      }
    }
  }
  if (III > subject.dot.length * 25 && !beaten) {
    println("timeout");
    mutationRate = obstical.length / 100;
    specianFailed = true;
    noMoreMovement = true;
    errorCode = 0;           //Your species is not evolving anymore
  }                                      //Bewegt die Spezies sich überhaupt fort?


  if (subject.dot[0].goalDistance == goalTemp[0] && !beaten) {
    II++;
    if (II > 15) {
      println("greeendot");
      specianFailed = true;
      noMoreMovement = true;
    }
    errorCode = 1;          //Evolution is stepping back! Consider restarting.
  } else {
    II = 0;
  }                                   //Bewegt der Heron sich fort?



  if (subject.gen > 75 && !beaten) {

    specianFailed = true;
    errorCode = 2; // Your parkour is impossible
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////

void regeneration() {

  subject.calculateFitness();
  subject.nSelection();
  subject.mutation();

  subject.deaad = 0;
  for (int i = 0; i < subject.dot.length; i++) {
    subject.counted[i] = false;
  }
}

///////////////////////////////////////////////////////////////////////////////////////

void zeigeStandardtexte() {

  fill(0);
  text("Generation: " + subject.gen, 10, 15);  //Generationszähler und Anzeige
  fill(245);
  rect(10, 15, 50, 32);
  fill(0);
  textSize(12);
  text("FPS: " + frameRate, 10, 32);          //FPS Anzeige

  if (!subject.stepDeath) {
    text("Max Step: " + subject.minStep, 10, 48);
  } else {
    text("Latest Step: " + subject.minStep, 10, 48);  //Schrittzahl anzeige
  }

  text((populationCount - subject.deaad) + " / " + populationCount + " Subjekte", 10, 62);

  if (!beaten) {
    text("Ziel ausstehend ", 10, 76);
  } else {
    text("Ziel erreicht ", 10, 76);
  } 

  if (specianFailed) {
    text("Spezies gilt als gescheitert!", 10, 90);


    switch(errorCode) {
    case 0:
      text("Error Code " + errorCode + ":" + "Your species is not evolving anymore. Consider restarting and increasing the subject amount.", 10, 120);
      break;

    case 1:
      text("Error Code " + errorCode + ":" + "Evolution is not getting forward, consider restarting or rebuilding your parkour", 10, 120);
      break;

    case 2:
      text("Error Code " + errorCode + ":" + "TimeOut Error. Your parkour is too hard or impossible. Could still work, but will take time.", 10, 120);
      break;
    }
  }

  if (mutationMode) {
    text("Mutationsmodus aktiviert! Es kann zur verzögerungen in der Zielfindung kommen.", 10, 104);
  }

  if (finalMode) {
    text("Es werden nur die besten Genträger gezeigt.", 10, 134);
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////

void steuerung() {

  keykey = key;

  switch(keykey) {
  case '1':
    inta = 0;
    break;
  case '2':
    inta = 1;
    break;
  case '3':
    inta = 2;
    break;
  case '4':
    inta = 3;
    break;
  case '5':
    inta = 4;
    break;
  case '6':
    inta = 5; 
    break;
  case '7':
    inta = 6;  
    break;
  case '8':
    inta = 7;  
    break;
  case '9':
    inta = 8;  
    break;
  case '0':
    inta = 9;  
    break;
    //Steuerung. 0-9 für die Hindernisswahl, s = screenshot
  default:

    break;
  }


  if (keyPressed && key == 'm') {
    undefined = true;
    started = false;
    beaten = false;
    specianFailed = false;
    subject.gen = 0;
    mutationMode = false;
    finalMode = false;
    mutationRate = 0.01;
  }
} 


/////////////////////////////////////////////////////////////////////////////////////////////


void menu() {
  button = new Button[16];

  button[0] = new Button(200, 100, "Start!", width / 2 - 470, height / 2 + 300, 0, 220, 120);


  button[1] = new Button(50, 50, "1", 30, 30, 0, 220, 120);
  button[2] = new Button(50, 50, "2", 30, 85, 0, 220, 120);
  button[3] = new Button(50, 50, "3", 30, 140, 0, 220, 120);
  button[4] = new Button(50, 50, "4", 30, 195, 0, 220, 120);
  button[5] = new Button(50, 50, "5", 30, 250, 0, 220, 120);
  button[13] = new Button(150, 50, "Sandbox", 100, 250, 0, 220, 120);

  button[6] = new Button(200, 50, "LineWork an", 30, 385, 0, 220, 120);
  button[7] = new Button(200, 50, "LineWork aus", 30, 440, 0, 220, 120);
  button[8] = new Button(200, 50, "LiteWork an", 30, 495, 0, 220, 120);
  button[9] = new Button(200, 50, "LiteWork aus", 30, 550, 0, 220, 120);
  button[10] = new Button(200, 50, "Blur an", 30, 605, 0, 220, 120);
  button[11] = new Button(200, 50, "Blur aus", 30, 660, 0, 220, 120);
  button[12] = new Button(260, 50, "Entwickleroptionen", width - 280, height - 100, 0, 220, 120);

  button[14] = new Button(50, 50, "+", 300, 550, 0, 220, 120);
  button[15] = new Button(50, 50, "-", 300, 610, 0, 220, 120);


  for (int i = 0; i < 16; i++) {
    button[i].drawButton();
  }


  if (button[0].clicked()) {
    text("LOADING...", width / 2, height / 2 + width / 4);
    started  = true;
  } else if (button[1].clicked()) {
    parkour = 0;
  } else if (button[2].clicked()) {
    parkour = 1;
  } else if (button[3].clicked()) {
    parkour = 2;
  } else if (button[4].clicked()) {
    parkour = 3;
  } else if (button[5].clicked()) {
    parkour = 4;
  } else if (button[13].clicked()) {
    parkour = 5;
  }



  if (button[6].clicked()) {
    lineWork = true;
    lineWorkLite = false;
  }

  if (button[7].clicked()) {
    lineWork = false;
  }

  if (button[8].clicked()) {
    lineWorkLite = true;
    lineWork = false;
  }

  if (button[9].clicked()) {
    lineWorkLite = false;
  }

  if (button[10].clicked()) {
    blur = true;
  }

  if (button[11].clicked()) {
    blur = false;
  }

  if (button[12].clicked()) {
    blur = false;
    lineWork = true;
    lineWorkUltra = true;
  }

  if (button[14].clicked()) {
    if (populationCount < 3000) {
      populationCount += 100;
    }
  }

  if (button[15].clicked()) {
    if (populationCount > 100) {
      populationCount -= 100;
    }
  }

  textSize(26);
  if (parkour == 5) {
    text("Parkour " + "SB" + " eingestellt", width / 2 + 150, 60);
  } else {
    text("Parkour " + (parkour + 1) + " eingestellt", width / 2 + 150, 60);
  }

  if (lineWork) {
    text("LineWork aktiviert", width / 2 + 150, 120);
  } else {
    text("LineWork deaktiviert", width / 2 + 150, 120);
  }
  if (lineWorkLite) {
    text("LiteWork aktiviert", width / 2 + 150, 150);
  } else {
    text("LiteWork deaktiviert", width / 2 + 150, 150);
  }

  if (blur) {
    text("Blur aktiviert", width / 2 + 150, 180);
  } else {
    text("Blur deaktiviert", width / 2 + 150, 180);
  }

  text(populationCount + " Subjekte", width / 2 + 150, 210);

  if (lineWorkUltra) {
    text("Ultra aktiviert", width / 2 + 150, 240);
  }

  text("Parkour wählen", 110, 75);
  text("Einstellungen", 50, 360);
  text("Subjektzahl einstellen", 300, 530);

  fill(200);
  rect(370, 280, 620, 200, 15, 15, 15, 15);


  fill(0);
  textSize(14);
  text("Wähle hier deine Einstellungen aus und Starte dann das Programm.", 380, 300);
  text("Die Punkte werden versuchen, den Weg zum Ziel zu finden, sich diesen zu merken ", 380, 314);
  text("und weichen dabei den grauen Hindernissen aus. Es ist eine Evolutionssimulation.", 380, 328);
  text("Mit G wechelst du in den Bau Modus udn kannst Hindernisse bewegen. Mit R kannst du sie", 380, 342);
  text("drehen. Mit D wechselst du zurück. 0-9 für Hindernisswahl. Space für Pause.", 380, 356);
  text("LineWork ist ein optionaler Algorithmus, der den Punkten sagt, ob sie das Ziel schon", 380, 370);
  text("sehen oder nicht. Beschleunigt die Entwicklung, aber tötet den Prozessor.", 380, 384);
  text("Der Grüne Punkt ist immer ein Abbild des Punktes, der in der vorherigen Generation", 380, 398);
  text("der beste war. Punkte sind Rot, wenn sie das Ziel nicht sehen können.", 380, 412);
  text("Einige Kurse enthalten auch türkise Zwischenziele, die den Punkten die Wegfindung", 380, 426);
  text("erleichtern können.", 380, 440);
  text("Entwickelt von Luca Leuschner, mit der Hilfe von CodeBullet-Tutorials", 380, 460);
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////

void levelSelect() {



  if (undefined) {
    subject = new Population(populationCount);
    if (parkour == 0) {

      obstical = new Obstacle[0];
      goal = new Goal[1];

      hindernisszahl = 0;
      torzahl = 1;

      goal[0] = new Goal(width/2, 20, 25, false);
      undefined = false;
      rectMode(CENTER);
      fill(200);
      rect(width/2, height - 25, 50, 50);
      rectMode(CORNER);
      //Leerer Parkour
    } else if (parkour == 1) {

      obstical = new Obstacle[1];
      goal = new Goal[1];

      hindernisszahl = 1;
      torzahl = 1;


      obstical[0] = new Obstacle(200, 500, 600, 15);      // obstical[i] = new Obstacle( X, Y, weite, länge);

      goal[0] = new Goal(width/2, 20, 25, false);         // new Goal ( X Position, Y Position, Größe, Zwischenziel Ja/Nein)
      undefined = false;
      rectMode(CENTER);
      fill(200);
      rect(width/2, height - 25, 50, 50);
      rectMode(CORNER);
      // Goal 0 ist immer das letzte Ziel!!!
      //Einfacher Parkour
    } else if (parkour == 2) {

      obstical = new Obstacle[2];
      goal = new Goal[2];

      hindernisszahl = 2;
      torzahl = 2;

      obstical[1] = new Obstacle(400, 450, 600, 15);
      obstical[0] = new Obstacle(0, 650, 600, 15);

      goal[0] = new Goal(width/2, 20, 25, false);   
      goal[1] = new Goal(width/2, height/2 + 50, 50, true);
      undefined = false;
      rectMode(CENTER);
      fill(200);
      rect(width/2, height - 25, 50, 50);
      rectMode(CORNER);
    } else if (parkour == 3) {

      obstical = new Obstacle[2];
      goal = new Goal[1];

      hindernisszahl = 2;
      torzahl = 1;

      obstical[1] = new Obstacle(400, 450, 600, 15);
      obstical[0] = new Obstacle(0, 650, 600, 15);

      goal[0] = new Goal(width/2, 20, 25, false);   
      undefined = false;
      rectMode(CENTER);
      fill(200);
      rect(width/2, height - 25, 50, 50);
      rectMode(CORNER);
      //Parkour 2 ohne Zwischenziel
    } else if (parkour == 4) {

      obstical = new Obstacle[3];
      goal = new Goal[1];

      hindernisszahl = 3;
      torzahl = 1;

      obstical[2] = new Obstacle(400, 0, 15, 300);
      obstical[1] = new Obstacle(400, 450, 600, 15);
      obstical[0] = new Obstacle(0, 650, 600, 15);

      goal[0] = new Goal(width/2, 20, 25, false);   
      undefined = false;
      rectMode(CENTER);
      fill(200);
      rect(width/2, height - 25, 50, 50);
      rectMode(CORNER);
      //Parkour 3 mit kleiner Zielöffnung, dauert zwar länger, wird aber trotzdem gefunden. Linework wäre cool zum testen.
    } else if (parkour == 5) {

      hindernisszahl = 10;
      torzahl = 1;

      obstical = new Obstacle[hindernisszahl];
      goal = new Goal[torzahl];

      obstical[9] = new Obstacle(-100, -150, 15, 400);
      obstical[8] = new Obstacle(-100, -150, 15, 400);
      obstical[7] = new Obstacle(-100, -150, 15, 400);
      obstical[6] = new Obstacle(-100, -150, 15, 400);
      obstical[5] = new Obstacle(-100, -150, 15, 400);
      obstical[4] = new Obstacle(-100, -150, 15, 400);
      obstical[3] = new Obstacle(-100, -150, 15, 400);
      obstical[2] = new Obstacle(-100, -150, 15, 400);
      obstical[1] = new Obstacle(-100, -150, 15, 400);
      obstical[0] = new Obstacle(-100, -150, 15, 400);

      goal[0] = new Goal(width/2, 20, 25, false);   
      undefined = false;
      pause = true;
      rectMode(CENTER);
      fill(200);
      rect(width/2, height - 25, 50, 50);
      rectMode(CORNER);
    }
  }

  //Der Levelselect mit 5 vordefinierten Leveln. 
  //Level 1: Leer
  //Level 2: Ein mittiges Hinderniss
  //Level 3: Links-Rechts Kurve mit Zwischenziel
  //Level 4: Level 3 ohne Zwischenziel
  //Level 5, Level 4 mit kleinerem Weg
}
