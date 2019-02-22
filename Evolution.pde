class Evolution {
  Network[] brains;
  int num;
  int[] scores;
  int maxIndex;
  Evolution(int number) {
    num = number;
    scores = new int[num];
    brains = new Network[num];
    for (int i = 0; i < num; i++) {
      brains[i] = new Network(24, 14, 4, 0.1);
    }
  }
  void generationPlay(int games) {
    for (int i = 0; i<num; i++) {
      int prescore = 0;
      for (int j = 0; j < games; j++) {
        prescore += brains[i].playGame();
      }
      scores[i] = prescore;
    }
  }

  void sortNetworks() {
    int aux;
    Network auxN;
    for (int currentSorting = 0; currentSorting < num; currentSorting++) {
      for (int otherIndex = num-1; otherIndex > currentSorting; otherIndex--) {
        if (scores[otherIndex] > scores[otherIndex-1]) {
          aux = scores[otherIndex-1];
          auxN = brains[otherIndex-1].clone();
          scores[otherIndex-1] = scores[otherIndex];
          brains[otherIndex-1] = brains[otherIndex].clone();
          scores[otherIndex] = aux;
          brains[otherIndex] = auxN.clone();
        }
      }
    }
    println(scores[0]);
  }

  void naturalSelection() {
    maxIndex = 0;
    int max = 0;
    for (int i = 0; i < num; i++) {
      if (scores[i] > max) {
        max = scores[i];
        maxIndex = i;
      }
    }
    //println(maxIndex);
    //for (int i = 0; i < num; i++) {
      //print(i);
      //print("|");
      //println(scores[i]);
    //}
    for (int i = 0; i < num; i++) {
      if (i == maxIndex) {
        //print("Left this alone: ");
        //println(i);
        continue;
      } else {
        brains[i] = new Network(24,brains[maxIndex].hidden,4,0.001);
        for (int k = 0; k < brains[maxIndex].hidden; k++) {
          for (int j = 0; j < 25; j++) {
            brains[i].m1.actualMatrix[k][j] = brains[maxIndex].m1.actualMatrix[k][j]+random(-0.01,0.01);
          }
        }
        for (int k = 0; k < 4; k++) {
          for (int j = 0; j < brains[maxIndex].hidden+1; j++) {
            brains[i].m2.actualMatrix[k][j] = brains[maxIndex].m2.actualMatrix[k][j]+random(-0.01,0.01);
          }
        }
      }
    }
  }
  /*for (int i = 0; i < (int)(num/2); i++) {
   brains[i+(int)(num/2)] = brains[i];
   }
   for (int i = (int)(num/2); i < num; i++) {
   brains[i].mutate();
   }*/
}
