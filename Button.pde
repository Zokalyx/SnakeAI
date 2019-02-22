class Button {
  float posX;
  float posY;
  float w;
  float h;
  String tex;
  Button(float px, float py, float wi, float he, String text) {
    posX = px;
    posY = py;
    w = wi;
    h = he;
    tex = text;
  }

  boolean click() {
    return (mouseX > posX && mouseX < posX + w && mouseY > posY && mouseY < posY + h);
  }
  
  void display() {
    fill(0);
    stroke(255);
    rect(posX,posY,w,h);
    textSize(45);
    fill(255);
    text(tex,posX+w/2,posY+h/2);
  }
}
