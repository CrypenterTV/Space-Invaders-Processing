/* Valeurs "statiques" du jeu accessibles directement dans tout le projet. */

SoundFile soundFile;

int gameState;

Game game;

Menu mainMenu;
Menu pauseMenu;
Menu endgameMenu;
Menu usernameInputMenu;

Images allImages;
Sounds allSounds;

boolean soundActivated = true;

String username;

int applicationStartupTime;

ArrayList<String> usernamesList;
ArrayList<Integer> scoresList;


void setup() {

  size(1035, 990); // La taille est définie artibrairement mais on peut la changer si besoin.

  surface.setTitle(MAIN_TITLE);

  // Par défaut, le jeu démarre sur le menu principal.
  gameState = MAIN_MENU_STATUS;

  // Initialisation de l'ensemble des images et des sons du jeu.
  allImages = new Images("data/");
  allSounds = new Sounds("data/");

  loopSound(allSounds.getMainMenuMusic());

  game = new Game(); // Création d'une partie par défaut.

  // Initialisation de l'ensemble des menus du jeu.
  mainMenu = new MainMenu(game);
  pauseMenu = new PauseMenu(game);
  endgameMenu = new EndGameMenu(game);
  usernameInputMenu = new UsernameInputMenu(game);

  applicationStartupTime = millis();

  /* On vient récupérer puis trier les scores sauvegardés dans le fichier best_scores.txt dans les deux listes liées.*/
  usernamesList = new ArrayList<String>();
  scoresList = new ArrayList<Integer>();

  loadScores();
  sortScores();

}

// Fonction de dessin principale du jeu appelée à chaque frame.
void draw() {

  // On dessine tel ou tel élément en fonction de l'état du jeu.
  switch (gameState) {

  case MAIN_MENU_STATUS:

    mainMenu.update();
    mainMenu.drawIt();

    if (username == null) {

      // On attend un peu avant d'afficher le menu "pop-up" de saisie du pseudo (ce qui permet au menu principal de se charger correctement en arrière plan).
      if (millis() - applicationStartupTime > 1000) {
        gameState = USERNAME_INPUT_MENU_STATUS;
      }

    }

    break;

  case PAUSE_MENU_STATUS:
    pauseMenu.update();
    pauseMenu.drawIt();
    break;

  case GAME_STATUS:
    game.update();
    game.drawIt();
    break;

  case END_GAME_MENU_STATUS:
    endgameMenu.update();
    endgameMenu.drawIt();
    break;

  case USERNAME_INPUT_MENU_STATUS:
    usernameInputMenu.update();
    usernameInputMenu.drawIt();
    break;
  }

}

// Redirection du traitement des touches vers les menus ou le jeu en fonction de l'état du jeu.
void keyPressed() {

  switch (gameState) {

  case GAME_STATUS:
    game.handleKey(key);
    break;

  case PAUSE_MENU_STATUS:
    pauseMenu.handleKey(key);
    break;

  case END_GAME_MENU_STATUS:
    endgameMenu.handleKey(key);
    break;

  case USERNAME_INPUT_MENU_STATUS:
    usernameInputMenu.handleKey(key);
    break;
  }

}

// Redirection du traitement des clics de souris vers les menus ou le jeu en fonction de l'état du jeu.
void mousePressed() {

  switch (gameState) {

  case MAIN_MENU_STATUS:
    mainMenu.handleMouse(mouseButton);
    break;

  case PAUSE_MENU_STATUS:
    pauseMenu.handleMouse(mouseButton);
    break;

  case END_GAME_MENU_STATUS:
    endgameMenu.handleMouse(mouseButton);
    break;

  case USERNAME_INPUT_MENU_STATUS:
    usernameInputMenu.handleMouse(mouseButton);
    break;
  }
}

// Fonction appellée par processing lorsqu'un fichier de niveau est sélectionné par le joueur.
void levelSelected(File selection) {

  if (selection == null) {
    return;
  }


  cursor(ARROW);

  // On charge le nouveau niveau et on change l'état du jeu.

  game.changeBoard(new Board(game, selection.getAbsolutePath(), new PVector(0, 0)));

  game.setCustomGame(true);

  gameState = GAME_STATUS;

  surface.setTitle(MAIN_TITLE + " : " + game.getLevelName());

  stopSound(allSounds.getMainMenuMusic());
  loopSound(allSounds.getGameMusic());
}


// Fonction appellée par processing lorsqu'un fichier de destination d'export est sélectionné par le joueur.
void exportLevel(File selection) {

  if (selection == null) {
    return;
  }

  game.getBoard().exportToFile(selection.getAbsolutePath(), selection.getName());
}


// Reset complet d'une partie.
void resetGame() {
  game = new Game();
  mainMenu = new MainMenu(game);
  pauseMenu = new PauseMenu(game);
  endgameMenu = new EndGameMenu(game);
}


PApplet getInstance() {
  return this;
}

/* Fonctions de gestion du son, prise en compte du paramètre "soundActivated" */
void playSound(SoundFile soundFile) {

  if (!soundActivated) {
    return;
  }

  soundFile.play();
}


void loopSound(SoundFile soundFile) {

  if (!soundActivated) {
    return;
  }

  soundFile.loop();
}


void stopSound(SoundFile soundFile) {

  if (!soundActivated) {
    return;
  }

  soundFile.stop();
}


boolean isInteger(String string) {

  try {

    int num = Integer.parseInt(string);

    return true;
  }
  catch(NumberFormatException e) {

    return false;
  }

}

// Fonction permettant de récupérer les scores sauvegardés dans le fichier best_scores.txt.
void loadScores() {

  try {

    String[] lines = loadStrings("best_scores.txt");

    // Itération sur chaque ligne du fichier.
    for (String line : lines) {

      if (line.length() == 0) {
        continue;
      }

      // La ligne est de la forme "username;score", on récupère les deux informations.
      String[] splitedLine = line.split(";");

      // Si le format est incorrect, on passe à la ligne suivante.
      if (splitedLine.length != 2) {
        continue;
      }

      if (!isInteger(splitedLine[1])) {
        continue;
      }

      usernamesList.add(splitedLine[0]);
      scoresList.add(Integer.parseInt(splitedLine[1]));
    }

    assert usernamesList.size() == scoresList.size(); // On s'assure que les deux listes sont de même taille.
  }
  catch(Exception e) {

    println(e);

  }
}

// Tri à bulle des deux listes liées en fonction du score dans l'ordre croissant.
void sortScores() {

  int size = usernamesList.size();

  for (int i = size - 1; i >= 1; i--) {

    for (int j = 0; j < i; j++) {

      if (scoresList.get(j + 1) < scoresList.get(j)) {
        
        // Algorithme classique de tri à bulles, on permute les valeurs dans les deux listes.
        int temp1 = scoresList.get(j);
        String temp2 = usernamesList.get(j);

        scoresList.set(j, scoresList.get(j + 1));
        scoresList.set(j + 1, temp1);

        usernamesList.set(j, usernamesList.get(j + 1));
        usernamesList.set(j + 1, temp2);
      }
    }
  }
}
