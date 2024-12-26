class Invader extends GameEntity {
  
  boolean _expired;
  int _invaderType;

  Invader(Board board, TypeCell entityType, int cellX, int cellY, int invaderType) {

    super(board, entityType, cellX, cellY);
    _invaderType = invaderType;
  }



  boolean beforeMove(int newCellX, int newCellY) {
    return true;
  }


  void update() {

  }


  void drawIt() {
    imageMode(CENTER);

    PImage image = allImages.getInvaderImage(_invaderType);
    
    if (image == null) {
      return;
    }

    image(image, getPosition().x, getPosition().y, _board.getCellSizeX() * 0.85, _board.getCellSizeY() * 0.85);
  }

  boolean isExpired() {
    return _expired;
  }

  void setExpired() {
    _expired = true;
    _board.setCell(_cellX, _cellY, TypeCell.EMPTY);
  }


  boolean isReadyToShot() {

    if (_cellY + 1 >= _board.getNbCellsY()) {
      return false;
    }

    TypeCell underCell = _board.getCell(_cellX, _cellY + 1);

    if (underCell != TypeCell.EMPTY && underCell != TypeCell.SPACESHIP) {
      return false;
    }

    for (int y = _cellY + 1; y < _board.getNbCellsY(); y++) {

      if (_board.getCell(_cellX, y).getType() == TypeCell.Type.INVADER) {
        return false;
      }
    }

    return true;
  }

}
