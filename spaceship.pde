class Spaceship extends GameEntity {

  float _size;

  Spaceship(Board board, TypeCell entityType, int cellX, int cellY) {
    super(board, entityType, cellX, cellY);
    _size = 0.8 * min(board.getCellSizeX(), board.getCellSizeY());
  }


  void update() {

  }


  void drawIt() {
    fill(COLOR_SPACESHIP);
    noStroke();
    //ellipse(getPosition().x, getPosition().y, _size, _size);
    imageMode(CENTER);
    image(_board.getGame().getImages().getSpaceshipImage(), getPosition().x, getPosition().y, _board.getCellSizeX(), _board.getCellSizeY());
  }


  boolean beforeMove(int newCellX, int newCellY) {
    return true;
  }

}