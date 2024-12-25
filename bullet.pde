class Bullet extends GameEntity {
  
  int _moveInterval;

  Bullet(Board board, TypeCell entityType, int cellX, int cellY) {

    super(board, entityType, cellX, cellY);

    _moveInterval = MOVE_INTERVAL_BULLET_SPACESHIP;

    if (_entityType == TypeCell.BULLET_2) {
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
    if (targetCell.getType() == TypeCell.Type.INVADER && _entityType == TypeCell.BULLET_1) {

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

    if (targetCell == TypeCell.OBSTACLE || targetCell.getType() == TypeCell.Type.INVADER) {
        setExpired();
        return false;
    }

    return targetCell == TypeCell.EMPTY || targetCell.getType() == TypeCell.Type.BULLET;
  } 


  void update() {

    if (millis() - _lastUpdateTime < _moveInterval) {
      return;
    }

    _lastUpdateTime = millis();

    if (_entityType == TypeCell.BULLET_1) {

      move(new PVector(0, -1));

    } else if (_entityType == TypeCell.BULLET_2) {

      move(new PVector(0, 1));

    }


  }


  void drawIt() {

    rectMode(CENTER);

    if (_entityType == TypeCell.BULLET_1) {
      fill(COLOR_BULLET_SPACESHIP);
    } else if (_entityType == TypeCell.BULLET_2) {
      fill(COLOR_BULLET_INVADER);
    }

    noStroke();
    rect(getPosition().x, getPosition().y, 0.25 * _board.getCellSizeX(), 0.7 * _board.getCellSizeY(), 20);
  }


}
