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

        boolean newHover = (mouseX >= _position.x && mouseX <= _position.x + _buttonWidth) && (mouseY >= _position.y && mouseY <= _position.y + _buttonHeight);
        
        if (!_hovered && newHover) {
            cursor(HAND);
        } else if (_hovered && !newHover) {
            cursor(ARROW);
        }
        
        _hovered = newHover;
    }

    void drawIt() {

        if (_hovered) {
            fill(COLOR_BUTTON_HOVER);
        } else {
            fill(COLOR_BUTTON_BASE);
        }

        stroke(3);
        rectMode(CORNER);

        rect(_position.x, _position.y, _buttonWidth, _buttonHeight, 20);

        textAlign(CENTER, CENTER);

        textSize(30);
        
        fill(_textColor);
        text(_label, _position.x + _buttonWidth / 2, _position.y + _buttonHeight / 2);


    }

    void onClick(int mb) {

        update();
        
        if (!_hovered) {
            return;
        }

        _buttonAction.onClick(mb);
    }

    boolean isHovered() {
        return _hovered;
    }

}