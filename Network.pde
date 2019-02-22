class Network {
  int inputs;
  int hidden;
  int outputs;
  float mute;
  float[] hiddenVector;
  float[] tempVector;
  float[] outVector;
  Matrix m1;
  Matrix m2;
  Network(int in, int hi, int ou, float mutation) {
    inputs = in;
    hidden = hi;
    outputs = ou;
    mute = mutation;
    m1 = new Matrix(hidden, inputs+1);
    m1.create(mute);
    m2 = new Matrix(outputs, hidden+1);
    m2.create(mute);
    hiddenVector = new float[hidden+1];
    tempVector = new float[hidden];
    outVector = new float[outputs];
  }

  void think(float[] ins) {
    tempVector = m1.times(ins);
    for (int i = 0; i < hidden; i++) {
      hiddenVector[i] = sigmoid(tempVector[i]);
    }
    hiddenVector[hidden] = 0;
    outVector = m2.times(hiddenVector);
    for (int i = 0; i < outputs; i++) {
      outVector[i] = sigmoid(outVector[i]);
    }
  }

  float[] see(Snake snek, Place world) {
    float[] ans = new float[inputs+1];
    int ind = 0;
    boolean somethingFound;
    int incX = 0;
    int incY = 0;
    int distance;
    for (int i = 0; i < 3; i++) { //Cycling thorugh food, walls and self
      for (int j = -1; j < 2; j++) { //Cycling through x coor
        int currentPosX = snek.positions[snek.head][0];
        incX = j;
        for (int k = -1; k < 2; k++) { //Ycor
          int currentPosY = snek.positions[snek.head][1];
          somethingFound = false;
          distance = 0;
          incY = k;
          if (j == 0 && k == 0) {
            continue;
          } else {
            do {
              distance++;
              currentPosX += incX;
              currentPosY += incY;
              if (i == 0) {
                if (currentPosX == world.foodX && currentPosY == world.foodY) {
                  somethingFound = true;
                }
              } else if (i == 1) {
                for (int l = 0; l < snek.leng; l++) {
                  if (currentPosX == snek.positions[l][0] && currentPosY == snek.positions[l][1]) {
                    somethingFound = true;
                  }
                }
              } else {
                if (currentPosX == -1 || currentPosX == world.w || currentPosY == -1 || currentPosY == world.h) {
                  somethingFound = true;
                }
              }
            } while (!somethingFound && distance < world.w*world.h);
            if (i == 0) {
              if (somethingFound) {
                ans[ind] = 1;
              } else {
                ans[ind] = 0;
              }
            } else {
              if (somethingFound) {
                ans[ind] = 1/distance;
              } else {
                ans[ind] = 0;
              }
            }
            ind++;
          }
        }
      }
    }
    ans[inputs] = 1;
    return ans;
  }

  int pickAnswer() {
    boolean bad = true;
    int ans = -1;
    float max = 0;
    int maxIndex = 0;
    for (int i = 0; i < outputs; i ++) {
      if (outVector[i] > max) {
        max = outVector[i];
        maxIndex = i;
      }
    }
    if (humanDir == 0) {
      if (maxIndex != 2) {
        ans = maxIndex;
        bad = false;
      }
    } else if (humanDir == 1) {
     if (maxIndex != 3) {
       ans = maxIndex;
       bad = false;
     }
    } else if (humanDir == 2) {
      if (maxIndex != 0) {
        ans = maxIndex;
        bad = false;
      }
    } else if (humanDir == 3) {
      if (maxIndex != 1) {
        ans = maxIndex;
        bad = false;
      }
    } 
    if (bad) {
      max = 0;
      for (int i = 0; i < outputs; i ++) {
        if (i == maxIndex) {
          continue;
        } else {
          if (outVector[i] > max) {
            max = outVector[i];
            ans = i;
          }
        }
      }
    }
    return ans;
  }

  float playGame() {
    initializeGame(worldWidth, worldHeight, appleScore);
    float totalturns = 0;
    int turns = 0;
    while (!bruh.dead && !bruh.won && turns < 60) {
      totalturns ++;
      turns++;
      think(see(bruh, lol));
      humanDir = pickAnswer();
      bruh.move(humanDir, lol);
      if (bruh.justAte) {
        turns = 0;
        if (bruh.won) {
          lol.hasFood = false;
        } else {
          lol.putFood(bruh);
        }
      }
    }
    return (float)(bruh.leng);
  }
  
  void mutate() {
    m1.mutate(mute);
    m2.mutate(mute);
  }
  
  Network clone() {
    Network clone  = new Network(inputs, hidden, outputs,mute); 
    clone.m1 = m1.clone();
    clone.m2 = m2.clone();

    return clone;
  }
  
  void saveNet(String name) {
    Table hiddenNum = new Table();
    Table matrix1 = new Table();
    Table matrix2 = new Table();
    hiddenNum.addColumn();
    TableRow hiddenNumRow = hiddenNum.addRow();
    hiddenNumRow.setInt(0,hidden);
    saveTable(hiddenNum,name+"hidden.csv");
    for(int i = 0; i < 25; i++) {
      matrix1.addColumn();
    }
    for (int i = 0; i < hidden; i++) {
      matrix1.addRow();
    }
    for (int i = 0; i < hidden; i++) {
      for (int j = 0; j < 25; j++) {
        matrix1.setFloat(i,j,m1.actualMatrix[i][j]);
      }
    }
    saveTable(matrix1 , name+"matrix1.csv");
    for(int i = 0; i < hidden+1; i++) {
      matrix2.addColumn();
    }
    for (int i = 0; i < 4; i++) {
      matrix2.addRow();
    }
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < hidden+1;j++) {
        matrix2.setFloat(i,j,m2.actualMatrix[i][j]);
      }
    }
    saveTable(matrix2 , name+"matrix2.csv");
  }
  
  
}
