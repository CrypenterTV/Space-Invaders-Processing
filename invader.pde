class Invader extends GameEntity {
  
  boolean _expired;

  Invader(Board board, TypeCell entityType, int cellX, int cellY) {

    super(board, entityType, cellX, cellY);

  }


  @Override
  boolean beforeMove(int newCellX, int newCellY) {
    return true;
  }

  @Override
  void update() {

  }

  @Override
  void drawIt() {
    /*rectMode(CENTER);
    fill(COLOR_INVADER);
    stroke(3);
    rect(getPosition().x, getPosition().y, _board.getCellSizeX(), _board.getCellSizeY());*/
    imageMode(CENTER);
    image(_board.getGame().getInvaderImage(), getPosition().x, getPosition().y, _board.getCellSizeX() * 0.85, _board.getCellSizeY() * 0.85);
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

    return true;
  }

}
