abstract class Menu {

  ArrayList<Button> _buttons;

  Menu() {
    _buttons = new ArrayList<Button>();
  }

  abstract void drawBackground();

  abstract void handleKey(char k);
  
  void update() {
    for(Button button : _buttons) {
      button.update();
    }
  }


  void drawIt() {

    drawBackground();

    rectMode(CORNERS);

    for(Button button : _buttons) {
      button.drawIt();
    }

  }


  void addButton(Button button) {
    _buttons.add(button);
  }

  void handleMouse(int mb) {

    for(Button button : _buttons) {

      button.onClick(mb);

    }
  }




}
