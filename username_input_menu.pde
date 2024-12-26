class UsernameInputMenu extends Menu {

    Game _game;

    int _menuWidth;
    int _menuHeight;

    StringBuilder _currentString;
     
    UsernameInputMenu(Game game) {

        super();

        _game = game;
        _menuWidth = width / 2;
        _menuHeight = height / 2;

        _currentString = new StringBuilder();

        initButtons();
    }

    void initButtons() {

        addButton(new Button(new PVector((width - int(1.5 * _menuWidth / 3)) / 2, height / 4 + 4 * _menuHeight / 9), int(1.5 * _menuWidth / 3), _menuHeight / 9, "Valider", COLOR_TEXT_BUTTON, new ButtonAction() {
            void onClick(int mb) {
                validateInput();
            }
        }));


    }

    void drawBackground() {

        rectMode(CORNER);

        fill(COLOR_PAUSE_MENU_BG, 50);
        noStroke();
        rect(width / 4, height / 4, width / 2,  0.8 * height / 2);
        fill(255);

        rectMode(CENTER);

        rect(_menuWidth, height / 4 + 3 * _menuHeight / 9, 0.8 * _menuWidth, _menuHeight / 9);

        textAlign(CENTER, CENTER);
        fill(0);
        text(_currentString.toString(), width / 2, height / 4 + 3 * _menuHeight / 9);

        textSize(40);
        fill(255);
        text("Entrez votre Pseudo : ", width / 4 + _menuWidth / 2, height / 4 + 2 * _menuHeight / 9);

    }

    void validateInput() {

        if (_currentString.length() == 0) {
            return;
        }
        
        username = _currentString.toString();
        gameState = MAIN_MENU_STATUS;
    }

    void handleKey(char k) {


        if (key == 27) { // Touche Echap
            key = 0;
        }

        if (keyCode == 8) { // Touche effacer
            
            if (_currentString.length() > 0) {
                _currentString.setLength(_currentString.length() - 1);
            }

            return;

        } else if (keyCode == 10) { // Touche Entrée
            
            validateInput();

        }

        if (key == CODED) {
            return;
        }
        
        if (_currentString.length() >= 25) {
            return;
        }
        
        _currentString.append(key);
    }

}