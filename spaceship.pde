class Spaceship extends GameEntity {


  Spaceship(Board board, TypeCell entityType, int cellX, int cellY) {
    super(board, entityType, cellX, cellY);
  }


  void update() {
  }


  void drawIt() {
    imageMode(CENTER);
    image(allImages.getSpaceshipImage(), getPosition().x, getPosition().y, _board.getCellSizeX(), _board.getCellSizeY());
  }


  boolean beforeMove(int newCellX, int newCellY) {

    // Si le déplacement est en dehors du plateau, on l'empêche.
    if (newCellX < 0 || newCellY < 0 || newCellX >= _board.getNbCellsX() || newCellY >= _board.getNbCellsY()) {
      return false;
    }

    // Si jamais le vaisseau se déplace sur un missile.
    if (_board.getCell(newCellX, newCellY) == TypeCell.BULLET_2) {

      Bullet bullet = _board.getGame().getBulletFromCell(newCellX, newCellY); // On récupère le missile.

      if (bullet == null)
        return true;

      // On détruit le missile.
      bullet.setExpired();
      _board.setCell(newCellX, newCellY, TypeCell.EMPTY);

      // On fait perdre une vie au joueur.
      _board.getGame().loseLife();
    }

    return true;
  }
}
