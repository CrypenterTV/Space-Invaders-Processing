class Menu {

  ArrayList<Button> _buttons;

  Menu() {
    _buttons = new ArrayList<Button>();
  }
  
  void update() {
    for(Button button : _buttons) {
      button.update();
    }
  }


  void drawIt() {

    rectMode(CORNERS);

    for(Button button : _buttons) {
      button.drawIt();
    }
  }


  void addButton(Button button) {
    _buttons.add(button);
  }

  void handleMouse(int mouseButton) {

    for(Button button : _buttons) {

      button.onClick(mouseButton);

    }
  }



}
