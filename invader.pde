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


    //_board.getGame().getBulletsList().add(new Bullet(_board, TypeCell.BULLET, _cellX, _cellY + 1, TypeBullet.INVADER));

  }

  @Override
  void drawIt() {
    rectMode(CENTER);
    fill(COLOR_INVADER);
    stroke(3);
    rect(getPosition().x, getPosition().y, _board.getCellSizeX(), _board.getCellSizeY());
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
