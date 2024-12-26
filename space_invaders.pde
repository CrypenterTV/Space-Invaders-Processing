SoundFile soundFile;

int gameState;
int initialWidth = 690;
int initialHeight = 660;

Game game;

Menu mainMenu;
Menu pauseMenu;
Menu endgameMenu;
Menu usernameInputMenu;

Images allImages;
Sounds allSounds;

boolean soundActivated = false;

String username;

int applicationStartupTime;

ArrayList<String> usernamesList;
ArrayList<Integer> scoresList;

void settings() {
  size(int(initialWidth*1.3), int(initialHeight*1.3), P2D);
}


void setup() {

  surface.setTitle(MAIN_TITLE);

  gameState = MAIN_MENU_STATUS;

  allImages = new Images("data/");
  allSounds = new Sounds("data/");

  loopSound(allSounds.getMainMenuMusic());

  game = new Game();

  mainMenu = new MainMenu(game);
  pauseMenu = new PauseMenu(game);
  endgameMenu = new EndGameMenu(game);
  usernameInputMenu = new UsernameInputMenu(game);
  
  applicationStartupTime = millis();

  usernamesList = new ArrayList<String>();
  scoresList = new ArrayList<Integer>();

  loadScores();
  sortScores();

  for (int i = 0; i < usernamesList.size(); i++) {
    println(" - " + usernamesList.get(i) + " : " + scoresList.get(i));
  }
}

void draw() {

  switch (gameState) {

    case MAIN_MENU_STATUS:

      mainMenu.update();
      mainMenu.drawIt();

      if (username == null) {
        
        if (millis() - applicationStartupTime > 500) {
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


PApplet getInstance() {
  return this;
}


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

  } catch(NumberFormatException e) {
    
    return false;
  
  }

}

void loadScores() {

  try {

    String[] lines = loadStrings("best_scores.txt");

    for(String line : lines) {

      if (line.length() == 0) {
        continue;
      }

      String[] splitedLine = line.split(";");

      if (splitedLine.length != 2) {
        continue;
      }

      if (!isInteger(splitedLine[1])) {
        continue;
      }

      usernamesList.add(splitedLine[0]);
      scoresList.add(Integer.parseInt(splitedLine[1]));

    }

    assert usernamesList.size() == scoresList.size();

  } catch(Exception e) {

    println(e);

  }
}


void sortScores() {

  int size = usernamesList.size();


  for (int i = size - 1; i >= 1; i--) {
    
    for (int j = 0; j < i; j++) {
      
      if (scoresList.get(j + 1) < scoresList.get(j)) {

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