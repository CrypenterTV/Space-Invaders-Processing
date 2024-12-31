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

  // Récupération du numéro de l'invader (si c'est un invader).
  int getNumber() {

    if (this.name().startsWith("INVADER_")) {

      String numberPart = this.name().substring(8);
      return Integer.parseInt(numberPart);

    }

    return -1;
  }

  // "Sous-Enum" pour les types de cellules associés.
  enum Type {
    EMPTY, SPACESHIP, OBSTACLE, BULLET, INVADER;
  }

}

// Classe de gestion du plateau de jeu.
class Board {

  TypeCell _cells[][]; // Tableau principal contenu le type de chaque cellule en temps réel.

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

    loadFromFile(); // Chargement du fichier de niveau.

    // Calcul des dimensions des cellules en fonction de la taille de la fenêtre (dynamique et adaptatif).
    _cellSizeX = (float) width / _nbCellsX; 
    _cellSizeY = (float) height / _nbCellsY;
  }


  // Fonction permettant de charger un fichier de niveau.
  void loadFromFile() {

    try {

      String[] lines = loadStrings(_fileName);

      // On ne prend pas en compte les lignes vides dans la taille du niveau.
      int initialLength = lines.length - 1;
      for (String line : lines) {

        if (line.length() == 0) {
          initialLength--;
        }

      }

      assert lines.length > 1;

      _game.setLevelName(lines[0]); // La première ligne contient l'intitulé du niveau.

      _nbCellsY = initialLength;
      _nbCellsX = lines[1].length();

      _cells = new TypeCell[_nbCellsX][_nbCellsY]; // On initialise notre tableau principal avec les bonnes dimensions.


      for (int y = 0; y < _nbCellsY; y++) {

        if (lines[y + 1].length() != _nbCellsX) { // Si la longueur de la ligne est différente de la largeur du plateau, on arrête le chargement.
          println("La ligne " + (y - 1) + " du fichier " + _fileName + " a une longueur incorrecte.");
          return;
        }


        for (int x = 0; x < _nbCellsX; x++) {

          // On analyse chaque caractère de la ligne pour déterminer le type de cellule.
          char loopedChar = lines[y + 1].charAt(x);

          // Les différents types d'invaders sont représentés par des chiffres de 1 à 7.
          if (loopedChar >= '1' && loopedChar <= '7') {
            _cells[x][y] = TypeCell.valueOf("INVADER_" + loopedChar);
            continue;
          }

          // Autres types de cellules.
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

    }
    catch (Exception e) {
      // Si le chargement échoue, on arrête le programme.
      println("Erreur de lecture du fichier." + e.toString());
      exit();
    }
  }


  // Récupération des coordonnées du centre d'une cellule de la grille prenant en compte la taille des cellules.
  PVector getCellCenter(int x, int y) {
    return new PVector( _position.x + x * _cellSizeX + (_cellSizeX * 0.5),
      _position.y + y * _cellSizeY + (_cellSizeY * 0.5));
  }


  void drawIt() {

    rectMode(CORNER);

    for (int x = 0; x < _cells.length; x++) {

      for (int y = 0; y < _cells[x].length; y++) {

        if (_cells[x][y] == TypeCell.OBSTACLE) { // On dessine l'obstacle.
          imageMode(CORNER);
          image(allImages.getObstacleImage(), x * _cellSizeX, y * _cellSizeY, _cellSizeX, _cellSizeY);
        }
      }

    }

  }

  // Fonction permettant de sauvegarder l'état du board dans un fichier sous le bon format.
  void exportToFile(String filePath, String gameName) {

    StringBuilder output = new StringBuilder(); // On crée un StringBuilder pour construire le contenu du fichier.

    output.append(gameName); // Première ligne = nom du niveau.
    output.append("\n");

    // On parcourt chaque cellule du plateau pour les ajouter au fichier (procédé invere du chargement).
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

    String[] outputLines = { output.toString() }; // Processing oblige à passer un tableau de String pour la fonction saveStrings.

    saveStrings(filePath, outputLines);
  }


  // Fonction de déboogage permettant d'afficher le contenu du plateau dans la console.
  void displayBoard() {

    for (int x = 0; x < _nbCellsX; x++) {

      for (int y = 0; y < _nbCellsY; y++) {

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
