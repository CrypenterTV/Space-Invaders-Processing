class Game {
  
  Board _board;
  Spaceship _spaceship;

  ArrayList<Bullet> _bulletsList;
  ArrayList<Invader> _invadersList;

  String _levelName;
  
  int _lifes;
  int _score;
  
  int _lastUpdateTime;
  int _lastShotSpaceshipTime;
  int _lastShotInvaderTime;

  boolean _invadersMovingRight;

  Game() {

    _board = new Board(this, new PVector(0, 0), 23, 22);
    _board.loadFromFile("level1");

    _bulletsList = new ArrayList<Bullet>();
    _invadersList = new ArrayList<Invader>();

    _invadersMovingRight = true;
    
    _lastShotSpaceshipTime = millis();
    _lastUpdateTime = millis();

    analyseBoard();
  }
  
  void analyseBoard() {

    for (int x = 0; x < _board.getNbCellsX(); x++) {

      for (int y = 0; y < _board.getNbCellsY(); y++) {

        if (_board.getCell(x, y) == TypeCell.SPACESHIP) {
          _spaceship = new Spaceship(_board, TypeCell.SPACESHIP, x, y);
        }

        else if (_board.getCell(x, y) == TypeCell.INVADER) {
          _invadersList.add(new Invader(_board, TypeCell.INVADER, x, y));
        }

      }

    }

  }

  void update() {
    
    
    
    // Actualisation de tous les missiles.
    for (int i = 0; i < _bulletsList.size(); i++) {
      
      Bullet loopedBullet = _bulletsList.get(i);

      loopedBullet.update();

      if (loopedBullet.isExpired()) {
        _bulletsList.remove(i);
      }

    }

    // Actualisation de tous les invaders.
    for (int i = 0; i < _invadersList.size(); i++) {
      
      Invader loopedInvader = _invadersList.get(i);

      loopedInvader.update();

      if (loopedInvader.isExpired()) {
        _invadersList.remove(i);
      }
      
    }

    updateInvaders();

  }
  
  void drawIt() {
    _board.drawIt();
    if (_spaceship != null)
      _spaceship.drawIt();
    
    for (Invader invader : _invadersList) {
      invader.drawIt();
    }

    for (Bullet bullet : _bulletsList) {
      bullet.drawIt();
    }
  }
  

  void handleKey(int k) {
    
    if (key == 'q' || (key == CODED && keyCode == LEFT)) {
      
      _spaceship.move(new PVector(-1, 0));
      
    } else if (key == 'd' || (key == CODED && keyCode == RIGHT)) {
      
      _spaceship.move(new PVector(1, 0));
      
    } else if (key == ' ' | (key == CODED && keyCode == UP)) {
      
      if(millis() - _lastShotSpaceshipTime < SHOT_INTERVAL) {
        return;
      }

      _lastShotSpaceshipTime = millis();

      _bulletsList.add(new Bullet(_board, TypeCell.BULLET, _spaceship.getCellX(), _spaceship.getCellY() - 1, TypeBullet.SPACESHIP));
    
    }
      
  }
  

  Invader getInvaderFromCell(int x, int y) {

    for (Invader invader : _invadersList) {

      if (invader.getCellX() == x && invader.getCellY() == y) {
        return invader;
      }

    }

    return null;
  }


  void updateInvaders() {

    if (millis() - _lastUpdateTime < MOVE_INTERVAL_INVADER) {
      return;
    }

    _lastUpdateTime = millis();

    if (_invadersMovingRight) {
      moveInvadersRight();
    } else {
      moveInvadersLeft();
    }
  }


  void moveInvadersRight() {

    if (!_invadersMovingRight || _invadersList.size() == 0) {
      return;
    }

    _invadersList.sort((a, b) -> b.getCellX() - a.getCellX());

    if (_invadersList.get(0).getCellX() >= _board.getNbCellsX() - 1) {
      _invadersMovingRight = false;
      moveInvadersDown();
      return;
    }

    for(Invader invader : _invadersList) {
      invader.move(new PVector(1, 0));
    }

  }


  void moveInvadersLeft() {

    if (_invadersMovingRight || _invadersList.size() == 0) {
      return;
    }

    _invadersList.sort((a, b) -> a.getCellX() - b.getCellX());

    if (_invadersList.get(0).getCellX() <= 0) {
      _invadersMovingRight = true;
      moveInvadersDown();
      return;
    }

    for(Invader invader : _invadersList) {
      invader.move(new PVector(-1, 0));
    }

  }


  void moveInvadersDown() {
    
    _invadersList.sort((a, b) -> b.getCellY() - a.getCellY());

    for(Invader invader : _invadersList) {
      invader.move(new PVector(0, 1));
    }

  }


  ArrayList<Bullet> getBulletsList() {
    return _bulletsList;
  }

  
}
