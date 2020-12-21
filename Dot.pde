class Dot {

  PVector velocity;
  PVector location;
  PVector acceleration;
  Brain brain;                    //Punkt auf der Fläche, sowie ein "Gehirn" für die Richtung und Bewegungen für jeden Punkt

  int maxSpeed = 7;              //Höchstgeschwindigkeit
  boolean dead = false;          //Tod durch Randberührung
  boolean oDead = false;         // Tod durch Hinderniss
  boolean timeOut = false;      // Tod durch abgelaufene Zeit / Keine Schritte (Richtungen) mehr übrig
  int deadCount;                 //Wie viele sind tot?
  int dot_size = 5;              //Punktgröße
  int stepCount = 750;           //Wieviele Schritte dürfen die Punkte gehen/ WIe lange dürfen die Punkte brauchen?

  float fitness = 0;            //Fitness ist ein Faktor, der Zeigt wie Dominant und Stark und Gut das Gehirn ist
  boolean goalReached;          //Hat der Punkt das ziel erreicht?
  boolean semigoalReached;      //Hat der Punkt ein Zwischenziel erreicht?

  boolean blockedWay;
  boolean wasUnblocked;

  boolean isBest = false;   
  
  float goalDistance;

  float x1[] = new float[populationCount];
  float y1[] = new float[populationCount];
  float x2[] = new float[populationCount]; 
  float y2[] = new float[populationCount];

  float x3[][] = new float[populationCount][10]; 
  float y3[][] = new float[populationCount][10];
  float x4[][] = new float[populationCount][10];
  float y4[][] = new float[populationCount][10];

  float uA[] = new float[populationCount];
  float uB[] = new float[populationCount];



  Dot() {
    location = new PVector(width/2, height-20);
    velocity = new PVector(0, 0);
    brain = new Brain(stepCount);
  }  //Konstruktor

  //////////////////////////////////////////////////////////////////////////

  void update() {

    if (!dead && !goalReached && !oDead && !timeOut) { // Test ob der Punkt bereits Tot ist oder das Ziel erreicht hat wenn ja wird er nicht mehr von update() erfasst

      if (brain.direction.length > brain.step) { 
        acceleration = brain.direction[brain.step];
        brain.step++; //Zählt die Schritte des Gehirns ab
        acceleration.normalize(); 
        acceleration.mult(0.6);

        velocity.add(acceleration);
        velocity.limit(maxSpeed);
        location.add(velocity);        //Geschwindigkeit nimmt zu, Ort ändert sich um den Faktor der Geschwindigkeit
      } else {
        dead = true;      //Stirbt nach zu vielen Schritten
      }
    }
  }                                                 //Update der Position

  ////////////////////////////////////////////////////////////////////////

  void display() {

    if (isBest) {
      fill(30, 255, 30);
      ellipse(location.x, location.y, dot_size, dot_size);  //Der Beste Punkt der vorherigen Generation ist grün                                       //Zeichnet die Punkte an der in update() berrechneten Position
    } else if (blockedWay) {
      fill(200, 30, 30);
      ellipse(location.x, location.y, dot_size, dot_size);
    } else {
      noStroke();
      fill(0, 0, 0);
      ellipse(location.x, location.y, dot_size, dot_size);
    }
  }

  ////////////////////////////////////////////////////////////////////////

  void checkEdge() {    
    if (location.x > width-4) {
      //location.x = 0;
      velocity.x = velocity.x * -1;
      location.x = width;
      dead = true;
      deadCount++;
    } else if (location.x < 4) {
      //location.x = width;
      velocity.x = velocity.x * -1;
      location.x = 0;
      dead = true;
      deadCount++;
    }

    if (location.y > height-4) {
      //location.y = 0;
      velocity.y = velocity.y * -1;
      location.y = height;
      dead = true;
      deadCount++;
    } else if (location.y < 4) {
      //location.y = height;
      velocity.y = velocity.y * -1;
      location.y = 0;
      dead = true;
      deadCount++;
    }                                          
    //Kollisionsabfrage zu den Wänden, tötet die Punkte an den Wänden

    for (int i = 0; i < goal.length; i++) {

      if (!goal[i].semi) { 
        if (goal[i].checkGoal(location.x, location.y)) {
          goalReached = true;
          beaten = true;
        }
      } else if (goal[i].checkSemiGoal(location.x, location.y)) {
        semigoalReached = true;
      }
    }    //Zielabfrage mit anschließendem Ausdruck der Generation

    for (int i = 0; i < obstical.length; i++) {
      if (obstical[i].obsticalDetection(location.x, location.y)) {
        oDead = true;
      }
    } //Kollisionsabfrage Hindernisse, siehe OBSTACLE
  }                                                                  //Kollisionsabfragen

  //////////////////////////////////////////////////////////////////////


  void checkRouteVar(int i, int r) {

    x1[i] = goal[0].goal.x;
    y1[i] = goal[0].goal.y;
    x2[i] = location.x;
    y2[i] = location.y;

    x3[i][r] = obstical[r].pointI.x;
    y3[i][r] = obstical[r].pointI.y;
    x4[i][r] = obstical[r].pointII.x;
    y4[i][r] = obstical[r].pointII.y;
  }

  ///////////////////////////////////////////////////////////////////

  void checkRoute(int i) {
    
    blockedWay = false;
    if (true) {
      
      for (int r = 0; r < obstical.length; r++) {

        checkRouteVar(i, r);

        uA[r] = ((x4[i][r]-x3[i][r])*(y1[i]-y3[i][r]) - (y4[i][r]-y3[i][r])*(x1[i]-x3[i][r])) / ((y4[i][r]-y3[i][r])*(x2[i]-x1[i]) - (x4[i][r]-x3[i][r])*(y2[i]-y1[i]));
        uB[r] = ((x2[i]-x1[i])*(y1[i]-y3[i][r]) - (y2[i]-y1[i])*(x1[i]-x3[i][r])) / ((y4[i][r]-y3[i][r])*(x2[i]-x1[i]) - (x4[i][r]-x3[i][r])*(y2[i]-y1[i]));

        if (uA[r] >= 0 && uA[r] <= 1 && uB[r] >= 0 && uB[r] <= 1) {
          blockedWay = true;
        } else if(!blockedWay){
          blockedWay = false;
          wasUnblocked = true;
        }
      }
    }
  }


  ////////////////////////////////////////////////////////

  void calculateFitness() {

    float goalDistance = dist(location.x, location.y, goal[0].x, goal[0].y); 
    if (goalReached) {

      fitness = 10000000000.0/(float)(brain.step * brain.step);         // Erreichen des Ziels. Gibt eine abolue Zahl an Fitnesspunkten, aber mehr mit weniger Schritten
    } else if (oDead && blockedWay) {

      fitness = 1/(goalDistance * goalDistance );                    // Sterben an einem vom Ziel entfernten Hinderniss. Kaum Punkte
    } else if (timeOut && blockedWay) {

      fitness = 1/(goalDistance * goalDistance);                         // Sterben durch TimeOut. Einige Punkte.
      
    } else if (timeOut && !blockedWay) {

      fitness = 1/(goalDistance * 2);                         // Sterben durch TimeOut. Einige Punkte.
      
    } else if (oDead && !blockedWay){
      fitness = 1/(goalDistance * 3);
                                                                          //nicht blockierter weg und hinderniss, sehr schön
    } else if (!blockedWay) {

         fitness = 1/(goalDistance * 2);                       //Nicht blockierter Weg an einer Wand, wunderbar!
      
    } else {
      fitness = 1/(goalDistance * goalDistance * goalDistance );            // Sterben an einer Wand blockierten Wand. Nein Punkte
    }
    if (semigoalReached && !goalReached) {
      fitness += 100;                                          // Erreichen eines Zwischenzieles erhöht die Punkte
    }
    

  }// Der Algorithmus der sagt wie stark ein Punkt war



  //////////////////////////////////////////////////////////////////////////////////

  Dot makeBaby() {
    Dot baby = new Dot();
    baby.brain = brain.clone();
    return baby;
  }                              //Neue Babys werden gemacht. Wo kommen sie her? Man weiß es nicht...
}
