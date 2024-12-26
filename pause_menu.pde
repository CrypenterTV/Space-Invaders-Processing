class PauseMenu extends Menu {

    Game _game;

    int _menuWidth;
    int _menuHeight;
     
    PauseMenu(Game game) {

        super();

        _game = game;
        _menuWidth = width / 2;
        _menuHeight = height / 2;

        initButtons();
    }

    void initButtons() {

        addButton(new Button(new PVector((width - int(1.5 * _menuWidth / 3)) / 2, height / 4 + 3 * _menuHeight / 9), int(1.5 * _menuWidth / 3), _menuHeight / 9, "Reprendre", COLOR_TEXT_BUTTON, new ButtonAction() {
            void onClick(int mb) {

                // Reprise de la partie en cours.
                _game.resetTimers();
                gameState = GAME_STATUS;

            }
        }));

        addButton(new Button(new PVector((width - int(1.5 * _menuWidth / 3)) / 2, height / 4 + 5 * _menuHeight / 9), int(1.5 * _menuWidth / 3), _menuHeight / 9, "Sauvegarder", COLOR_TEXT_BUTTON, new ButtonAction() {
            void onClick(int mb) {
                selectOutput("Exporter la partie en cours : ", "exportLevel");
            }
        }));

        addButton(new Button(new PVector((width - int(1.5 * _menuWidth / 3)) / 2, height / 4 + 7 * _menuHeight / 9), int(1.5 * _menuWidth / 3), _menuHeight / 9, "Menu Principal", COLOR_TEXT_BUTTON, new ButtonAction() {
            void onClick(int mb) {
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
        text("PAUSE", width / 4 + _menuWidth / 2, height / 4 + 2 * _menuHeight / 9);

    }

    void handleKey(char k) {
        if (k == 27) {
            
            // On quitte le menu pause et on reprend la partie en cours.
            gameState = GAME_STATUS;

            key = 0;
        }
    }

}