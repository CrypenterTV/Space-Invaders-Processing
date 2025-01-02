class Game {

  Board _board;

  Spaceship _spaceship;

  ArrayList<Bullet> _bulletsList;
  ArrayList<Invader> _invadersList;
  ArrayList<Explosion> _explosionsList;

  String _levelName;

  int _lifes;
  int _score;

  int _lastUpdateTime;
  int _lastShotSpaceshipTime;
  int _lastShotInvaderTime;
  int _levelStartTime;

  boolean _customGame;

  int _levelNumber;

  int _randomNextInvaderShotInterval;

  boolean _invadersMovingRight;

  boolean _pause;

  int _moveIntervalInvader;
  int _minIntervalInvaderShot;
  int _maxIntervalInvaderShot;

  boolean _isEnding;


  Game() {

    _board = new Board(this, "levels/level1.txt", new PVector(0, 0)); // Le niveau 1 est chargé par défaut.
    _levelName = "Niveau 1";

    /* Initialisation des paramètres de départ. */

    _levelNumber = 1;
    _score = 0;
    _lifes = START_LIFES;
    _customGame = false;

    _moveIntervalInvader = MOVE_INTERVAL_INVADER;
    _minIntervalInvaderShot = MIN_INTERVAL_INVADER_SHOT;
    _maxIntervalInvaderShot = MAX_INTERVAL_INVADER_SHOT;

    _levelStartTime = millis();

    resetBoard();

    _pause = false;

    _isEnding = false;
  }

  // Fonction permettant la remise à zéro du jeu.
  void resetBoard() {

    _bulletsList = new ArrayList<Bullet>();
    _invadersList = new ArrayList<Invader>();

    _explosionsList = new ArrayList<Explosion>();

    _invadersMovingRight = true;

    _lastShotSpaceshipTime = millis();
    _lastUpdateTime = millis();
    _lastShotInvaderTime = millis();

    _randomNextInvaderShotInterval = generateRandomShotInvaderTime();

    analyseBoard();
  }

  /* Analyse du plateau de jeu (objet _board) créer en fonction du type des cases : 
        - Le vaisseau du joueur
        - Les différents invaders
        - La liste des tirs en cours. */
  void analyseBoard() {

    for (int x = 0; x < _board.getNbCellsX(); x++) { // On itère sur toutes les cases du plateau de jeu.

      for (int y = 0; y < _board.getNbCellsY(); y++) {

        TypeCell typeCell = _board.getCell(x, y);

        if (typeCell == TypeCell.SPACESHIP) {

          _spaceship = new Spaceship(_board, TypeCell.SPACESHIP, x, y); // Vaisseau du joueur détecté.

        } else if (typeCell.getType() == TypeCell.Type.INVADER) {

          _invadersList.add(new Invader(_board, typeCell, x, y, typeCell.getNumber())); // Invader détecté, on l'ajoute à la liste.

        } else if (typeCell.getType() == TypeCell.Type.BULLET) {

          _bulletsList.add(new Bullet(_board, typeCell, x, y)); // Tir détecté, on l'ajoute à la liste.

        }

      }

    }

  }

  // Fonction principale de mise à jour du jeu à chaque frame.
  void update() {

    if (_pause) // Si le jeu est en pause, on ne fait rien.
      return;

    if (millis() - _levelStartTime < LEVEL_START_DELAY) { // Si le niveau vient de commencer, on ne fait rien (pour laisser le temps au joueur de s'adapter).
      return;
    }


    // On retire de la liste des explosions terminées.
    for (int i = 0; i < _explosionsList.size(); i++) {

      Explosion explosion = _explosionsList.get(i);

      if (explosion.isFinished()) {
        _explosionsList.remove(i);
      }
    }

    // Si la partie est terminée et que toutes les animations d'explosions sont terminées, on stoppe la partie.
    if (_isEnding) {

      if (_explosionsList.size() == 0) {
        endGame();
      }

      return;
    }

    // Actualisation de tous les missiles + retrait des missiles détruits.
    for (int i = 0; i < _bulletsList.size(); i++) {

      Bullet loopedBullet = _bulletsList.get(i);

      loopedBullet.update();

      if (loopedBullet.isExpired()) {
        _bulletsList.remove(i);
      }
    }

    // Actualisation de tous les invaders + retrait des invaders détruits.
    for (int i = 0; i < _invadersList.size(); i++) {

      Invader invader = _invadersList.get(i);

      invader.update();

      if (invader.isExpired()) {
        _invadersList.remove(i);
      }
    }

  
    // Lorsque tous les invaders sont détruits.
    if (_invadersList.size() == 0) {
      if (_customGame) {

        _isEnding = true; // On ne stoppe par directement la partie pour laisser les animations d'explosions se terminer.

        return;
      } else {

        resetTimers();
        _levelStartTime = millis();

        if (_levelNumber < 5) {
          // On charge le niveau suivant.
          _levelNumber++;
        } else {
          // Si le dernier niveau est atteint, on le recommence en augmentant la difficulté (vitesse des invaders et intervalle de tir).
          _moveIntervalInvader = int(0.9 * _moveIntervalInvader);
          _maxIntervalInvaderShot = int(0.9 * _maxIntervalInvaderShot);
        }

        // On charge le nouveau niveau.
        Board nextBoard = new Board(this, "levels/level" + _levelNumber + ".txt", new PVector(0, 0));

        changeBoard(nextBoard);

        surface.setTitle(MAIN_TITLE + " : " + _levelName);
      }
    }

    updateInvaders(); // On actualise les déplacements des invaders.

    /* GESTION DES TIRS DE MISSILES DES INVADERS */
    if (millis() - _lastShotInvaderTime < _randomNextInvaderShotInterval) {
      return;
    }

    _lastShotInvaderTime = millis();
    _randomNextInvaderShotInterval = generateRandomShotInvaderTime(); // On calcule l'interval de temps qui séparera le prochain tir.

    // On récupère tous les invaders étant éligibles à tirer un missile.
    ArrayList<Invader> readyToShotInvaders = new ArrayList<Invader>();

    for (Invader invader : _invadersList) {
      if (invader.isReadyToShot()) {
        readyToShotInvaders.add(invader);
      }
    }


    if (readyToShotInvaders.size() == 0) { // Si aucun invader n'est prêt à tirer, on ne fait rien.
      return;
    }

    double probability = random(0, 1);
    int missilesToShoot;

    /* On détermine le nombre de missiles à tirer en fonction de la probabilité : 
          - 70% de chance de tirer 1 missile
          - 22% de chance tirer 2 missiles d'un coup
          - 8% de chance de tirer 3 missiles d'un coup. */
    if (probability <= 0.7) {
      missilesToShoot = 1;
    } else if (probability <= 0.92) {
      missilesToShoot = 2;
    } else {
      missilesToShoot = 3;
    }

    missilesToShoot = Math.min(missilesToShoot, readyToShotInvaders.size());

    // Parmi les invaders prêts à tirer un missile, on en sélectionne aléatoirement le bon nombre pour tirer le nombre de missiles déterminé précédemment.
    for (int i = 0; i < missilesToShoot; i++) {
      int randomIndex = (int) Math.floor(random(0, readyToShotInvaders.size()));

      Invader selectedInvader = readyToShotInvaders.get(randomIndex);
      readyToShotInvaders.remove(randomIndex);

      _bulletsList.add(new Bullet(_board, TypeCell.BULLET_2, selectedInvader.getCellX(), selectedInvader.getCellY() + 1));
    }

  }

  // Fonction principale de dessin du jeu à chaque frame (toujours appellée après la fonction update).
  void drawIt() {

    if (_pause) // Si le jeu est en pause on ne redessine pas.
      return;

    background(allImages.getBackgroundImage(6));

    _board.drawIt(); // On dessine le board

    if (_spaceship != null)
      _spaceship.drawIt(); // On dessine le vaisseau du joueur.

    for (Invader invader : _invadersList) {
      invader.drawIt(); // On dessine chaque invader valide.
    }

    for (Bullet bullet : _bulletsList) {
      bullet.drawIt(); // On dessine chaque missile valide.
    }

    for (Explosion explosion : _explosionsList) {
      explosion.drawIt(); // On dessine chaque explosion en cours.
    }

    // Affichage du score du joueur en haut à gauche de la fenêtre.
    textAlign(LEFT);

    textSize(40);

    fill(64, 196, 27);
    text("Score: " + _score, 5, 40);

    // Affichage du nombre de vies en haut à droite la fenêtre représentées par des coeurs.
    imageMode(CENTER);
    for (int i = 0; i < _lifes; i++) {
      // On dessine les coeurs de droite à gauche.
      image(allImages.getLifeImage(), width - (0.7 * _board.getCellSizeX() + _board.getCellSizeX() * i + i * 0.08 * _board.getCellSizeX()), 0.5 * _board.getCellSizeY(), _board.getCellSizeX(), _board.getCellSizeY());
    }
  }

  // Gestion des touches appuyées par le joueur et dispatching des actions à effectuer en fonction.
  void handleKey(int k) {

    if (_spaceship == null) {
      return;
    }

    if (key == 'q' || (key == CODED && keyCode == LEFT)) { // Le vaisseau se déplace à gauche.

      _spaceship.move(new PVector(-1, 0));

    } else if (key == 'd' || (key == CODED && keyCode == RIGHT)) { // Le vaisseau se déplace à droite.

      _spaceship.move(new PVector(1, 0));

    } else if (key == ' ' | (key == CODED && keyCode == UP)) { // Le vaisseau tire un missile.

      // Le vaisseau du joueur ne peut tirer un missile que toutes les demi-secondes (défini dans la config).
      if (millis() - _lastShotSpaceshipTime < SHOT_INTERVAL || millis() - _levelStartTime < LEVEL_START_DELAY) {
        return;
      }

      _lastShotSpaceshipTime = millis();

      playSound(allSounds.getBulletSound());

      // On récupère la case située au dessus du vaisseau.
      TypeCell cellUp = _board.getCell(_spaceship.getCellX(), _spaceship.getCellY() - 1);

      if (cellUp == TypeCell.OBSTACLE) { // Si la case est un obstacle, on ne tire pas.
        return;
      }

      if (cellUp.getType() == TypeCell.Type.INVADER) { // Si la case est un invader, on le détruit directement.

        Invader invader = getInvaderFromCell(_spaceship.getCellX(), _spaceship.getCellY() - 1);

        if (invader == null) {
          return;
        }

        invader.kill();
      }

      // Si le tir est valide, on créé un missile et on l'ajoute à la liste des missiles en cours.
      _bulletsList.add(new Bullet(_board, TypeCell.BULLET_1, _spaceship.getCellX(), _spaceship.getCellY() - 1));

    } else if (key == 27) { // Echap

      // On ouvre le menu de pause du jeu.
      gameState = PAUSE_MENU_STATUS;
      key = 0; // On modifie la touche manuellement pour contrecarer le comportement par défaut de processing qui quitte l'application.

    }
  }

  // Fonction permettant de récupérer un invader parmi la liste en fonction de ses coordonnées dans la grille de jeu.
  Invader getInvaderFromCell(int x, int y) {

    for (Invader invader : _invadersList) {

      if (invader.getCellX() == x && invader.getCellY() == y) {
        return invader;
      }

    }

    return null;
  }

  // Fonction permettant de récupérer un missile parmi la liste en fonction de ses coordonnées dans la grille de jeu.
  Bullet getBulletFromCell(int x, int y) {

    for (Bullet bullet : _bulletsList) {

      if (bullet.getCellX() == x && bullet.getCellY() == y) {
        return bullet;
      }

    }

    return null;
  }

  // Fonction permettant de mettre à jour les déplacements des invaders.
  void updateInvaders() {

    if (millis() - _lastUpdateTime < _moveIntervalInvader) { // Si le temps écoulé depuis le dernier déplacement des invaders est inférieur à l'intervalle de temps défini, on ne fait rien.
      return;
    }

    _lastUpdateTime = millis();

    // On déplace à gauche ou à droite les invaders en fonction de la direction actuelle.
    if (_invadersMovingRight) {
      moveInvadersRight();
    } else {
      moveInvadersLeft();
    }

  }

  // Fonction permettant de déplacer les invaders vers la droite.
  void moveInvadersRight() {

    if (!_invadersMovingRight || _invadersList.size() == 0) {
      return;
    }

    // Tri des invaders par ordre décroissant de leur position en x pour pouvoir les bouger dans le bon ordre.
    _invadersList.sort((a, b) -> b.getCellX() - a.getCellX()); 

    if (_invadersList.get(0).getCellX() >= _board.getNbCellsX() - 1) {
      // Lorsqu'on arrive au bord droite, on descend d'un niveau et on repart dans l'autre sens.
      _invadersMovingRight = false;
      moveInvadersDown();
      return;
    }

    // On déplace chaque invader.
    for (Invader invader : _invadersList) {
      invader.move(new PVector(1, 0));
    }

  }

  // Fonction permettant de déplacer les invaders vers la gauche.
  void moveInvadersLeft() {

    if (_invadersMovingRight || _invadersList.size() == 0) {
      return;
    }

    _invadersList.sort((a, b) -> a.getCellX() - b.getCellX());

    if (_invadersList.get(0).getCellX() <= 0) {
      // Lorsqu'on arrive au bord gauche, on descend d'un niveau et on repart dans l'autre sens.
      _invadersMovingRight = true;
      moveInvadersDown();
      return;
    }

    for (Invader invader : _invadersList) {
      invader.move(new PVector(-1, 0));
    }
  }

  // Fonction permettant de déplacer les invaders vers le bas.
  void moveInvadersDown() {

    if (_invadersList.size() == 0) {
      return;
    }

    _invadersList.sort((a, b) -> b.getCellY() - a.getCellY());

    for (Invader invader : _invadersList) {
      invader.move(new PVector(0, 1));
    }

    // Si un invader atteint le bord inférieur de la grille, le joueur perd la partie.
    if (_invadersList.get(0).getCellY() == _board.getNbCellsY() - 1) {

      // On fait exploser le vaisseau du joueur et on arrête la partie.
      addExplosion(new Explosion(_board, _spaceship.getCellX(), _spaceship.getCellY(), 4));
      _isEnding = true;

      playSound(allSounds.getExplosionSound());

      _spaceship.setExpired();
      _spaceship = null;
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
    return floor(random(_minIntervalInvaderShot, _maxIntervalInvaderShot + 1));
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

  // Fonction appellée lorsque le vaisseau du joueur est touché par un missile.
  void loseLife() {

    _lifes -= 1;

    if (_lifes <= 0) {
      
      // Si le joueur tombe à court de vies, on fait exploser le vaisseau et on stoppe la partie.
      addExplosion(new Explosion(_board, _spaceship.getCellX(), _spaceship.getCellY(), 4));
      _isEnding = true;
      playSound(allSounds.getExplosionSound());

      _spaceship.setExpired();
      _spaceship = null;
    }

  }

  // Fonction pour stopper totalement la partie en cours.
  void endGame() {

    _pause = true;

    // On affiche le menu de fin de partie.
    gameState = END_GAME_MENU_STATUS;

    // Sauvegarde du score du joueur dans le fichier des scores.
    String[] fileContent = new String[scoresList.size() + 1];

    // On reformate tout le fichier puisque la méthode saveStrings remplace écrase tout le contenu du fichier.
    for (int i = 0; i < scoresList.size(); i++) {

      fileContent[i] = usernamesList.get(i) + ";" + scoresList.get(i);

    }

    fileContent[scoresList.size()] = username + ";" + _score; // On ajoute à la fin le score du joueur actuel.

    saveStrings("best_scores.txt", fileContent);

    scoresList.add(_score);
    usernamesList.add(username);
    sortScores(); // On retri les scores pour les afficher dans l'ordre.
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

  int getScore() {
    return _score;
  }

  void resetLevelStartTime() {
    _levelStartTime = millis();
  }

  boolean isCustomGame() {
    return _customGame;
  }

  void setCustomGame(boolean customGame) {
    _customGame = customGame;
  }


  void setMinIntervalInvaderShot(int minIntervalInvaderShot) {
    _minIntervalInvaderShot = minIntervalInvaderShot;
  }

  void setMaxIntervalInvaderShot(int maxIntervalInvaderShot) {
    _maxIntervalInvaderShot = maxIntervalInvaderShot;
  }

  void setMoveIntervalInvader(int moveIntervalInvader) {
    _moveIntervalInvader = moveIntervalInvader;
  }

  void addExplosion(Explosion explosion) {
    _explosionsList.add(explosion);
  }
}
