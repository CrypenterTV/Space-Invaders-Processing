public enum TypeCell {
    EMPTY,
    SPACESHIP,
    OBSTACLE,
    BULLET_1(Type.BULLET),
    BULLET_2(Type.BULLET),
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

  String _fileName;
  
  Board(Game game, String fileName, PVector pos) {

    _game = game;

    _fileName = fileName;

    _position = pos.copy();

    loadFromFile();
    
    _cellSizeX = (float) width / _nbCellsX;
    _cellSizeY = (float) height / _nbCellsY; 

  }



  void loadFromFile() {
    
    try {
      
      String[] lines = loadStrings(_fileName);

      // Ne pas prendre en compte les lignes vides 
      int initialLength = lines.length - 1;
      for (String line : lines) {
        if (line.length() == 0) {
          initialLength--;
        }
      }

      assert lines.length > 1;

      _game.setLevelName(lines[0]);

      _nbCellsY = initialLength;
      _nbCellsX = lines[1].length();

      _cells = new TypeCell[_nbCellsX][_nbCellsY];
      
      if (lines.length - 1 != _nbCellsY) {
        println("Le fichier " + _fileName + " ne correspond pas aux dimensions du tableau.");
        return;
      }
      

      for (int y = 0; y < _nbCellsY; y++) {

          if (lines[y + 1].length() != _nbCellsX) {
            println("La ligne " + (y - 1) + " du fichier " + _fileName + " a une longueur incorrecte.");
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
                  case 'B':
                    _cells[x][y] = TypeCell.BULLET_1;
                    break;
                  case 'D':
                    _cells[x][y] = TypeCell.BULLET_2;
                    break;
                  default:
                    _cells[x][y] = TypeCell.EMPTY;
              }

          }


      }
      
    } catch (Exception e) {
    
      println("Erreur de lecture du fichier." + e.toString());
      exit();

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

            if (_cells[x][y] == TypeCell.OBSTACLE) {
              imageMode(CORNER);
              image(allImages.getObstacleImage(), x * _cellSizeX, y * _cellSizeY, _cellSizeX, _cellSizeY);
            }

        }
    }
  }
  

  void exportToFile(String filePath, String gameName) {

    StringBuilder output = new StringBuilder();

    output.append(gameName);
    output.append("\n");

    for (int y = 0; y < _nbCellsY; y++) {
      
      StringBuilder line = new StringBuilder();

      for (int x = 0; x < _nbCellsX; x++) {
        
        TypeCell currentCell = _cells[x][y];

        if (currentCell.getType().equals(TypeCell.Type.INVADER)) {

          line.append(String.valueOf(currentCell.getNumber()));

        } else if (currentCell.equals(TypeCell.OBSTACLE)) {

          line.append("X");

        } else if (currentCell.equals(TypeCell.SPACESHIP)) {

          line.append("S");

        } else if (currentCell.equals(TypeCell.BULLET_1)) {

          line.append("B");

        } else if (currentCell.equals(TypeCell.BULLET_2)) {

          line.append("D");

        } else {

          line.append("E");

        }

      }

      if (y < _nbCellsY - 1) {
        line.append("\n");
      }

      output.append(line);
    }

    println(output.toString());

    String[] outputLines = { output.toString() };

    saveStrings(filePath, outputLines);
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
