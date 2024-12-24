enum TypeBullet {
  SPACESHIP,
  INVADER;
}

class Bullet extends GameEntity {
  
  TypeBullet _typeBullet;
  int _moveInterval;

  Bullet(Board board, TypeCell entityType, int cellX, int cellY, TypeBullet typeBullet) {

    super(board, entityType, cellX, cellY);

    _typeBullet = typeBullet;

    _moveInterval = MOVE_INTERVAL_BULLET_SPACESHIP;

    if (_typeBullet == TypeBullet.INVADER) {
      _moveInterval = MOVE_INTERVAL_BULLET_INVADER;
    }

  }

  boolean beforeMove(int newCellX, int newCellY) {

    if (newCellX < 0 || newCellY < 0 || newCellX >= _board.getNbCellsX() || newCellY >= _board.getNbCellsY()) {
        setExpired();
        return false;
    }

    TypeCell targetCell = _board.getCell(newCellX, newCellY);

    // Lorsque le missile frappe un invader
    if (targetCell.getType() == TypeCell.Type.INVADER && _typeBullet == TypeBullet.SPACESHIP) {

        Invader invader = _board.getGame().getInvaderFromCell(newCellX, newCellY);

        assert invader != null;

        _board.setCell(newCellX, newCellY, TypeCell.EMPTY); 
        invader.setExpired();
        setExpired();

        _board.getGame().addScore(SCORE_KILL);

        return false;
    }

    // Lorsque le missile frappe le vaisseau
    if (targetCell == TypeCell.SPACESHIP) {
      
      _board.getGame().loseLife();
      
      setExpired();

    }

    if (targetCell == TypeCell.OBSTACLE) {
        setExpired();
        return false;
    }

    return targetCell == TypeCell.EMPTY || targetCell == TypeCell.BULLET;
  } 


  void update() {

    if (millis() - _lastUpdateTime < _moveInterval) {
      return;
    }

    _lastUpdateTime = millis();

    if (_typeBullet == TypeBullet.SPACESHIP) {

      move(new PVector(0, -1));

    } else if (_typeBullet == TypeBullet.INVADER) {

      move(new PVector(0, 1));

    }


  }


  void drawIt() {

    rectMode(CENTER);

    if (_typeBullet == TypeBullet.SPACESHIP) {
      fill(COLOR_BULLET_SPACESHIP);
    } else if (_typeBullet == TypeBullet.INVADER) {
      fill(COLOR_BULLET_INVADER);
    }

    noStroke();
    rect(getPosition().x, getPosition().y, 0.25 * _board.getCellSizeX(), 0.7 * _board.getCellSizeY(), 20);
  }


}
