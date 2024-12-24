int gameState;
int initialWidth = 690;
int initialHeight = 660;

Game game;

Menu mainMenu;
Menu pauseMenu;

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
  }
  
}

void keyPressed() {

  if (gameState == GAME_STATUS) {
    game.handleKey(key);
  } else if (gameState == PAUSE_MENU_STATUS) {
    pauseMenu.handleKey(key);
  }

}

void mousePressed() {

  if (gameState == MAIN_MENU_STATUS) {
    mainMenu.handleMouse(mouseButton);
  } else if (gameState == PAUSE_MENU_STATUS) {
    pauseMenu.handleMouse(mouseButton);
  }

}

void levelSelected(File selection) {

  if (selection == null) {
    return;
  }

  gameState = GAME_STATUS;
  cursor(ARROW);

  game.changeBoard(new Board(game, selection.getAbsolutePath(), new PVector(0, 0)));

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
}
