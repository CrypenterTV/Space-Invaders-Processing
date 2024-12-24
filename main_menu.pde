class MainMenu extends Menu {

    Game _game;
     
    MainMenu(Game game) {

        super();

        _game = game;

        initButtons();
    }

    void initButtons() {


        addButton(new Button(new PVector(width / 3, 3 * height / 9), width / 3, width / 9, "Nouvelle Partie", COLOR_TEXT_BUTTON, new ButtonAction() {
            void onClick(int mb) {
                resetGame();
                gameState = GAME_STATUS;
                cursor(ARROW);
                surface.setTitle(MAIN_TITLE + " : " + _game.getLevelName());
            }
        }));


        addButton(new Button(new PVector(width / 3, 5 * height / 9), width / 3, width / 9, "Charger un Niveau", COLOR_TEXT_BUTTON, new ButtonAction() {
            void onClick(int mb) {
                selectInput("Sélectionnez le niveau :", "levelSelected");
            }
        }));


        addButton(new Button(new PVector(width / 3, 7 * height / 9), width / 3, width / 9, "Quitter", COLOR_TEXT_BUTTON, new ButtonAction() {
            void onClick(int mb) {
                exit();
            }
        }));

    }

    void drawBackground() {

        background(allImages.getBackgroundImage(7));

        imageMode(CENTER);
        image(allImages.getMainTitleImage(), width / 2, 0.16 * height, 0.7 * width, height / 6);

    }

    void handleKey(char k) { }

}