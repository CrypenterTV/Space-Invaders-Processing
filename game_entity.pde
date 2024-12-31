abstract class GameEntity {

  Board _board;
  TypeCell _entityType;

  int _cellX;
  int _cellY;

  int _lastUpdateTime;

  boolean _expired;

  GameEntity(Board board, TypeCell entityType, int cellX, int cellY) {

    _board = board;
    _entityType = entityType;

    _cellX = cellX;
    _cellY = cellY;

    _expired = false;

    _lastUpdateTime = millis();
  }

  abstract void update(); // Méthode à implémenter pour actualiser l'entité.

  abstract void drawIt(); // Méthode à implémenter pour dessiner l'entité.

  abstract boolean beforeMove(int newCellX, int newCellY); // Méthode à implémenter pour déterminer si un déplacement est possible.

  // Fonction permettant de déplacer l'entité dans une direction donnée.
  boolean move(PVector direction) {

    if (_expired)
      return false;

    int newCellX = _cellX + int(direction.x);
    int newCellY = _cellY + int(direction.y);

    boolean shouldMove = beforeMove(newCellX, newCellY); // On vérifie si le déplacement est possible en fonction de la nouvelle position calculée.

    if (!shouldMove)
      return false;

    if (newCellX < 0 || newCellY < 0 || newCellX >= _board.getNbCellsX() || newCellY >= _board.getNbCellsY()) { // Si le mouvement est en dehors du plateau de jeu, on ne le réalise pas.
      return false;
    }

    if (_board.getCell(newCellX, newCellY) != TypeCell.EMPTY && _board.getCell(newCellX, newCellY).getType() != TypeCell.Type.BULLET) { // Si la nouvelle position est occupée par une autre entité, on ne réalise pas le déplacement.
      return false;
    }

    // Mise à jour de la nouvelle position de l'entité sur le plateau de jeu.
    _board.setCell(_cellX, _cellY, TypeCell.EMPTY);
    _board.setCell(newCellX, newCellY, _entityType);

    // Actualisation de la position de l'entité.
    _cellX = newCellX;
    _cellY = newCellY;

    return true;
  }


  int getCellX() {
    return _cellX;
  }


  int getCellY() {
    return _cellY;
  }


  PVector getPosition() {
    return _board.getCellCenter(_cellX, _cellY);
  }


  int getLastUpdateTime() {
    return _lastUpdateTime;
  }

  // On définie l'entité comme n'étant plus valide et on la retire du plateau de jeu.
  void setExpired() {
    _expired = true;
    _board.setCell(_cellX, _cellY, TypeCell.EMPTY);
  }

  boolean isExpired() {
    return _expired;
  }
}
