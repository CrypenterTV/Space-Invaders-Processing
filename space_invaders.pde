int gameState;
int initialWidth = 690;
int initialHeight = 660;

Game game;

Menu mainMenu;
Menu pauseMenu;
Menu endgameMenu;

Images allImages;

void settings() {
  size(int(initialWidth*1.3), int(initialHeight*1.3), P2D);
}


void setup() {

  surface.setTitle(MAIN_TITLE);
  surface.setResizable(false);

  gameState = MAIN_MENU_STATUS;

  allImages = new Images("data/");

  game = new Game();

  mainMenu = new MainMenu(game);
  pauseMenu = new PauseMenu(game);
  endgameMenu = new EndGameMenu(game);
  
}

void draw() {

  switch (gameState) {

    case MAIN_MENU_STATUS:
      mainMenu.update();
      mainMenu.drawIt();
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

  }
  
}

void keyPressed() {

  if (gameState == GAME_STATUS) {

    game.handleKey(key);

  } else if (gameState == PAUSE_MENU_STATUS) {

    pauseMenu.handleKey(key);

  } else if (gameState == END_GAME_MENU_STATUS) {

    endgameMenu.handleKey(key);

  }

}

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
  }


}

void levelSelected(File selection) {

  if (selection == null) {
    return;
  }

  
  cursor(ARROW);

  game.changeBoard(new Board(game, selection.getAbsolutePath(), new PVector(0, 0)));

  game.setCustomGame(true);

  gameState = GAME_STATUS;

  surface.setTitle(MAIN_TITLE + " : " + game.getLevelName());
  
}


void exportLevel(File selection) {

  if (selection == null) {
    return;
  }

  game.getBoard().exportToFile(selection.getAbsolutePath(), selection.getName());

}

void resetGame() {
  game = new Game();
  mainMenu = new MainMenu(game);
  pauseMenu = new PauseMenu(game);
  endgameMenu = new EndGameMenu(game);
}
