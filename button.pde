// Inteface à implémenter qui trigger lorsque le bouton est cliqué.
interface ButtonAction {
  void onClick(int mb);
}

class Button {

  PVector _position;

  String _label;

  int _buttonWidth;
  int _buttonHeight;

  boolean _hovered;

  ButtonAction _buttonAction;

  color _textColor;

  Button(PVector position, int buttonWidth, int buttonHeight, String label, color textColor, ButtonAction buttonAction) {
    _position = position;
    _buttonWidth = buttonWidth;
    _buttonHeight = buttonHeight;
    _label = label;
    _hovered = false;
    _buttonAction = buttonAction;
    _textColor = textColor;
  }


  void update() {

    // On détermine si le bouton est survolé par la souris du joueur à chaque update.
    boolean newHover = (mouseX >= _position.x && mouseX <= _position.x + _buttonWidth) && (mouseY >= _position.y && mouseY <= _position.y + _buttonHeight);

    if (!_hovered && newHover) {

      // Si on passe de l'état bouton non survolé à survolé, on change le curseur de la souris.
      cursor(HAND);

    } else if (_hovered && !newHover) {
      
      // Si on passe de l'état bouton survolé à non survolé, on change le curseur de la souris.
      cursor(ARROW);

    }

    _hovered = newHover;
  }

  void drawIt() {

    // On dessine le bouton en fonction de son état survolé ou non.
    if (_hovered) {
      fill(COLOR_BUTTON_HOVER);
    } else {
      fill(COLOR_BUTTON_BASE);
    }

    // Background du bouton avec bords arrondis.
    stroke(3);
    rectMode(CORNER);
    rect(_position.x, _position.y, _buttonWidth, _buttonHeight, 20);


    // Affichage du texte du bouton au milieu.
    textAlign(CENTER, CENTER);

    textSize(30);

    fill(_textColor);
    text(_label, _position.x + _buttonWidth / 2, _position.y + _buttonHeight / 2);
  }

  void onClick(int mb) {

    // Lorsqu'un clic est détecté, on vérifie si le bouton est survolé
    update();

    if (!_hovered) {
      return;
    }

    // Si c'est le cas on trigger l'action du bouton.
    _buttonAction.onClick(mb);

  }

  boolean isHovered() {
    return _hovered;
  }
}
