class Matrix {
  int rows;
  int cols;
  float[][] actualMatrix;

  Matrix(int r, int c) {
    rows = r;
    cols = c;
    actualMatrix = new float[rows][cols];
  }

  float getVal(int r, int c) {
    return actualMatrix[r][c];
  }

  void changeVal(int r, int c, float val) {
    actualMatrix[r][c] = val;
  }

  int rowCount() {
    return rows;
  }

  int colCount() {
    return cols;
  }

  float[] times(float[] vect) {
    float result;
    float[] res = new float[rows];
    for (int i = 0; i < rows; i ++) {
      result = 0;
      for (int j = 0; j < cols; j++) {
        result += actualMatrix[i][j]*vect[j];
      }
      res[i] = result;
    }
    return res;
  }

  void create(float mutation) {
    for (int i = 0; i< rows; i++) {
      for (int j = 0; j< cols; j++) {
        float possibleVal = randomGaussian()*mutation;
        if (possibleVal > 1) {
          possibleVal = 1;
        } else if (possibleVal < -1) {
          possibleVal = -1;
        }
        actualMatrix[i][j] = possibleVal;
      }
    }
  }

  void mutate(float mutation) {
    for (int i = 0; i< rows; i++) {
      for (int j = 0; j< cols; j++) {
        float mutated = random(1);
        float possibleVal = actualMatrix[i][j];
        if (mutated > 0.9) {
          possibleVal +=randomGaussian()*mutation;
        }
        if (possibleVal > 1) {
          possibleVal = 1;
        } else if (possibleVal < -1) {
          possibleVal = -1;
        }
        actualMatrix[i][j] = possibleVal;
      }
    }
  }

  Matrix clone() {
    Matrix clone = new  Matrix(rows, cols);
    for (int i =0; i<rows; i++) {
      for (int j = 0; j<cols; j++) {
        clone.actualMatrix[i][j] = actualMatrix[i][j];
      }
    }
    return clone;
  }
}
