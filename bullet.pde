enum TypeBullet {
  SPACESHIP,
  INVADER;
}

class Bullet extends GameEntity {
  
  TypeBullet _typeBullet;

  Bullet(Board board, TypeCell entityType, int cellX, int cellY, TypeBullet typeBullet) {

    super(board, entityType, cellX, cellY);

    _typeBullet = typeBullet;

  }

  @Override
  boolean beforeMove(int newCellX, int newCellY) {

    if (newCellX < 0 || newCellY < 0 || newCellX >= _board.getNbCellsX() || newCellY >= _board.getNbCellsY()) {
        setExpired();
        return false;
    }

    TypeCell targetCell = _board.getCell(newCellX, newCellY);

    // Lorsque le missile frappe un invader
    if (targetCell == TypeCell.INVADER && _typeBullet == TypeBullet.SPACESHIP) {

        Invader invader = _board.getGame().getInvaderFromCell(newCellX, newCellY);

        assert invader != null;

        _board.setCell(newCellX, newCellY, TypeCell.EMPTY); 
        invader.setExpired();
        setExpired();
        return false;
    }

    if (targetCell == TypeCell.OBSTACLE) {
        setExpired();
        return false;
    }

    return targetCell == TypeCell.EMPTY || targetCell == TypeCell.BULLET;
  } 

  @Override
  void update() {

    if (millis() - _lastUpdateTime < MOVE_INTERVAL_BULLET) {
      return;
    }

    _lastUpdateTime = millis();

    if (_typeBullet == TypeBullet.SPACESHIP) {

      move(new PVector(0, -1));

    } else if (_typeBullet == TypeBullet.INVADER) {

      move(new PVector(0, 1));

    }


  }

  @Override
  void drawIt() {
    rectMode(CENTER);
    fill(COLOR_BULLET);
    noStroke();
    rect(getPosition().x, getPosition().y, 0.25 * _board.getCellSizeX(), 0.7 * _board.getCellSizeY());
  }


}
