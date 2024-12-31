class Bullet extends GameEntity {

  int _moveInterval; // Temps entre chaque déplacement du missile.

  Bullet(Board board, TypeCell entityType, int cellX, int cellY) {

    super(board, entityType, cellX, cellY);

    // L'intervalle de déplacement dépend du type de missile (plus rapide pour les missiles du vaisseau).
    _moveInterval = MOVE_INTERVAL_BULLET_SPACESHIP;

    if (_entityType == TypeCell.BULLET_2) {
      _moveInterval = MOVE_INTERVAL_BULLET_INVADER;
    }

  }

  boolean beforeMove(int newCellX, int newCellY) {

    // Si le missile sort de limites du plateau, on le détruit.
    if (newCellX < 0 || newCellY < 0 || newCellX >= _board.getNbCellsX() || newCellY >= _board.getNbCellsY()) {
      setExpired();
      return false;
    }

    TypeCell targetCell = _board.getCell(newCellX, newCellY); // Cellule ciblée par le missile.

    // Lorsque le missile frappe un invader :
    if (targetCell.getType() == TypeCell.Type.INVADER && _entityType == TypeCell.BULLET_1) {

      // On détruit l'invader, et on appelle la méthode kill() pour lancer l'explosion et incrémenter le score.
      Invader invader = _board.getGame().getInvaderFromCell(newCellX, newCellY);

      assert invader != null;

      invader.kill();
      setExpired();

      return false;
    }

    // Lorsque le missile frappe le vaisseau : 
    if (targetCell == TypeCell.SPACESHIP) {
      
      // On fait perdre une vie au joueur.
      _board.getGame().loseLife();

      setExpired();
    }

    // Lorsque le missile frappe un obstacle ou un autre invader, on le retire simplement (pas d'explosion ni de score).
    if (targetCell == TypeCell.OBSTACLE || targetCell.getType() == TypeCell.Type.INVADER) {
      setExpired();
      return false;
    }

    return targetCell == TypeCell.EMPTY || targetCell.getType() == TypeCell.Type.BULLET;
  }


  void update() {

    // On ne déplace le missile que toutes les _moveInterval millisecondes.
    if (millis() - _lastUpdateTime < _moveInterval) {
      return;
    }

    _lastUpdateTime = millis();

    if (_entityType == TypeCell.BULLET_1) {
      // Si c'est un missile tiré par le vaisseau, on le déplace vers le haut.
      move(new PVector(0, -1));

    } else if (_entityType == TypeCell.BULLET_2) {
      // Si c'est un missile tiré par un invader, on le déplace vers le bas.
      move(new PVector(0, 1));
    }
  }


  void drawIt() {

    rectMode(CENTER);

    if (_entityType == TypeCell.BULLET_1) {
      
      // Jaune pour les missiles du vaisseau.
      fill(COLOR_BULLET_SPACESHIP);

    } else if (_entityType == TypeCell.BULLET_2) {

      // Rouge pour les missiles des invaders.
      fill(COLOR_BULLET_INVADER);

    }

        // On dessine le missile (rectangle à bords arrondis) -> forme ovale.
    noStroke();
    rect(getPosition().x, getPosition().y, 0.25 * _board.getCellSizeX(), 0.7 * _board.getCellSizeY(), 20);
  }
}
