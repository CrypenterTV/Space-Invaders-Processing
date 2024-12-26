import processing.sound.*;

class Sounds {

    String _folderName;

    SoundFile _mainMenuMusic;
    SoundFile _bulletSound;
    SoundFile _gameMusic;

    Sounds(String folderName) {
        _folderName = folderName;
        loadSounds();
    }

    void loadSounds() {
        _mainMenuMusic = new SoundFile(getInstance(), _folderName + "main_menu_music.mp3");
        _bulletSound = new SoundFile(getInstance(), _folderName + "bullet-sound.mp3");
        _bulletSound.amp(0.3);
        _gameMusic = new SoundFile(getInstance(), _folderName + "game_music.mp3");
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


}
