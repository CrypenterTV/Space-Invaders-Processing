class Images {

    String _folderName;

    PImage _spaceshipImage;

    PImage[] _invaderImages;

    PImage[] _backgroundImages;

    PImage _lifeImage;

    PImage _obstacleImage;

    PImage _mainTitleImage;

    PImage[] _explosionImages;

    Images(String folderName) {
        _folderName = folderName;
        loadImages();
    }

    void loadImages() {
        _spaceshipImage = loadImage(_folderName + "spaceship.png");

        _invaderImages = new PImage[8];
        _invaderImages[0] = loadImage(_folderName + "red_invader_2.png");
        _invaderImages[1] = loadImage(_folderName + "red_invader_1.png");
        _invaderImages[2] = loadImage(_folderName + "yellow_invader_1.png");
        _invaderImages[3] = loadImage(_folderName + "yellow_invader_2.png");
        _invaderImages[4] = loadImage(_folderName + "cyan_invader_1.png");
        _invaderImages[5] = loadImage(_folderName + "cyan_invader_2.png");
        _invaderImages[6] = loadImage(_folderName + "green_invader_1.png");
        _invaderImages[7] = loadImage(_folderName + "green_invader_2.png");

        _backgroundImages = new PImage[7];

        _lifeImage = loadImage(_folderName + "heart.png");

        _obstacleImage = loadImage(_folderName + "obstacle.png");

        _mainTitleImage = loadImage(_folderName + "main_title.png");

        for(int i = 1; i < _backgroundImages.length + 1; i++) {
            _backgroundImages[i - 1] = loadImage(_folderName + "background" + i + ".jpg");
            _backgroundImages[i - 1].resize(width, height);
        }

        _explosionImages = new PImage[NUMBER_EXPLOSION_FRAMES];
        for (int i = 0; i < _explosionImages.length; i++) {
            _explosionImages[i] = loadImage(_folderName + "explosion" + (i + 1) + ".png");
        }
    }


    PImage getSpaceshipImage() {
        return _spaceshipImage;
    }


    PImage getInvaderImage(int i) {
        
        if (i < 1 || i > _invaderImages.length) {
            return null;
        }

        return _invaderImages[i - 1]; 
    }

    PImage getBackgroundImage(int i) {

        if (i < 1 || i > _backgroundImages.length) {
            return null;
        }

        return _backgroundImages[i - 1];

    }


    PImage getLifeImage() {
        return _lifeImage;
    }


    PImage getObstacleImage() {
        return _obstacleImage;
    }

    PImage getMainTitleImage() {
        return _mainTitleImage;
    }

    PImage getExplosionImage(int index) {

        if (index < 0 || index >= _explosionImages.length) {
            return null;
        }
        
        return _explosionImages[index];
    }

}