Snake bruh;
int humanDir = 1;
Place lol;
int slowness = 1;
boolean movedThisFrame;
int gameState; //0 = playing, 1 = Paused, 2 = you lost, 3 = you win.
int menu = 0; //0 = Press Start, 1 = Main Menu, 2 = play, 3 = settings, 4 = instructions
int offset;
Button start;
int[] highScores = new int[5];
int worldWidth;
int worldHeight;
int appleScore;
float widthDisp;
float heightDisp;
Button play;
Button set;
Button inst;
Button goBack;
Button goBackGame;
Button pause;
Slider widd;
Slider heii;
Slider app;
Slider sped;
Slider init;
int initialLength;
float e = 2.7182818;
Network skynet;
Evolution nature;
int[] scores;
int generations = 50;
int population = 10000;
int games = 100;
double estimated = 0.000000167*generations*population*games;

void setup() {
  frameRate(60);
  size(1100, 600);
  movedThisFrame = false;
  textAlign(CENTER, CENTER);
  start = new Button(width/2-width/8, height/2-height/10, width/4, height/5, "Start");
  play = new Button(width/2-width/7, height/3+height/15-height/12, width/3.5, height/6, "Play");
  set = new Button(width/2-width/7, height/3+4*height/15-height/12, width/3.5, height/6, "Settings");
  inst = new Button(width/2-width/7, height/3+7*height/15-height/12, width/3.5, height/6, "Instructions");
  goBack = new Button(width/2-width/7, height/3+8*height/15-height/12, width/3.5, height/6, "Return");
  goBackGame = new Button(5*width/6-width/70, height/2-height/12-height/16, width/6, height/8, "Return");
  pause = new Button(5*width/6-width/70, height/2+height/12-height/16, width/6, height/8, "Pause");
  widd = new Slider(width/3-width/10, 2*height/3, width/5, 0.085);
  heii = new Slider(2*width/3-width/10, 2*height/3, width/5, 0.065);
  app = new Slider(width/4-width/12-width/10, height/2-height/12, width/5, 0.10);
  sped = new Slider(width/2-width/10, height/2-height/12, width/5, 0.83);
  init = new Slider(3*width/4+width/12-width/10, height/2-height/12, width/5, 0.30);
  for (int i = 0; i < 5; i++) {
    highScores[i] = 0;
  }
  worldWidth = 25;
  worldHeight = 25;
  appleScore = 2;
  initialLength = 4;
  gameState = 0;
  nature = new Evolution(population);
  //print("Estimated hours: ");
  //println(estimated);
  //nature.brains[0] = loadNet("third");
  //skynet = loadNet("first4");
  //for (int i = 0; i < generations; i++) {
    //if (i != 0) {
      //nature.naturalSelection();
    //}
    //nature.generationPlay(games);
    //print((float)((i+1))*100/generations);
    //println("%");
  //}
  skynet = loadNet("first4");
  //println(nature.scores[nature.maxIndex]);
  //skynet.saveNet("third");
}

Network loadNet(String name) {
  Table tabhidden = loadTable(name+"hidden.csv");
  Table tabm1 = loadTable(name+"matrix1.csv");
  Table tabm2 = loadTable(name+"matrix2.csv");
  TableRow tr = tabhidden.getRow(0);
  int hiddenVal = tr.getInt(0);
  Network answer = new Network(24, hiddenVal, 4, 0);
  for (int i = 0; i < hiddenVal; i++) {
    for (int j = 0; j < 25; j++) {
      answer.m1.actualMatrix[i][j] = tabm1.getFloat(i, j);
    }
  }
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < hiddenVal+1; j++) {
      answer.m2.actualMatrix[i][j] = tabm2.getFloat(i, j);
    }
  }
  return answer;
}

void initializeGame(int sizeX, int sizeY, int scorePerFood) {
  bruh = new Snake(initialLength);
  int xco = 0;
  int yco = 0;
  if (random(2) > 1) {
    xco = 1;
    humanDir = 1;
  } else {
    humanDir = 2;
    yco = 1;
  }
  if (random(2) > 1) {
    xco*=-1;
    yco*=-1;
  }
  humanDir = humanDir + xco + yco;
  for (int i = 0; i < initialLength; i++) {
    bruh.addCoor(i, (int)(sizeX/2)+xco*i, (int)(sizeY/2)+yco*i);
  }
  lol = new Place(sizeX, sizeY, scorePerFood);
  lol.putFood(bruh);
}

float ratio() {
  return ((float)worldWidth / worldHeight);
}

void draw() {
  background(100, 50, 255);
  strokeWeight(3);
  if (menu == 0) {
    fill(255);
    textSize(100);
    text("SNAKE", width/2, height/8);
    start.display();
  } else if (menu == 1) {
    fill(255);
    textSize(100);
    text("SNAKE", width/2, height/8);
    textSize(50);
    text("High Scores:", width/6, height/5);
    textSize(35);
    for (int i = 0; i < 5; i++) {
      if (highScores[i] == 0) {
        break;
      } else {
        text(Integer.toString(i+1)+". "+Integer.toString(highScores[i]), width/6, height/5+height/7*(i+1));
      }
    }
    textSize(50);
    text("Settings:", width/6 + 2*width/3, height/5);
    textSize(35);
    text("Width: "+Integer.toString(worldWidth), width/6 + 2*width/3, height/5+height/7*1);
    text("Height: "+Integer.toString(worldHeight), width/6 + 2*width/3, height/5+2*height/7);
    text("Score/Apple: "+Integer.toString(appleScore), width/6 + 2*width/3, height/5+3*height/7);
    text("Speed: "+Integer.toString(61-slowness), width/6 + 2*width/3, height/5+4*height/7);
    text("Initial Length: "+Integer.toString(initialLength), width/6 + 2*width/3, height/5+5*height/7);
    play.display();
    set.display();
    inst.display();
  } else if (menu == 2) {
    fill(255);
    textSize(40);
    text("Score:", width/4 - widthDisp/4, height/2-height/12);
    text(bruh.leng, width/4 - widthDisp/4, height/2+height/12);
    lol.display(width/2-widthDisp/2, height/2-heightDisp/2, widthDisp, heightDisp, bruh);
    goBackGame.display();
    pause.display();
    if (frameCount % slowness == offset) {
      movedThisFrame = false;
      if (gameState == 0) {
        if (!bruh.dead && !bruh.won) {
          skynet.think(skynet.see(bruh, lol));
          humanDir = skynet.pickAnswer();
          bruh.move(humanDir, lol);
          if (bruh.justAte) {
            if (bruh.won) {
              lol.hasFood = false;
            } else {
              lol.putFood(bruh);
            }
          }
        } else {
          pause.tex = "Retry";
          gameState = 2;
        }
      }
    }
  } else if (menu == 3) {
    float prewidth = map(widd.value, 0, 1, 4, 100.9);
    worldWidth = (int)(prewidth);
    float preheight = map(heii.value, 0, 1, 3, 100.9);
    worldHeight = (int)(preheight);
    float preapp = map(app.value, 0, 1, 1, 20.9);
    appleScore = (int)(preapp);
    float preinitial = map(init.value, 0, 1, 1, 4.9);
    initialLength = (int)(preinitial);
    float prespeed = map(sped.value, 0, 1, 1, 60.9);
    slowness = 61-(int)(prespeed);
    fill(255);
    textSize(80);
    text("Settings", width/2, height/8);
    goBack.display();
    widd.disp();
    textSize(30);
    fill(0);
    text("Width: "+Integer.toString(worldWidth), width/3, 2*height/3 - height/12);
    heii.disp();
    text("Height: "+Integer.toString(worldHeight), 2*width/3, 2*height/3 - height/12);
    app.disp();
    text("Initial length: "+Integer.toString(initialLength), 3*width/4+width/12, height/2-height/6);
    sped.disp();
    text("Speed: "+Integer.toString(61-slowness), width/2, height/2-height/6);
    init.disp();
    text("Apple value: "+Integer.toString(appleScore), width/4-width/12, height/2-height/6);
  } else if (menu == 4) {
    fill(255);
    textSize(80);
    text("Instructions", width/2, height/8);
    textSize(50);
    text("Use WASD or arrow keys to move", width/2, height/3);
    text("The goal of the game is to grow as much", width/2, height/3+height/7);
    text("as you can by eating apples (red squares)", width/2, height/3+1.5*height/7);
    text("Avoid touching yourself or the walls", width /2, height/3+2.5*height/7);
    goBack.display();
  }
}

void keyPressed() {
  if (!movedThisFrame) {
    if (key == CODED) {
      if (keyCode == RIGHT && humanDir != 2) {
        humanDir = 0;
      } else if (keyCode == UP && humanDir != 1) {
        humanDir = 3;
      } else if (keyCode == DOWN && humanDir != 3) {
        humanDir = 1;
      } else if (keyCode == LEFT && humanDir != 0) {
        humanDir = 2;
      }
    } else {
      if ((key == 'd' || key == 'D') && humanDir != 2) {
        humanDir = 0;
      } else if ((key == 'w' || key == 'W') && humanDir != 1) {
        humanDir = 3;
      } else if ((key == 's' || key == 'S') && humanDir != 3) {
        humanDir = 1;
      } else if ((key == 'a' || key == 'A') && humanDir != 0) {
        humanDir = 2;
      }
    }
    movedThisFrame = true;
  }
}

float sigmoid(float x) {
  return(1/(1+(float)Math.pow(e, -x)));
}

void mouseClicked() {
  if (menu == 0) {
    if (start.click()) {
      menu = 1;
    }
  } else if (menu == 1) {
    if (play.click()) {
      pause.tex = "Pause";
      if (ratio() > 4/3) {
        widthDisp = 666;
        heightDisp = 666/ratio();
      } else if (ratio() <= 4/3) {
        heightDisp = 500;
        widthDisp = 500*ratio();
      }
      initializeGame(worldWidth, worldHeight, appleScore);
      offset = frameCount%slowness;
      gameState = 0;
      menu = 2;
    } else if (set.click()) {
      menu = 3;
    } else if (inst.click()) {
      menu = 4;
    }
  } else if (menu == 2) {
    if (pause.click()) {
      if (gameState == 1) {
        gameState = 0;
        pause.tex = "Pause";
      } else if (gameState == 0) {
        pause.tex = "Resume";
        gameState = 1;
      } else if (gameState == 2) {
        humanDir = 0;
        for (int i = 0; i < 5; i++) {
          if (bruh.leng > highScores[i]) {
            for (int j = 4; j > i; j--) {
              highScores[j] = highScores[j-1];
            }
            highScores[i] = bruh.leng;
            break;
          }
        }
        pause.tex = "Pause";
        gameState = 0;
        initializeGame(worldWidth, worldHeight, appleScore);
        offset = frameCount%slowness;
      }
    } else if (goBackGame.click()) {
      for (int i = 0; i < 5; i++) {
        if (bruh.leng > highScores[i]) {
          for (int j = 4; j > i; j--) {
            highScores[j] = highScores[j-1];
          }
          highScores[i] = bruh.leng;
          break;
        }
      }
      menu = 1;
    }
  } else if (menu == 3) {
    if (goBack.click()) {
      menu = 1;
    }
  } else if (menu == 4) {
    if (goBack.click()) {
      menu = 1;
    }
  }
}

void mouseDragged() {
  if (menu == 3) {
    if (widd.checkOnTop()) {
      if (mouseX < widd.posX) {
        widd.value = 0;
      } else if (mouseX < widd.posX + widd.leng) {
        widd.value = map(mouseX, widd.posX, widd.posX+widd.leng, 0, 1);
      } else {
        widd.value = 1;
      }
    } else if (heii.checkOnTop()) {
      if (mouseX < heii.posX) {
        heii.value = 0;
      } else if (mouseX < heii.posX + heii.leng) {
        heii.value = map(mouseX, heii.posX, heii.posX+heii.leng, 0, 1);
      } else {
        heii.value = 1;
      }
    } else if (app.checkOnTop()) {
      if (mouseX < app.posX) {
        app.value = 0;
      } else if (mouseX < app.posX + app.leng) {
        app.value = map(mouseX, app.posX, app.posX+app.leng, 0, 1);
      } else {
        app.value = 1;
      }
    } else if (init.checkOnTop()) {
      if (mouseX < init.posX) {
        init.value = 0;
      } else if (mouseX < init.posX + init.leng) {
        init.value = map(mouseX, init.posX, init.posX+init.leng, 0, 1);
      } else {
        init.value = 1;
      }
    } else if (sped.checkOnTop()) {
      if (mouseX < sped.posX) {
        sped.value = 0;
      } else if (mouseX < sped.posX + sped.leng) {
        sped.value = map(mouseX, sped.posX, sped.posX+sped.leng, 0, 1);
      } else {
        sped.value = 1;
      }
    }
  }
}
