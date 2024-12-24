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

  int _randomNextInvaderShotInterval;

  boolean _invadersMovingRight;

  boolean _pause;


  Game() {

    // Niveau n°1 par défaut.
    _board = new Board(this, "levels/level1.txt", new PVector(0, 0));
    _levelName = "Niveau 1";

    _score = 0;
    _lifes = START_LIFES;

    resetBoard();

    _pause = false;

  }

  void resetBoard() {
    
    _bulletsList = new ArrayList<Bullet>();
    _invadersList = new ArrayList<Invader>();

    _invadersMovingRight = true;
    
    _lastShotSpaceshipTime = millis();
    _lastUpdateTime = millis();
    _lastShotInvaderTime = millis();

    _randomNextInvaderShotInterval = generateRandomShotInvaderTime();

    analyseBoard();

  }
  
  void analyseBoard() {

    for (int x = 0; x < _board.getNbCellsX(); x++) {

      for (int y = 0; y < _board.getNbCellsY(); y++) {

        TypeCell typeCell = _board.getCell(x, y);

        if (typeCell == TypeCell.SPACESHIP) {
          _spaceship = new Spaceship(_board, TypeCell.SPACESHIP, x, y);
        }

        else if (typeCell.getType() == TypeCell.Type.INVADER) {
          _invadersList.add(new Invader(_board, typeCell, x, y, typeCell.getNumber()));
        }

        else if (typeCell.getType() == TypeCell.Type.BULLET) {
          _bulletsList.add(new Bullet(_board, typeCell, x, y));
        }

      }

    }

  }

  void update() {
    
    if (_pause)
      return;
    
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
      
      Invader invader = _invadersList.get(i);

      invader.update();

      if (invader.isExpired()) {
        _invadersList.remove(i);
      }
      
    }

    updateInvaders();

    // Gestion des tirs des invaders.
    if (millis() - _lastShotInvaderTime < _randomNextInvaderShotInterval) {
      return;
    }

    _lastShotInvaderTime = millis();
    _randomNextInvaderShotInterval = generateRandomShotInvaderTime();

    ArrayList<Invader> readyToShotInvaders = new ArrayList<Invader>();

    for (Invader invader : _invadersList) {
      if (invader.isReadyToShot()) {
        readyToShotInvaders.add(invader);
      }
    }

    if (readyToShotInvaders.size() == 0) {
      return;
    }

    int randomIndex = floor(random(0, readyToShotInvaders.size()));

    Invader selectedInvader = readyToShotInvaders.get(randomIndex);

    _bulletsList.add(new Bullet(_board, TypeCell.BULLET_2, selectedInvader.getCellX(), selectedInvader.getCellY() + 1));


  }
  
  void drawIt() {

    if (_pause)
      return;

    background(allImages.getBackgroundImage(6));

    _board.drawIt();


    if (_spaceship != null)
      _spaceship.drawIt();
    
    for (Invader invader : _invadersList) {
      invader.drawIt();
    }

    for (Bullet bullet : _bulletsList) {
      bullet.drawIt();
    }

    textAlign(LEFT);

    textSize(40);

    fill(64, 196, 27);
    text("Score: " + _score, 5, 40);
    
    // Affichage des coeurs.
    imageMode(CENTER);
    for(int i = 0; i < _lifes; i++) {
      image(allImages.getLifeImage(), width - (0.7 * _board.getCellSizeX() + _board.getCellSizeX() * i + i * 0.08 * _board.getCellSizeX()), 0.5 * _board.getCellSizeY(), _board.getCellSizeX(), _board.getCellSizeY());
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

      _bulletsList.add(new Bullet(_board, TypeCell.BULLET_1, _spaceship.getCellX(), _spaceship.getCellY() - 1));
    
    } else if (key == 27) { // Echap
      gameState = PAUSE_MENU_STATUS;
      key = 0;
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


  Bullet getBulletFromCell(int x, int y) {

    for (Bullet bullet : _bulletsList) {
      
      if (bullet.getCellX() == x && bullet.getCellY() == y) {
        return bullet;
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


  String getLevelName() {
    return _levelName;
  }

  void setLevelName(String levelName) {
    _levelName = levelName;
  }


  ArrayList<Bullet> getBulletsList() {
    return _bulletsList;
  }

  
  int generateRandomShotInvaderTime() {
    return floor(random(MIN_INTERVAL_INVADER_SHOT, MAX_INTERVAL_INVADER_SHOT + 1));
  }


  Spaceship getSpaceship() {
    return _spaceship;
  }


  void addScore(int value) {
    _score += value;
  }

  void changeBoard(Board board) {
    _board = board;
    resetBoard();
  }


  void loseLife() {
    
    _lifes -= 1;

    if (_lifes <= 0) {
      
      update();
      drawIt();
      _pause = true;

    }

  }


  void resetTimers() {
      _lastUpdateTime = millis();
      _lastShotSpaceshipTime = millis();
      _lastShotInvaderTime = millis();
  }

  void setPause(boolean pause) {
    _pause = pause;
  }

  boolean isInPause() {
    return _pause;
  }

  Board getBoard() {
    return _board;
  }



}
