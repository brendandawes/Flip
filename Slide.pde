class Slide{
  
  File file;
  File imageFile;
  File videoFile;
  String lines[];
  PImage img;
  float textAlpha;
  int index;
  float imageWidth;
  float imageHeight;
  ArrayList images;
  int currentImage = 0;
 
  
  Slide(File file, ArrayList images, File videoFile, String draftText, int index) {
    
    this.file = file;
    this.images = images;

    if (this.file != null) {
    	this.lines = loadStrings(file.getPath());
    }

    if (images.size() > 0) {

    this.imageFile = (File) images.get(currentImage);

      if (this.imageFile != null) {
        this.img = loadImage(this.imageFile.getPath());
        scaleImage();
	     }

    }

	this.videoFile = videoFile;

	this.textAlpha = 255;

  this.index = index;

  if (this.videoFile == null && this.imageFile == null && this.file == null) {

    this.lines = new String[1];
    this.lines[0] = draftText;
    
  }
    
    
  }

  void scaleImage() {

   
  float w = img.width;
  float h = img.height;

    if (w > width || h > height) {
     float ratio = min(float(width)/ img.width, float(height)/ img.height);
     imageWidth = img.width*ratio;
     imageHeight = img.height*ratio;
    }
  }


  void nextImage() {
    if (images.size() > 1) {
    currentImage = (currentImage+1) % images.size();
    loadImageForSlide(currentImage);
  }
  

  }

   void prevImage() {
  if (images.size() > 1) {
    currentImage = max(0,(currentImage-1) % images.size());
    loadImageForSlide(currentImage);
  }
  
    
  }

  void loadImageForSlide(int imageNumber) {


    imageFile = (File) images.get(imageNumber);
    img = loadImage(imageFile.getPath());
    scaleImage();


  }

  

 
  
  
  
}