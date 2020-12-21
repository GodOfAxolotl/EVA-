class Button {  //<>//

  float button_size_length;
  float button_size_height;
  float xPos;
  float yPos;
  boolean mouse_was_down = false;
  String text;

  int r, g, b;




  Button(float l, float h, String text, float x, float y, int r, int b, int g) {

    button_size_length = l;
    button_size_height = h;
    this.text = text;
    this.xPos = x;
    this.yPos = y;
    this.r = r;
    this.b = b;
    this.g = g;
  } 

  ////////////////////////////////////////////////////////////////////////////////////

  void drawButton() {


    stroke(r/2, g/2, b/2);
    fill(r, g, b);
    rect(xPos, yPos, button_size_length, button_size_height, 10, 10, 10, 10);
    textSize(26);
    fill(0, 0, 0);
    text(text, xPos + button_size_length / 2 - text.length() * 26/4, yPos + button_size_height / 2 + 26/4);
  }

  ////////////////////////////////////////////////////////////////////////////////////

  boolean clicked() {

    if (mousePressed && isMouseInImage()) {
      mouse_was_down = true;
    }

    if (mousePressed && mouse_was_down) {
      return true;
    }

    return false;
  }



  ////////////////////////////////////////////////////////////////////////////////////

  boolean isMouseInImage() {

    if (mouseX > xPos &&
      mouseX < xPos + button_size_length &&
      mouseY > yPos &&
      mouseY < yPos + button_size_height) {
      return true;
    }

    return false;
  }
}
