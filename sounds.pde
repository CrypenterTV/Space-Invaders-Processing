import processing.sound.*;

class Sounds {

  String _folderName;

  SoundFile _mainMenuMusic;
  SoundFile _bulletSound;
  SoundFile _gameMusic;
  SoundFile _explosionSound;

  Sounds(String folderName) {
    _folderName = folderName;
    loadSounds();
  }

  void loadSounds() {

    // Chargement de l'ensemble des sons du jeu.
    _mainMenuMusic = new SoundFile(getInstance(), _folderName + "main_menu_music.mp3");
    _bulletSound = new SoundFile(getInstance(), _folderName + "bullet-sound.mp3");
    _gameMusic = new SoundFile(getInstance(), _folderName + "game_music.mp3");
    _explosionSound = new SoundFile(getInstance(), _folderName + "explosion.mp3");
  }

  SoundFile getMainMenuMusic() {
    return _mainMenuMusic;
  }

  SoundFile getBulletSound() {
    return _bulletSound;
  }

  SoundFile getGameMusic() {
    return _gameMusic;
  }

  SoundFile getExplosionSound() {
    return _explosionSound;
  }

  // Fonction pour activer le son du jeu.
  void enableSounds() {

    if (soundActivated)
      return;

    soundActivated = true;

    switch (gameState) {

    case MAIN_MENU_STATUS:
      loopSound(_mainMenuMusic);
      break;

    case USERNAME_INPUT_MENU_STATUS:
      loopSound(_mainMenuMusic);
      break;

    case GAME_STATUS:
      loopSound(_gameMusic);
      break;

    case PAUSE_MENU_STATUS:
      loopSound(_gameMusic);
      break;

    case END_GAME_MENU_STATUS:
      loopSound(_gameMusic);
      break;
    }
  }

  // Fonction pour désactiver le son du jeu.
  void disableSounds() {

    if (!soundActivated)
      return;

    soundActivated = false;
    _mainMenuMusic.stop();
    _bulletSound.stop();
    _gameMusic.stop();
    _explosionSound.stop();
  }
}
