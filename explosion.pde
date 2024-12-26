class Explosion {

    Board _board;

    int _cellX;
    int _cellY;

    int _frameRateCount;

    int _startFrameCount;

    float _sizeFactor;

    Explosion(Board board, int cellX, int cellY, float sizeFactor) {
        _board = board;
        _cellX = cellX;
        _cellY = cellY;
        _frameRateCount = 0;
        _startFrameCount = 0;
        _sizeFactor = sizeFactor;
    }

    void drawIt() {

        if (isFinished()) {
            return;
        }

        int elapsedFrames = _frameRateCount / EXPLOSION_ANIMATION_SPEED;
        if (elapsedFrames < NUMBER_EXPLOSION_FRAMES) {

            PVector position = _board.getCellCenter(_cellX, _cellY);
            image(allImages.getExplosionImage(elapsedFrames), position.x, position.y, _sizeFactor * _board.getCellSizeX(), _sizeFactor * _board.getCellSizeY());

            _frameRateCount++;
        }
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
