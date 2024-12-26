class Spaceship extends GameEntity {

  float _size;

  Spaceship(Board board, TypeCell entityType, int cellX, int cellY) {
    super(board, entityType, cellX, cellY);
    _size = 0.8 * min(board.getCellSizeX(), board.getCellSizeY());
  }


  void update() { }


  void drawIt() {
    imageMode(CENTER);
    image(allImages.getSpaceshipImage(), getPosition().x, getPosition().y, _board.getCellSizeX(), _board.getCellSizeY());
  }


  boolean beforeMove(int newCellX, int newCellY) {

    if (newCellX < 0 || newCellY < 0 || newCellX >= _board.getNbCellsX() || newCellY >= _board.getNbCellsY()) {
      return false;
    }
    
    if (_board.getCell(newCellX, newCellY) == TypeCell.BULLET_2) {

      Bullet bullet = _board.getGame().getBulletFromCell(newCellX, newCellY);

      if (bullet == null)
        return true;
      
      bullet.setExpired();
      _board.setCell(newCellX, newCellY, TypeCell.EMPTY);

      _board.getGame().loseLife();

    } 

    return true;
  }

}