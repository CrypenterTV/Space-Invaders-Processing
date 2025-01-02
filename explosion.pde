class Explosion {

  Board _board;

  PVector _position;

  int _cellX;
  int _cellY;

  int _frameRateCount;

  float _sizeFactor;

  Explosion(Board board, int cellX, int cellY, float sizeFactor) {
    _board = board;
    _cellX = cellX;
    _cellY = cellY;
    _position = board.getCellCenter(cellX, cellY);
    _frameRateCount = 0;
    _sizeFactor = sizeFactor;
  }

  void drawIt() {

    // Si l'animation est terminée, on ne dessine rien.
    if (isFinished()) {
      return;
    }

    // Calcul du nombre d'images écoulées selon la vitesse de l'animation.
    int elapsedFrames = _frameRateCount / EXPLOSION_ANIMATION_SPEED;

    // L'animation d'explosion est composée de 7 images, on sélectionne la bonne et on l'affiche avec un facteur de taille donné.
    image(allImages.getExplosionImage(elapsedFrames), _position.x, _position.y, _sizeFactor * _board.getCellSizeX(), _sizeFactor * _board.getCellSizeY());

    _frameRateCount++;


  }

  boolean isFinished() {
    return _frameRateCount / EXPLOSION_ANIMATION_SPEED >= NUMBER_EXPLOSION_FRAMES;
  }

  int getCellX() {
    return _cellX;
  }

  int getCellY() {
    return _cellY;
  }
}
