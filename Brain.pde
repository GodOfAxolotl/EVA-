class Brain {

  PVector[] direction;
  int step = 0;




  Brain(int size) {
    direction = new PVector[size]; 
    randomize();
  }

  //////////////////////////////////////////////////////

  void randomize() {
    for (int i = 0; i < direction.length; i++) {
      float randomAngle = random(2*PI);
      direction[i] = PVector.fromAngle(randomAngle);
    }
  }                                                    //Jedes Gehirn bekommt einen Haufen zufälliger Richtungen (als Vektor) zugewiesen

  //////////////////////////////////////////////////

  Brain clone() {
    Brain clone = new Brain(direction.length);
    for (int i = 0; i < direction.length; i++) {
      clone.direction[i] = direction[i].copy();
    }                                                 //Es werden Kopien der Vektoren erstellt und unter clone.direction[] abgelegt

    return clone;                                     //Die Kopie eines Gehirns wird ausgegeben
  }

  ////////////////////////////////////////////////////////

  void mutate() {
    for (int i = 0; i < direction.length; i++) {
      float rand = random(1);
      if (rand < mutationRate) {
        float randomAngle = random(2*PI);
        direction[i] = PVector.fromAngle(randomAngle);  //Es wird eine neue Richtung generiert bzw. mutiert und später als gut selektiert
      }
    }
  }
}
