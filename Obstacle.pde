class Obstacle {

  int x, y, w, h, i;
  boolean stepdeathoffmode;

  PVector obstical = new PVector(x, y);

  PVector pointI;
  PVector pointII;

  int inta;
  boolean gMode;





  Obstacle(int x, int y, int w, int h) {

    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;

    if (h < w) {
      pointI = new PVector(x-5, y + h/2);
      pointII = new PVector(x + w + 5, y + h/2);
    } else {
      pointI = new PVector(x+5, y - w/2);
      pointII = new PVector(x + w -5, y + h + w/2);
    }
    noStroke();
    fill(200, 200, 255);
    rect(this.x, this.y, this.w, this.h);
  }



  void show() {

    noStroke();
    if (checkMode()) {
      fill(240, 200, 50);
      rect(x, y, w, h);
    } else {
      fill(100, 200, 255);
      rect(x, y, w, h);
    }
  }

  /////////////////////////////////////////////////////////////////

  boolean obsticalDetection(float xDot, float yDot) {

    if (xDot > x && yDot > y && xDot < x+w && yDot < y + h) {
      return true;
    } else {
      return false;
    }
  }

  /////////////////////////////////////////////////////////////////

  void changePlace() {

    switch(key) {
    case 'g':
      gMode =true;
      x = mouseX;
      y = mouseY;

      if (h < w) {
        pointI = new PVector(x-5, y + h/2);
        pointII = new PVector(x + w + 5, y + h/2);
      } else {
        pointI = new PVector(x+5, y - w/2);
        pointII = new PVector(x + w -5, y + h + w/2);
      }

      i = 1;
      beaten = false;
      break;

    case 'd':
      gMode = false;
      i = 1;
      break;

    case 'r':
      if (keyPressed) {
        trader = true;
      }
      if (trader) {
        if (!keyPressed) {
          int temp = w;
          w = h;
          h = temp;  
          trader = false;
        }
      }
      if (gMode) {
        x = mouseX;
        y = mouseY;
        
         if (h < w) {
        pointI = new PVector(x-5, y + h/2);
        pointII = new PVector(x + w + 5, y + h/2);
      } else {
        pointI = new PVector(x+5, y - w/2);
        pointII = new PVector(x + w -5, y + h + w/2);
      }
      }
      break;
    }
  }

  /////////////////////////////////////////////////////////////////

  boolean checkMode() {
    if ( i == 1) {
      stepdeathoffmode = true;
    }

    return stepdeathoffmode;
  }

  ////////////////////////////////////////////////////////////////
}
