class EndGameMenu extends Menu {

    Game _game;

    int _menuWidth;
    int _menuHeight;
     
    EndGameMenu(Game game) {

        super();

        _game = game;
        _menuWidth = width / 2;
        _menuHeight = height / 2;

        initButtons();
    }

    void initButtons() {


        addButton(new Button(new PVector((width - int(1.5 * _menuWidth / 3)) / 2, height / 4 + 5 * _menuHeight / 9), int(1.5 * _menuWidth / 3), _menuHeight / 9, "Nouvelle Partie", COLOR_TEXT_BUTTON, new ButtonAction() {
            void onClick(int mb) {
                resetGame();
                gameState = GAME_STATUS;
                stopSound(allSounds.getGameMusic());
                loopSound(allSounds.getGameMusic());
            }
        }));

        addButton(new Button(new PVector((width - int(1.5 * _menuWidth / 3)) / 2, height / 4 + 7 * _menuHeight / 9), int(1.5 * _menuWidth / 3), _menuHeight / 9, "Menu Principal", COLOR_TEXT_BUTTON, new ButtonAction() {
            void onClick(int mb) {
                //resetGame();
                gameState = MAIN_MENU_STATUS;
                surface.setTitle(MAIN_TITLE);
                stopSound(allSounds.getGameMusic());
                loopSound(allSounds.getMainMenuMusic());
            }
        }));

    }

    void drawBackground() {

        rectMode(CENTER);

        fill(COLOR_PAUSE_MENU_BG, 50);
        noStroke();
        rect(_menuWidth, _menuHeight, _menuWidth, _menuHeight);

        fill(255);
        textAlign(CENTER);
        textSize(40);
        text("PARTIE TERMINÉE", width / 4 + _menuWidth / 2, height / 4 + 2 * _menuHeight / 9);
        
        fill(COLOR_TEXT_BUTTON);
        text("Score Final : " + _game.getScore(), width / 4 + _menuWidth / 2, height / 4 + 4 * _menuHeight / 9);

    }

    void handleKey(char k) {
        if (k == 27) {
            
            // On revient au menu principal.
            gameState = MAIN_MENU_STATUS;
            loopSound(allSounds.getMainMenuMusic());
            stopSound(allSounds.getGameMusic());
            key = 0;
        }
    }

}
