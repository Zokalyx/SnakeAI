class Slider {
  float posX;
  float posY;
  float leng;
  float value; //PERCENTAGE
  Slider(float px,float py, float pl, float initvalue) {
    posX = px;
    posY = py;
    leng = pl;
    value = initvalue;
  }
  
  void disp() {
    noFill();
    strokeWeight(10);
    stroke(255);
    rect(posX,posY,leng,4,1);
    noStroke();
    fill(0);
    ellipse(posX+value*leng,posY+3,30,30);
  }
  
  boolean checkOnTop() {
    return dist(mouseX,mouseY,posX+value*leng,posY+3) <= 30;
  }
}
