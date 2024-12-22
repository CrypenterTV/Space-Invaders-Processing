abstract class GameEntity {

    Board _board;
    TypeCell _entityType;

    int _cellX;
    int _cellY;

    int _lastUpdateTime;

    boolean _expired;

    GameEntity(Board board, TypeCell entityType, int cellX, int cellY) {

        _board = board;
        _entityType = entityType;

        _cellX = cellX;
        _cellY = cellY;

        _expired = false;

        _lastUpdateTime = millis();
    }

    abstract void update();

    abstract void drawIt();

    abstract boolean beforeMove(int newCellX, int newCellY);

    boolean move(PVector direction) {

        if (_expired)
            return false;

        int newCellX = _cellX + int(direction.x);
        int newCellY = _cellY + int(direction.y);

        boolean shouldMove = beforeMove(newCellX, newCellY);

        if(!shouldMove)
            return false;

        if (newCellX < 0 || newCellY < 0 || newCellX >= _board.getNbCellsX() || newCellY >= _board.getNbCellsY()) {
            return false;
        }

        if (_board.getCell(newCellX, newCellY) != TypeCell.EMPTY && _board.getCell(newCellX, newCellY) != TypeCell.BULLET) {
            return false;
        }

        _board.setCell(_cellX, _cellY, TypeCell.EMPTY);
        _board.setCell(newCellX, newCellY, _entityType);

        _cellX = newCellX;
        _cellY = newCellY;

        return true;
    }


    int getCellX() {
        return _cellX;
    }


    int getCellY() {
        return _cellY;
    }


    PVector getPosition() {
        return _board.getCellCenter(_cellX, _cellY);
    }


    int getLastUpdateTime() {
        return _lastUpdateTime;
    }


    void setExpired() {
        _expired = true;
        _board.setCell(_cellX, _cellY, TypeCell.EMPTY);
    }

    boolean isExpired() {
        return _expired;
    }


}