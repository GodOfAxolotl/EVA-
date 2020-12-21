class Goal {

  float x, y, size;

  boolean semi;
  int goalcount = 0;
  
  PVector goal;





  Goal(float x, float y, float size, boolean semigoal) {


    this.x = x;
    this.y = y;
    this.size = size;
    semi = semigoal;

    goal = new PVector(x, y);

    rectMode(CENTER);
    fill(0, 255, 120);
    ellipse(goal.x, goal.y, size, size);
    rectMode(CORNER);
  }

  ///////////////////////////////////////////////////////////////////////////

  void showGoal() {
    if (!semi) {
      stroke(0);
      fill(150, 245, 120);
      ellipse(goal.x, goal.y, size, size);
    } else {
      fill(0, 255, 220);
      rectMode(CENTER);
      rect(goal.x, goal.y, size, size);
      rectMode(CORNER);
    }
  }                                              //Zeichne das Goal, zwischenziele in anderen Farben und Formen

  //////////////////////////////////////////////////////////////////////////////////

  boolean checkGoal(float x, float y) {


    if (!semi) {
      if (dist(x, y, goal.x, goal.y) < size/2) {
        goalcount++;
        return true;

      }
    }

    return false;
  }                            //Kollisionsabfrage

  /////////////////////////////////////////////////////////////////////////////////

  boolean checkSemiGoal(float x, float y) {

    if (dist(x, y, goal.x, goal.y) < size/2) {
      return true;
    }

    return false;
  }                          //Kollisionsabfrage Zwischenziel

  //
}
