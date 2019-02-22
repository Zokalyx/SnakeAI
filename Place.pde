class Place {

  int w;
  int h;
  float squareX;
  float squareY;
  int foodX;
  int foodY;
  boolean hasFood;
  int possibleValX;
  int possibleValY;
  int foodScore;

  Place(int tempW, int tempH, int foodVal) {
    w = tempW;
    h = tempH;
    hasFood = false;
    foodScore = foodVal;
  }

  void putFood(Snake snek) {
    boolean foodIsGood;
    do {
      foodIsGood = true;
      possibleValX = (int)(Math.random()*w);
      possibleValY = (int)(Math.random()*h);
      for (int i = 0; i < snek.leng; i++) {
        if (possibleValX == snek.getCoor(i, 0) && possibleValY == snek.getCoor(i, 1)) {
          foodIsGood = false;
        }
      }
    } while (!foodIsGood);
    foodX = possibleValX;
    foodY = possibleValY;
    hasFood = true;
  }

  void removeFood() {
    hasFood = false;
  }

  void display(float upLeft, float upRight, float wid, float hei, Snake snek) {
    squareX = wid/w;
    squareY = hei/h;
    push();
    translate(upLeft, upRight);
    noFill();
    strokeWeight(4);
    stroke(255);
    rect(0, 0, wid, hei);
    noStroke();
    fill(0);
    rect(0, 0, wid, hei);
    for (int i = 0; i < snek.leng; i++) {
      float xpos = snek.getCoor(i, 0);
      float ypos = snek.getCoor(i, 1);
      push();
      translate(xpos*squareX, ypos*squareY);
      fill(0, 255, 0);
      stroke(0,255,0);
      strokeWeight(1);
      rect(0, 0, squareX, squareY);
      noStroke();
      fill(0, 255, 255);
      if (snek.leng == 1) {
        rect(squareX/4, squareY/4, squareX/2, squareY/2);
      }
      pop();
    }
    if (snek.leng > 1) {
      int extra = 0;
      for (int i = 0; i < snek.leng-1; i++) {
        if (i+snek.head == snek.leng) {
            extra = snek.leng;
          }
        float xpos = snek.getCoor(i+snek.head-extra, 0);
        float ypos = snek.getCoor(i+snek.head-extra, 1);
        int otherIndex = i+snek.head-extra+1;
        if (otherIndex == snek.leng) {
          otherIndex = 0;
        }
        float moveRight = 0;
        float moveLeft = 0;
        float moveUp = 0;
        float moveDown = 0;
        if (snek.getCoor(otherIndex, 0) - snek.getCoor(i+snek.head-extra, 0) == 1) {
          moveRight = 1;
        } else if (snek.getCoor(otherIndex, 0) - snek.getCoor(i+snek.head-extra, 0) == -1) {
          moveLeft = 1;
        } else if (snek.getCoor(otherIndex, 1) - snek.getCoor(i+snek.head-extra, 1) == 1) {
          moveDown = 1;
        } else if (snek.getCoor(otherIndex, 1) - snek.getCoor(i+snek.head-extra, 1) == -1) {
          moveUp = 1;
        }
        push();
        translate(xpos*squareX-squareX*moveLeft, ypos*squareY-squareY*moveUp);
        fill(0, 255, 255);
        rect(squareX/4, squareY/4, squareX/2+squareX*moveRight+squareX*moveLeft, squareY/2+squareY*moveUp+squareY*moveDown);
        pop();
        //float xpos = snek.getCoor(i, 0);
        //float ypos = snek.getCoor(i, 1);
        //push();
        //translate(xpos*squareX,ypos*squareY);
        //if (true) {
        //push();
        //translate(-moveLeft*squareX,-moveUp*squareY);
        //fill(100, 0, 255);
        //rect(squareX/4, squareY/4, squareX*(1/2), squareY*(1/2));
        //pop();
        //}
        //pop();
      }
    }
    if (hasFood) {
      fill(255, 0, 0);
      rect(squareX*foodX, squareY*foodY, squareX, squareY);
    }
    pop();
  }
}
