class MainMenu extends Menu {

    Game _game;
     
    MainMenu(Game game) {

        super();

        _game = game;

        initButtons();
    }

    void initButtons() {


        addButton(new Button(new PVector(width / 6, 3 * height / 9), width / 3, width / 9, "Nouvelle Partie", COLOR_TEXT_BUTTON, new ButtonAction() {
            void onClick(int mb) {
                resetGame();
                gameState = GAME_STATUS;
                cursor(ARROW);
                surface.setTitle(MAIN_TITLE + " : " + _game.getLevelName());
                allSounds.getMainMenuMusic().stop();
                loopSound(allSounds.getGameMusic());
            }
        }));


        addButton(new Button(new PVector(width / 6, 5 * height / 9), width / 3, width / 9, "Charger un Niveau", COLOR_TEXT_BUTTON, new ButtonAction() {
            void onClick(int mb) {
                resetGame();
                selectInput("Sélectionnez le niveau :", "levelSelected");
            }
        }));


        addButton(new Button(new PVector(width / 6, 7 * height / 9), width / 3, width / 9, "Quitter", COLOR_TEXT_BUTTON, new ButtonAction() {
            void onClick(int mb) {
                exit();
            }
        }));

    }

    void drawBackground() {

        background(allImages.getBackgroundImage(7));

        imageMode(CENTER);
        image(allImages.getMainTitleImage(), width / 2, 0.16 * height, 0.7 * width, height / 6);

        fill(COLOR_BUTTON_BASE);
        rectMode(CORNER);

        rect(width / 6 + width / 3 + 30, 3 * height / 9, 0.85 * width / 2, height / 2, 20);

        textSize(40);
        fill(COLOR_TEXT_BUTTON);
        textAlign(CENTER);
        text("Meilleurs Scores :", 1.12 * 4 * width / 6, 3 * height / 9 + 0.5 * height / 9);
        
        textSize(30);
        for (int i = 0; i < 5; i++) {

            if (i >= scoresList.size()) {
                break;
            }

            int index = scoresList.size() - i - 1;
            text("#" + (i + 1) + " " + usernamesList.get(index) + " : " + scoresList.get(index), 1.12 * 4 * width / 6, 3 * height / 9 + 0.5 * height / 9 + (i + 1) * 60);

        }

    }

    void handleKey(char k) { }

}