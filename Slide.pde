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
  String caption;

  float x,y,z;

  float rotY;
 
  
  Slide(File file, ArrayList images, File videoFile, String draftText, int index,float x, float y, float z) {
    
    this.file = file;
    this.images = images;
    this.caption = null;

    if (this.file != null) {
    	this.lines = loadStrings(file.getPath());
    }

    if (images.size() > 0) {

    this.imageFile = (File) images.get(currentImage);

      if (this.imageFile != null) {
        this.img = loadImage(this.imageFile.getPath());
        scaleImage();
        loadCaptionForImage(this.imageFile);
	     }

    }

	this.videoFile = videoFile;

	this.textAlpha = 255;

  this.index = index;

  if (this.videoFile == null && this.imageFile == null && this.file == null) {

    this.lines = new String[1];
    this.lines[0] = draftText;
    
  }

  this.x = x;
  this.y = y;
  this.z = z;
  this.rotY = 0;
    
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
    if (currentImage == 0) {
      currentImage = images.size()-1;
    } else {
      currentImage = max(0,(currentImage-1) % images.size());
    }
    loadImageForSlide(currentImage);
  }
  
    
  }

  void loadImageForSlide(int imageNumber) {


    imageFile = (File) images.get(imageNumber);
    img = loadImage(imageFile.getPath());
    scaleImage();
    loadCaptionForImage(imageFile);

  }

  void loadCaptionForImage(File file){

    File captionFile = new File(file.getPath()+".caption");
    if (captionFile.isFile()){
      String lines[] = loadStrings(captionFile.getPath());
      caption = lines[0];
    } else {
      caption = null;
    }
    
  }

  boolean videoFileExistsForImage(File file){

    File videoFileToCheck;

    videoFileToCheck = new File(file.getPath()+".mov");

    if (videoFileToCheck.exists()){
        videoFile = videoFileToCheck;
       return true;
    }

     videoFileToCheck = new File(file.getPath()+".mpg");

      if (videoFileToCheck.exists()){
        videoFile = videoFileToCheck;
       return true;
    }

      videoFileToCheck = new File(file.getPath()+".m4v");

      if (videoFileToCheck.exists()){
        videoFile = videoFileToCheck;
       return true;
    }

      videoFileToCheck = new File(file.getPath()+".mpeg");

      if (videoFileToCheck.exists()){
        videoFile = videoFileToCheck;
       return true;
    }

    videoFileToCheck = new File(file.getPath()+".mp4");

      if (videoFileToCheck.exists()){
        videoFile = videoFileToCheck;
       return true;
    }

    return false;

  }

  

 
  
  
  
}