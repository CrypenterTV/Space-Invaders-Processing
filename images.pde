class Images {

    String _folderName;

    PImage _spaceshipImage;

    PImage[] _invaderImages;

    PImage[] _backgroundImages;

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

        for(int i = 1; i < _backgroundImages.length + 1; i++) {
            _backgroundImages[i - 1] = loadImage(_folderName + "background" + i + ".jpg");
            _backgroundImages[i - 1].resize(width, height);
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


}