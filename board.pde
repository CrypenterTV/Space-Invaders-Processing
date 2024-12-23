public enum TypeCell {
    EMPTY,
    SPACESHIP,
    OBSTACLE,
    BULLET,
    INVADER_1(Type.INVADER),
    INVADER_2(Type.INVADER),
    INVADER_3(Type.INVADER),
    INVADER_4(Type.INVADER),
    INVADER_5(Type.INVADER),
    INVADER_6(Type.INVADER),
    INVADER_7(Type.INVADER);

    Type _type;

    TypeCell() {
        _type = null;
    }

    TypeCell(Type type) {
        _type = type;
    }

    Type getType() {
        if (_type != null) {
          return _type;
        } else {
          return Type.valueOf(this.name());
        }
    }

    int getNumber() {
      if (this.name().startsWith("INVADER_")) {
          String numberPart = this.name().substring(8); 
          return Integer.parseInt(numberPart);
      }
      return -1;
    }

    enum Type {
        EMPTY, SPACESHIP, OBSTACLE, BULLET, INVADER;
    }
}


class Board {
  
  TypeCell _cells[][];
  PVector _position;
  Game _game;
  
  int _nbCellsX;
  int _nbCellsY;
  
  float _cellSizeX;
  float _cellSizeY;
  
  Board(Game game, PVector pos, int nbX, int nbY) {

    _game = game;

    _position = pos.copy();
    
    _nbCellsX = nbX;
    _nbCellsY = nbY;
    
    _cellSizeX = (float) width / _nbCellsX;
    _cellSizeY = (float) height / _nbCellsY; 
    
    _cells = new TypeCell[_nbCellsX][_nbCellsY];

    // Initialisation du plateau de jeu vide.
    for(int x = 0; x < _nbCellsX; x++) {
      
      for(int y = 0; y < _nbCellsY; y++) {

        _cells[x][y] = TypeCell.EMPTY;

      } 

    }

  }
  


  PVector getCellCenter(int x, int y) {
    return new PVector( _position.x + x * _cellSizeX + (_cellSizeX * 0.5),
                        _position.y + y * _cellSizeY + (_cellSizeY * 0.5));
  }
  
  
  void drawIt() {
  
    rectMode(CORNER);

    for (int x = 0; x < _cells.length; x++) {

        for (int y = 0; y < _cells[x].length; y++) {

            boolean pass = false;

            switch (_cells[x][y]) {

                case OBSTACLE:
                  fill(COLOR_OBSTACLE);
                  break;
                default:
                  pass = true;
                  fill(COLOR_EMPTY);
            }

            if (pass)
              continue;
            //stroke(3);
            noStroke();
            rect(x * _cellSizeX, y * _cellSizeY, _cellSizeX, _cellSizeY);
        }
    }
  }
  
  void loadFromFile(String levelName) {
    
    try {
      
      String[] lines = loadStrings("levels/" + levelName + ".txt");
      
      if (lines.length - 1 != _nbCellsY) {
        println("Le fichier " + levelName + " ne correspond pas aux dimensions du tableau.");
        return;
      }
      

      for (int y = 0; y < _nbCellsY; y++) {

          if (lines[y + 1].length() != _nbCellsX) {
            println("La ligne " + (y - 1) + " du fichier " + levelName + " a une longueur incorrecte.");
            return;
          }


          for (int x = 0; x < _nbCellsX; x++) {
            
              char loopedChar = lines[y + 1].charAt(x);

              if (loopedChar >= '1' && loopedChar <= '7') {
                _cells[x][y] = TypeCell.valueOf("INVADER_" + loopedChar);
                continue;
              }

              switch (loopedChar) {
                  case 'X':
                      _cells[x][y] = TypeCell.OBSTACLE;
                      break;
                  case 'S':
                      _cells[x][y] = TypeCell.SPACESHIP;
                      break;
                  default:
                      _cells[x][y] = TypeCell.EMPTY;
              }

          }

      }
      
    } catch (Exception e) {
      
      println("Erreur de lecture du fichier de niveau : " + e.toString());
      
    }

  }

  void displayBoard() {

    for(int x = 0; x < _nbCellsX; x++) {

      for(int y = 0; y < _nbCellsY; y++) {

        print(_cells[x][y] + " ");

      }

      println("\n");

    }

  }


  TypeCell getCell(int x, int y) {
    return _cells[x][y];
  }


  void setCell(int x, int y, TypeCell value) {
    _cells[x][y] = value;
  }
  
  TypeCell[][] getCells() {
    return _cells;
  }
  
  int getNbCellsX() {
    return _nbCellsX;
  }
  
  int getNbCellsY() {
    return _nbCellsY;
  }
  
  float getCellSizeX() {
    return _cellSizeX;
  }
  
  float getCellSizeY() {
    return _cellSizeY;
  }

  Game getGame() {
    return _game;
  }
  
}
