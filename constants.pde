// Différents statuts du jeu
final int MAIN_MENU_STATUS = 0;
final int PAUSE_MENU_STATUS = 1;
final int GAME_STATUS = 2;

// Paramètres de base
final int START_LIFES = 3;
final int SCORE_KILL = 10;

final String MAIN_TITLE = "Space Invaders";

// Couleurs
final color COLOR_EMPTY = color(255);
final color COLOR_SPACESHIP = color(0, 0, 255);
final color COLOR_INVADER = color(255, 0, 0);
final color COLOR_OBSTACLE = color(0);
final color COLOR_BULLET_SPACESHIP = color(255, 255, 0);
final color COLOR_BULLET_INVADER = color(255, 0, 0);

final color COLOR_BUTTON_BASE = color(63, 59, 59);
final color COLOR_BUTTON_HOVER = color(142, 135, 135);

final color COLOR_PAUSE_MENU_BG = color(43, 41, 41);

final color COLOR_TEXT_BUTTON = color(253, 255, 38);

// Intervalles de temps
final int MOVE_INTERVAL_BULLET_SPACESHIP = 30;
final int MOVE_INTERVAL_BULLET_INVADER = 50;

final int MOVE_INTERVAL_INVADER = 1000;

final int SHOT_INTERVAL = 500;

final int MIN_INTERVAL_INVADER_SHOT = 1000;
final int MAX_INTERVAL_INVADER_SHOT = 2000;