// Test

Game game;

int gameState;

int initialWidth = 690;
int initialHeight = 660;

Menu mainMenu;

void settings() {
  size(int(initialWidth*1.3), int(initialHeight*1.3), P2D);
}


void setup() {

  surface.setTitle(MAIN_TITLE);
  surface.setResizable(false);

  gameState = MAIN_MENU_STATUS;
  game = new Game();

  mainMenu = new Menu();
  
  mainMenu.addButton(new Button(new PVector(width / 3, height / 9), width / 3, width / 9, "Nouvelle Partie", new ButtonAction() {
    void onClick(int mousePressed) {
      gameState = GAME_STATUS;
      cursor(ARROW);
      surface.setTitle(MAIN_TITLE + " : " + game.getLevelName());
    }
  }));

  mainMenu.addButton(new Button(new PVector(width / 3, 3 * height / 9), width / 3, width / 9, "Charger Partie", new ButtonAction() {
    void onClick(int mousePressed) {
      selectInput("Sélectionnez le niveau :", "levelSelected");
    }
  }));

  mainMenu.addButton(new Button(new PVector(width / 3, 5 * height / 9), width / 3, width / 9, "Meilleurs Scores", new ButtonAction() {
    void onClick(int mousePressed) {
      println("Bouton 3");
    }
  }));

  mainMenu.addButton(new Button(new PVector(width / 3, 7 * height / 9), width / 3, width / 9, "Quitter", new ButtonAction() {
    void onClick(int mousePressed) {
      exit();
    }
  }));
}

void draw() {

  if (gameState == MAIN_MENU_STATUS) {
    
    background(game.getImages().getBackgroundImage(7));

    mainMenu.update();
    mainMenu.drawIt();

  } else if (gameState == GAME_STATUS) {

    game.update();
    game.drawIt();

  }
  
}

void keyPressed() {

  if (gameState == GAME_STATUS) {
    game.handleKey(key);
  }

}

void mousePressed() {

  if (gameState == MAIN_MENU_STATUS) {
    mainMenu.handleMouse(mouseButton);
  }

}

void levelSelected(File selection) {

  if (selection == null) {
    return;
  }

  gameState = GAME_STATUS;
  cursor(ARROW);

  game.changeBoard(new Board(game, selection.getAbsolutePath(), new PVector(0, 0)));
  game.setLevelName(selection.getAbsolutePath());

  surface.setTitle(MAIN_TITLE + " : " + game.getLevelName());
  

}
