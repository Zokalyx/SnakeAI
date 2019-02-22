class Snake {
  int leng;
  int head;
  int[][] positions;
  int[][] aux;
  boolean dead;
  boolean won;
  boolean justAte;
  int queueX;
  int queueY;
  int queueLength;

  Snake(int tempL) {
    leng = tempL;
    positions = new int[leng][2];
    head = 0;
    dead = false;
    won = false;
    justAte = false;
    queueLength = 0;
  }

  void addCoor(int ind, int xpos, int ypos) {
    positions[ind][0] = xpos;
    positions[ind][1] = ypos;
  }

  int getCoor(int inde, int xory) {
    return positions[inde][xory];
  }

  void move(int direction, Place world) {//0 = right, 1 = down, 2 = left, 3 = up
    justAte = false;
    int incX = 0;
    int incY = 0;
    if (direction == 0) {
      incX = 1;
    } else if (direction == 1) {
      incY = 1;
    } else if (direction == 2) {
      incX = -1;
    } else if (direction == 3) {
      incY = -1;
    }
    int newPosX = positions[head][0] + incX;
    int newPosY = positions[head][1] + incY;
    boolean hitItself = false;
    int last;
    if (head == 0) {
       last = leng-1;
    } else {
       last = head-1;
    }
    for (int i = 0; i < leng; i++) {
      if (newPosX == positions[i][0] && newPosY == positions[i][1]) {
        if (i == last && queueLength == 0) {
          continue;
        } else {
        hitItself = true;
        }
      }
    }
    if (hitItself || newPosX == -1 || newPosX == world.w || newPosY == -1 || newPosY == world.h) {
      dead = true;
    } else if (newPosX == world.foodX && newPosY == world.foodY) {
      justAte = true;
      queueLength += world.foodScore;
    }
    if (!dead) {
      if (head == 0) {
        head = leng-1;
      } else {
        head --;
      }
      queueX = positions[head][0];
      queueY = positions[head][1];
      positions[head][0] = newPosX;
      positions[head][1] = newPosY;
      if (queueLength > 0) {
        aux = new int[leng+1][2];
        int extra = 0;
        for (int i = 0; i < leng; i++) {
          if (i+head == leng) {
            extra = leng;
          }
          aux[i][0] = positions[i+head-extra][0];
          aux[i][1] = positions[i+head-extra][1];
        }
        leng++;
        queueLength --;
        aux[leng-1][0] = queueX;
        aux[leng-1][1] = queueY;
        positions = new int[leng+1][2];
        head = 0;
        for (int i = 0; i < leng; i++) {
          positions[i][0] = aux[i][0];
          positions[i][1] = aux[i][1];
        }
        if (leng == world.w*world.h) {
          won = true;
        }
      }
    }
  }
}
