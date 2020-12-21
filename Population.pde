class Population {
  Dot[] dot;
  Boolean[] counted;
  
  float fitnessSum;
  int gen;

  int heron = 0;
  int minStep = 750;
  
  int deaad;

  boolean stepDeath = false;

  


  Population(int size) {

    dot = new Dot[size];
    counted = new Boolean[size];

    for (int i = 0; i < dot.length; i++) {
      dot[i] = new Dot();
    }
    
    for (int i = 0; i < dot.length; i++) {
      counted[i] = false;
    }
  }




  void display() {
    for (int i = 0; i < dot.length; i++) {
      if (i < 10)
      {
        dot[i].display();
      } else {
        dot[i].display(); 
        if (!dot[i].dead) {
          if (lineWorkUltra) {
            stroke(0.02);
            strokeWeight(0.5);
            line(dot[i].location.x, dot[i].location.y, goal[0].x, goal[0].y);
          }
        }
      }
    }
    dot[0].display();
  }

  ///////////////////////////////////////////////////////

  void checkEdge() {
    for (int i = 0; i < dot.length; i++) {
      dot[i].checkEdge();
    }
  }

  ///////////////////////////////////////////////////////

  void stepdeathnt() {

    stepDeath = true;
  }

  ///////////////////////////////////////////////////////////

  void update() {

    
    
    for (int i = 0; i < dot.length; i++) {
      
      countDead(i);
      if (dot[i].brain.step > minStep && !stepDeath) {
        dot[i].timeOut = true;
        
      } else {

        dot[i].update();
        if (lineWork) {
          dot[i].checkRoute(i);
        }
      }
    }
  }

  /////////////////////////////////////////////////////////

  void calculateFitness() {
    for (int i = 0; i < dot.length; i++) {
      if (lineWorkLite) {
        dot[i].checkRoute(i);
        println(dot[i].blockedWay);
      }
      dot[i].calculateFitness();
      
    }
  }

  //////////////////////////////////////////////////////////
  
  void countDead(int i){
    
    if(!counted[i]){
      if(dot[i].dead == true || dot[i].oDead == true ) {
       deaad++; 
       counted[i] = true;
      }
    }
    
  }
  
 /////////////////////////////////////////////////////////////

  boolean allDotsDead() {
    for (int i = 0; i < dot.length; i++) {
      if (!dot[i].dead && !dot[i].goalReached && !dot[i].oDead && !dot[i].timeOut) {
        return false;
      }
    }
    return true;
  }

  ////////////////////////////////////////////////////////////

  void nSelection() {
    Dot[] newDots = new Dot[dot.length];
    setBestDot();
    calculateFitnessSum();

    newDots[0] = dot[heron].makeBaby();
    newDots[0].isBest = true; 

    for (int i = 1; i < newDots.length; i++) {

      Dot parent = selectParent();

      newDots[i] = parent.makeBaby();
    }

    dot = newDots.clone();
    gen++;
  }

  /////////////////////////////////////////////////////////////

  Dot selectParent() {
    float rand = random(fitnessSum);

    float runningSum = 0;

    for (int i = 0; i < dot.length; i++) {
      runningSum += dot[i].fitness;
      if (runningSum > rand) {
        return dot[i];
      }
    }

    //kommt hier nie hin (hoffentlich)
    return dot[1];
  }
  ///////////////////////////////////////////////////////////////

  void calculateFitnessSum() {
    fitnessSum = 0;
    for (int i = 0; i < dot.length; i++) {
      fitnessSum += dot[i].fitness;
    }
  }

  ///////////////////////////////////////////////////////////////

  void mutation() {
    for (int i = 1; i < dot.length; i++) {
      dot[i].brain.mutate();
    }
  }

  ////////////////////////////////////////////////////////////////

  void setBestDot() {
    float max = 0;
    int maxIndex = 0;

    for (int i = 0; i < dot.length; i++) {
      if (dot[i].fitness > max) {
        max = dot[i].fitness;
        maxIndex = i;
      }
    }
    heron = maxIndex;


    if (dot[heron].goalReached) {
      minStep = dot[heron].brain.step;
    }
  }
}
