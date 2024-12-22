Game game;

int initialWidth = 690;
int initialHeight = 660;

void settings() {
  size(int(initialWidth*1.3), int(initialHeight*1.3), P2D);
}


void setup() {
  game = new Game();
}

void draw() {
  game.update();
  game.drawIt();
}

void keyPressed() {
  game.handleKey(key);
}

void mousePressed() {
}
