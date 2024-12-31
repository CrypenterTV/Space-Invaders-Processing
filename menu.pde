abstract class Menu {

  // Chaque menu contient une liste de boutons.
  ArrayList<Button> _buttons;

  Menu() {
    _buttons = new ArrayList<Button>();
  }

  abstract void drawBackground(); // Méthode à implémenter pour dessiner le fond du menu.

  abstract void handleKey(char k); // Méthode à implémenter pour gérer les touches du clavier.

  void update() {
    for (Button button : _buttons) {
      button.update();
    }
  }

  // On dessine le background puis chaque bouton.
  void drawIt() {

    drawBackground();

    rectMode(CORNERS);

    for (Button button : _buttons) {
      button.drawIt();
    }

  }


  void addButton(Button button) {
    _buttons.add(button);
  }

  // On passe les cliques de souris du joueur à chaque bouton.
  void handleMouse(int mb) {

    for (Button button : _buttons) {

      button.onClick(mb);
    }

  }
}
