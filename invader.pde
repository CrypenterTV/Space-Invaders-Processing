class Invader extends GameEntity {

  boolean _expired;
  int _invaderType;

  Invader(Board board, TypeCell entityType, int cellX, int cellY, int invaderType) {

  super(board, entityType, cellX, cellY);
    _invaderType = invaderType;
  }

  
  boolean beforeMove(int newCellX, int newCellY) {
    return true; // Le mouvement des invaders n'est pas individuel et est géré par la classe game.
  }


  void update() {
  }


  void drawIt() {

    imageMode(CENTER);

    PImage image = allImages.getInvaderImage(_invaderType);

    if (image == null) {
      return;
    }

    image(image, getPosition().x, getPosition().y, _board.getCellSizeX() * 0.85, _board.getCellSizeY() * 0.85); // L'image ne prend que 85 % de la case pour laisser un peu de marge.
  }


  boolean isExpired() {
    return _expired;
  }


  void setExpired() {
    _expired = true;
    _board.setCell(_cellX, _cellY, TypeCell.EMPTY);
  }

  // Lorsque l'invader est tué.
  void kill() {

    setExpired(); // On le marque comme expiré.

    _board.getGame().addScore(SCORE_KILL); // On incrémente le score correspondant.

    _board.getGame().addExplosion(new Explosion(_board, _cellX, _cellY, 1.4)); // On crée une explosion.

    playSound(allSounds.getExplosionSound()); // On joue le son associé à la destruction d'un invader.

  }

  // Fonction permettant de déterminer si l'invader est prêt à tirer.
  boolean isReadyToShot() {

    // Si l'invader est au dernier niveau de la grille, il ne peut pas tirer.
    if (_cellY + 1 >= _board.getNbCellsY()) {
      return false;
    }

    // On récupère la cellule du dessous.
    TypeCell underCell = _board.getCell(_cellX, _cellY + 1);

    // Si la cellule du dessous n'est pas vide ou n'est pas un vaisseau, l'invader ne peut pas tirer.
    if (underCell != TypeCell.EMPTY && underCell != TypeCell.SPACESHIP) {
      return false;
    }
    
    // Si un autre invader se situe sur une des cases en dessous, l'invader ne peut pas tirer (puisque le mouvement de tous les invaders est synchronisé).
    for (int y = _cellY + 1; y < _board.getNbCellsY(); y++) {

      if (_board.getCell(_cellX, y).getType() == TypeCell.Type.INVADER) {
        return false;
      }

    }

    return true;
  }
}
