/*
Flip by Brendan Dawes - http://brendandawes.com
Made for Processing - http://processing.org


Requires the following libraries:

http://www.looksgood.de/libraries/Ani/

http://www.sojamo.de/libraries/oscP5/
*/

import de.looksgood.ani.*;
import processing.video.*;
import oscP5.*;
import netP5.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import processing.serial.*;
import cc.arduino.*;
import java.awt.image.BufferedImage;
import java.awt.geom.Point2D;
import java.awt.Point;

Arduino arduino;

String[] serialPorts;

final String APP_NAME = "Flip.app";

float startTime = 0;

float currentTime;

int zDepth = 3000;

int numberColumns = 2;

color backgroundColor = #eeeeee;

color slideBackgroundColor = #dddddd;

String presentationTitle;

String serialPortForArduino;

OscP5 oscP5;

java.io.File folder;

ArrayList images;

ArrayList slides;

ArrayList<String> script;

ArrayList<PImage> screens;

int typeSize = 120;

float rotX = 0;
float rotY = PI/4;
float sceneZ = -3000;
float sceneX = 0;
float sceneY = 0;

int leftMargin = 300;

float textBaselineAdjust = 0;

int currentSlide = 0;

int scriptCounter = 0;

AniSequence seq;

Boolean isEditMode = false;

Boolean isPlayingVideo = false;

Boolean isIntroMode = false;

Boolean isProjectorTest = false;

Boolean mouseDragging = false;

Boolean isTypeVisible  = true;

Boolean isLoaded = false;

Boolean isSummary = false;

PFont font;

PFont titleFont;

float textXpos = 100;

float xStep;
float yStep;
float totalWidth;

JSONObject settings;

Movie movie;

PImage testcard;

PImage playIcon;

Minim minim;

AudioPlayer song;

float lastDebounceTime = 0;

 int DEBOUNCE_DELAY = 500;

int NEXT_SLIDE_BUTTON = 2;

 int PREV_SLIDE_BUTTON = 3;

 int DOWN_BUTTON = 0;

 int UP_BUTTON = 5;

 int PLAY_VIDEO_BUTTON = 6;

 int ZOOM_BUTTON = 7;


void setup() {


  size(displayWidth,displayHeight,OPENGL);
  if (frame != null) {
    frame.setResizable(true);
    frame.setCursor(frame.getToolkit().createCustomCursor(
            new BufferedImage(3, 3, BufferedImage.TYPE_INT_ARGB), new Point(0, 0),
            "null"));
  }

  
  Ani.init(this);
  minim = new Minim(this);
  oscP5 = new OscP5(this,8000);
  seq = new AniSequence(this);
  smooth();
  background(0);
  rectMode(LEFT);
  setBaseFolder();
  loadSettings();
  
 

}

void setBaseFolder() {

  folder = new java.io.File(dataPath(""));
 
  if (isExportedAppVersion(folder)) {

    int i = folder.getPath().indexOf(APP_NAME);
    String newPath = folder.getPath().substring(0,i-1);
    folder = new java.io.File(newPath);
   
  } 

}

Boolean isExportedAppVersion(File f){

  if (f.getPath().indexOf(APP_NAME) !=-1) {
    return true;
  } else {
    return false;
  }

}

void initApp() {

  xStep = width*2;
  yStep = height*2;
  totalWidth = xStep*numberColumns;
  currentSlide = 0;
  sceneX = width/2;
  sceneY = height/2;
  startTime = 0;
  screens = new ArrayList<PImage>();
  getSlides();
  showOverview();

}

void loadSettings() {

  try {
    settings = loadJSONObject(folder+"/settings.json");
    parseSettings();
   
  } catch (Exception e) {
    createSettings();
  }
  
  
}

void parseSettings() {

numberColumns = settings.getInt("columns");

backgroundColor = unhex("FF"+settings.getString("background"));

slideBackgroundColor = unhex("FF"+settings.getString("slidebackground"));

presentationTitle = settings.getString("title");

  

  String typeface = settings.getString("typeface");

  try {
    zDepth = settings.getInt("zDepth");
  } catch (Exception e) {}

  try {
    leftMargin = settings.getInt("leftMargin");
  } catch (Exception e) {}

   try {
    NEXT_SLIDE_BUTTON = settings.getInt("nextButton");
  } catch (Exception e) {}

    try {
    PREV_SLIDE_BUTTON = settings.getInt("prevButton");
  } catch (Exception e) {}

    try {
    PLAY_VIDEO_BUTTON = settings.getInt("playButton");
  } catch (Exception e) {}


  try {
    serialPortForArduino = settings.getString("serialPort");
    initArduino();
  } catch (Exception e) {}

  

  font = createFont(typeface, typeSize);

  textFont(font);

  textAlign(LEFT, TOP);

  textBaselineAdjust = typeSize - textAscent();

  thread("initApp");

}

void createSettings(){

  JSONObject json = new JSONObject();
  json.setInt("columns", 3);
  json.setString("title", "Welcome to Flip\n\nPress 0 to start");
  json.setString("typeface", "Helvetica");
  json.setString("background","f7941d");
  json.setString("slidebackground","959595");
  json.setInt("zDepth", 2000);
  saveJSONObject(json, folder+"/settings.json");
  settings = json;
  parseSettings();
}

void initArduino() {

try {

  arduino = new Arduino(this, serialPortForArduino, 57600);
  if (arduino != null) {
    saveStrings("serialports.txt", arduino.list());
  }
  arduino.pinMode(NEXT_SLIDE_BUTTON, Arduino.INPUT);
  arduino.pinMode(PREV_SLIDE_BUTTON, Arduino.INPUT);
  arduino.pinMode(PLAY_VIDEO_BUTTON, Arduino.INPUT);
  arduino.pinMode(DOWN_BUTTON, Arduino.INPUT);
  arduino.pinMode(UP_BUTTON, Arduino.INPUT);
  arduino.pinMode(ZOOM_BUTTON, Arduino.INPUT);
  
} catch (Exception e) {
  
}
  

}

void draw() {
  
  if (settings != null) {
  background(backgroundColor);

  pointLight(255, 255, 255, width/2, height/2, 2000);
  pushMatrix();
    //drawTime();
    translate(sceneX, sceneY, sceneZ);
    scale(0.5);
    rotateX(rotX);
    rotateY(rotY);
    showLayout();
  popMatrix();

  if (isEditMode) {
    drawTitle();
  }
  if (isSummary){

    drawSummary();
  }
  if (isProjectorTest) {

    drawProjectorTest();

  } else {
    if (song != null) {
      song.pause();
      song = null;
    }
  }

  readArduino();
  } 
 
}

Boolean isArduinoHigh(int pin){

 if (arduino.digitalRead(pin) == Arduino.HIGH && (millis() - lastDebounceTime) > DEBOUNCE_DELAY ){ 
  lastDebounceTime = millis();
  return true;
 } else {
  return false;
 }
}

void readArduino() {

try {
  if (isArduinoHigh(NEXT_SLIDE_BUTTON) ) {
    advancePresentation();
    println("high");
  }

  if (isArduinoHigh(PREV_SLIDE_BUTTON)) {
    rewindPresentation();
  }

  if (isArduinoHigh(UP_BUTTON)) {
    up();
  }

  if (isArduinoHigh(DOWN_BUTTON)) {
    down();
  }

  if (isArduinoHigh(PLAY_VIDEO_BUTTON)) {
    playVideo();
  }

  if (isArduinoHigh(ZOOM_BUTTON)) {
    toggleZoom();
  }
  
} catch (Exception e) {
  
}

}

void showLayout() {

  float x = 0;
  float y = 0;
  float z;
  //int start = max(0,currentSlide-5);
  //int end = min(currentSlide+5,slides.size());
  int start = 0;
  int end = slides.size();
   
  for (int i=start; i < end; i++) {
    
    Slide slide = (Slide) slides.get(i); 
    x = slide.x;
    y = slide.y;
    z = slide.z;
   
    pushMatrix();
      if (isIntroMode) {
        rotateY(radians(frameCount*i)/20);
      } 
      translate(x, y, z);
      pushMatrix();
      rotateY(radians(slide.rotY));
      drawBackground(0,0,i);
      drawImage(slide,0,0);
      drawPlayIcon();
      drawText(slide,0,0);
      drawCaption(slide,0,0);
      drawProgress(slide,0,0,i);
      popMatrix();
    popMatrix();
  }

}


float[] getXYZ(int i) {

  float[] coords = new float[3];
  coords[0] = floor((i*xStep)%totalWidth);
  coords[1] = floor((i*xStep)/totalWidth)*yStep;
  coords[2] = -i*zDepth;
  return coords;

}


void showOverview() {

  isEditMode = true;
  Ani.to(this, 2.0, "rotX", radians(15));
  Ani.to(this, 2.0, "rotY", radians(-25));
  Ani.to(this, 5.0, "sceneZ", -2000);

}

void addScreenGrab(){

  PImage screenGrab = get();

  screens.add(screenGrab);

}

void drawTitle() {

  String lines[] = split(presentationTitle, '\n');
  pushMatrix();
  translate(-(width/2)+(width/5), 50, -700);
  rotateY(radians(15));
  rotateX(radians(15));
  drawTextBlocks(lines,0,0,color(100),255);
  popMatrix();

}

void drawPlayIcon(){

  Slide slide = (Slide) slides.get(currentSlide);
 if (slide.imageFile != null){
  if (slide.videoFileExistsForImage(slide.imageFile) == true && !isPlayingVideo) {
    if (playIcon == null) {
      playIcon = loadImage(folder+"/play.png");
    }
    
    image(playIcon, -playIcon.width, -playIcon.height, playIcon.width*2, playIcon.height*2);
  }
}

}

void drawSummary(){

  for (int i=0; i < screens.size(); i++){
    PImage p = screens.get(i);
    image(p,0,i*20,p.width/6,p.height/6);
  }

}

void drawProjectorTest() {
  float circleDiameter = 100;
  float circleRadius = circleDiameter/2;
  noLights();
  smooth();
  noStroke();
  fill(255,0,0);
  ellipse(circleRadius, circleRadius, circleDiameter, circleDiameter);
  fill(0,255,0);
  ellipse(width-circleRadius, circleRadius, circleDiameter, circleDiameter);
  fill(0,0,255);
  ellipse(width-circleRadius, height-circleRadius, circleDiameter, circleDiameter);
  fill(0,0,0);
  ellipse(circleRadius, height-circleRadius, circleDiameter, circleDiameter);
  if (testcard == null) {
   testcard = loadImage(folder+"/testcard.png");
  }
  image(testcard, width/2-testcard.width/2, height/2-testcard.height/2, testcard.width, testcard.height);
  playAudioTest();
}

void playAudioTest(){
  if (song == null) {
  try {
    song = minim.loadFile(folder+"/audio.mp3", 512);
  } catch (Exception e) {
    song = null;
  }

  if (song != null) {
    song.play();
  }  
}

}

void drawBackground(float x, float y,int slideNumber) {
  noStroke();
  if (isPlayingVideo && slideNumber == currentSlide) {
    fill(0);
  } else {
    fill(slideBackgroundColor);
  }
  pushMatrix();
  translate(x,y,-0.1);
  pushMatrix();
    translate(0,0,-1);
    box(width*2, height*2, 2);
  popMatrix();
  noFill();
  if (slideNumber == currentSlide) {
    strokeWeight(2);
    stroke(255,255,0);
  } else {
    strokeWeight(1);
    stroke(255);
  }
  if (isEditMode) {
    pushMatrix();
    translate(0,0,0);
    box(width*2, height*2, 500);
    popMatrix();
  }
  popMatrix();
 
}

void drawImage(Slide slide,float x, float y) {
  noStroke();

  if (slide.img != null) {

    float w = slide.img.width;
    float h = slide.img.height;
  
   
      slide.imageWidth = w;
      slide.imageHeight = h;
      if (w > width || h > height) {
        float ratio = min(float(width)/ slide.img.width, float(height)/ slide.img.height);
        w = slide.img.width*ratio;
        h = slide.img.height*ratio;
      }
  


   if (isPlayingVideo && slide.videoFile != null && slide.index == currentSlide) {
     TexturedCube(movie,w,h);
   } else {
     TexturedCube(slide.img,w,h);
   }
  
  
  }

}

void fadeOutTextCurrentSlide() {

  Slide slide = (Slide) slides.get(currentSlide);
  Ani.to(slide, 1.5, "textAlpha", 0);
  isTypeVisible = false;

}

void fadeInTextCurrentSlide() {

  Slide slide = (Slide) slides.get(currentSlide);
  Ani.to(slide, 1.5, "textAlpha", 255);
  isTypeVisible = true;

}

void playVideo() {
  
  Slide slide = (Slide) slides.get(currentSlide);
 
  if (slide.videoFileExistsForImage(slide.imageFile) == true) {
    if (!isPlayingVideo) {
    movie = null;
    movie = new Movie(this, slide.videoFile.getPath());
    movie.play();
    isPlayingVideo = true;
    fadeOutTextCurrentSlide();
  } else {
    resetVideo();

  }
   
  }

}

void resetVideo() {

  Slide slide = (Slide) slides.get(currentSlide);
   if (slide.videoFile != null && isPlayingVideo) {
      movie.stop();
      isPlayingVideo = false;
      fadeInTextCurrentSlide();
   }

}

void resetImages() {
  Slide slide = (Slide) slides.get(currentSlide);
  if (slide.images.size() > 1) {
    slide.currentImage = 0;
    slide.loadImageForSlide(0);
    fadeInTextCurrentSlide();
  } else {
    fadeInTextCurrentSlide();
  }

}

void movieEvent(Movie m) {
  m.read();
}

void scrubVideo(float val) {

  movie.pause();
  int framePos = int(map(val,0,1.0,0,movie.duration()));
  framePos = floor( (framePos) / 3) * 3;
  movie.jump(framePos);
  movie.play();
  movie.pause();


 

}



void drawCaption(Slide slide, float x, float y) {

  int captionHeight = 130;
  if (slide.caption != null) {
    textSize(75);
    pushMatrix();
    translate(-width+(textWidth(slide.caption)+200)/2, height/2, 50);
    noStroke();
    fill(0);
    box(textWidth(slide.caption)+200,captionHeight,50);
    fill(255);
    text(slide.caption, 100-textWidth(slide.caption)/2, 0-(captionHeight/1.8),50);
    popMatrix();
  }

}


void drawText(Slide slide, float x, float y) {

  textSize(typeSize);

  if (slide.lines != null) {
    x = x-width+leftMargin;
    String lines[] = slide.lines;
    float fillAlpha = slide.textAlpha;
    drawTextBlocks(lines,x,y,backgroundColor,fillAlpha);
  }

}

void drawProgress(Slide slide, float x, float y, int i){
if (!isPlayingVideo) {
  float w = width*2;
  float h = 10;
  float indicatorWidth = w / slide.images.size();
  float offset = indicatorWidth+(indicatorWidth*slide.currentImage);
 // println("offset: "+w);
  pushMatrix();
  translate(-width,height-h);
  if (slide.images.size() > 1){
    //println("offset: "+offset);
    fill(150);
    rect(x, y, w, h);
    fill(0);
    rect(offset, y, 0, h);
  }
  popMatrix();
}
}

void drawTextBlocks(String lines[],float x, float y,color fillColor,float fillAlpha) {
 
  float yOffset = (lines.length*typeSize)/1.5;
  for (int j =0 ; j < lines.length; j++) {
    noStroke();
    noFill();
    y = (j*typeSize)-yOffset/2;
    y  = floor( y / 60 ) * 60 ;
    pushMatrix();
      pushMatrix();
        fill(fillColor,fillAlpha);
        float w = textWidth(lines[j]);
        translate(x+(w/2),y+typeSize/1.5,50);
        if (lines[j].length() > 0) {
          box(w,typeSize+2,100);
        }
      popMatrix();
      pushMatrix();
        translate(0, 0, 101);
        fill(250,fillAlpha);
        text(lines[j], x, (y-3)+textBaselineAdjust);
      popMatrix();
    popMatrix();
  }

}

void drawTime() {

fill(255);
int minutes = int((millis()-startTime)/1000)/60;
text(str(minutes), 0, 0, 300, 200);

}

void TexturedCube(PImage img,float w, float h) {
  beginShape(QUADS);
    texture(img);
    vertex(-w, -h, 0, 0, 0);
    vertex(w, -h, 0, img.width, 0);
    vertex(w, h, 0, img.width, img.height);
    vertex(-w, h, 0, 0, img.height);
  endShape();
}


void getSlides() {
  isLoaded = false;
  slides = new ArrayList();
  script = new ArrayList<String>();
  java.io.File imageFile = null;
  java.io.File textFile = null;
  java.io.File videoFile = null;

  
  
  ArrayList folders = new ArrayList();
  java.io.FileFilter FolderFilter = new FolderFilter();
  File[] filelist = folder.listFiles(FolderFilter);

  script.add("start");

  for (int c=0; c < filelist.length; c++){
    if (filelist[c].isDirectory()) {
      folders.add(filelist[c]);
     
    }
  }
  for (int j=0; j < folders.size(); j++) {
    textFile = null;
    videoFile = null;
    imageFile = null;
    if (j != 0){
    script.add("nextSlide");
  }
    ArrayList images = new ArrayList();

    java.io.File slideFolder = (java.io.File)folders.get(j);
   
    java.io.FileFilter AssetsFileFilter = new AssetsFileFilter();

    File[] children = slideFolder.listFiles(AssetsFileFilter);
  
    for (int i=0; i < children.length; i++) {
      
     
     String name = children[i].getName().toLowerCase();

        if (name.endsWith("txt") || name.endsWith("text")) {
        
          textFile = children[i];

        } 

        if (name.endsWith("mov") || name.endsWith("mp4") || name.endsWith("mpeg")) {
        
          videoFile = children[i];

        } 

        if (name.endsWith("jpeg") || name.endsWith("jpg") || name.endsWith("png")) {

          images.add(children[i]);


        } 
    
      }
    
    String folderName = slideFolder.getName();

    float[] coords = getXYZ(j);
      
    Slide slide = new Slide(textFile, images,videoFile,folderName,j,coords[0],coords[1],coords[2]);

    slides.add(slide);
  
  }
  script.add("end"); 
  isLoaded = true;
  println("script: "+script);
}

void advancePresentation(){


  String command = script.get(scriptCounter);

if (command.equals("start") == true){
    startPresentation();
    scriptCounter++;
  }

  if (command.equals("end") == true){
    isSummary = true;
    showOverview();
    scriptCounter = 0;
  }

  if (command.equals("nextSlide") == true){
    nextSlide();
  }

    if (command.equals("nextImage") == true){
    down();
  }

  

}

void rewindPresentation(){

  scriptCounter  = max(1,scriptCounter-1);
  String command = script.get(scriptCounter);
  if (command.equals("nextSlide") == true){
     Slide slide = (Slide) slides.get((max(0,currentSlide-1)));
     if (slide.images.size() > 0){
      scriptCounter  = max(1,scriptCounter-(slide.images.size()-1));
     }
    prevSlide();
  }

    if (command.equals("nextImage") == true){
    up();
  }


}

void nextSlide() {


   if (!isEditMode) {
          if (!seq.isPlaying()) {
            if ((currentSlide+1) % numberColumns == 0) {
            seq = new AniSequence(this);
            seq.beginSequence();
            seq.add(Ani.to(this, 1.0, "rotY", radians(45),Ani.QUINT_OUT));
            seq.add(Ani.to(this, 1.0, "rotY", 0,Ani.QUINT_OUT,"onEnd:sequenceEnd"));
            seq.endSequence();
            seq.start();
          }
          }
        
      }
      resetVideo();
      resetImages();
      
      currentSlide  = (currentSlide+1) % slides.size();
      Slide slide = (Slide) slides.get(currentSlide);
      
      Ani.to(this, 1.5, "sceneX", (width/2)-(slide.x/2),Ani.QUINT_OUT);
      Ani.to(this, 1.0, "sceneY", (height/2)-(slide.y/2),Ani.QUINT_IN);
      if (!isEditMode) {
        Ani.to(this, 1.5, "sceneZ", (slide.z*-1)/2,Ani.BACK_IN,"onEnd:movementEnd");
    }

    scriptCounter = (scriptCounter+1)%script.size();
}

void prevSlide() {

  resetImages();
  resetVideo();
  currentSlide  = max(0,(currentSlide-1) % slides.size());
  Slide slide = (Slide) slides.get(currentSlide);
  float[] coords = getXYZ(currentSlide);
  Ani.to(this, 1.5, "sceneX", (width/2)-(coords[0]/2),Ani.QUINT_OUT);
  Ani.to(this, 1.3, "sceneY", (height/2)-(coords[1]/2),Ani.QUINT_IN);
  if (!isEditMode) {
    Ani.to(this, 1.5, "sceneZ", (slide.z*-1)/2,Ani.BACK_IN);
  }
  

}

void up() {

  resetVideo();

   Slide slide = (Slide) slides.get(currentSlide);
      if (slide.images.size() > 1) {
        fadeOutTextCurrentSlide();
        slide.prevImage();


      } else {
        fadeInTextCurrentSlide();
      }

}

void down() {

  resetVideo();

   Slide slide = (Slide) slides.get(currentSlide);
      if (slide.images.size() > 1) {
        slide.nextImage();
        scriptCounter = (scriptCounter+1)%script.size();
        fadeOutTextCurrentSlide();
        
      } else {

        fadeOutTextCurrentSlide();
      }


}

void startPresentation() {

  startTime = millis();
  resetVideo();
  fadeInTextCurrentSlide();
  resetImages();
  isEditMode = false;
  isIntroMode = false;
  currentSlide  = 0;
  float[] coords = getXYZ(currentSlide);
  Ani.to(this, 1.5, "sceneX", (width/2)-(coords[0]/2));
  Ani.to(this, 1.5, "sceneY", (height/2)-(coords[1]/2));
  Ani.to(this, 1.5, "rotX", 0);
  Ani.to(this, 1.5, "rotY", 0);
  Ani.to(this, 1.5, "sceneZ", 0,Ani.SINE_OUT);
  Slide slide = (Slide) slides.get(currentSlide);
  Ani.to(slide, 1.5, "rotY", 0);


}

void toggleIntro() {

  isIntroMode = !isIntroMode;
  

}


void toggleZoom() {

  isEditMode = !isEditMode;
  if (isEditMode) {
    showOverview();
  } else {
    Ani.to(this, 1.5, "rotX", 0);
    Ani.to(this, 1.5, "rotY", 0);
    Slide slide = (Slide) slides.get(currentSlide);
    Ani.to(this, 1.5, "sceneX", (width/2)-(slide.x/2));
    Ani.to(this, 1.5, "sceneZ", (slide.z*-1)/2,Ani.QUAD_IN_OUT);
    isIntroMode = false;
  }
}

void showAllSlides() {

  isIntroMode = false;

  showOverview();


  for (int i=0; i < slides.size(); i++) {

    Slide slide = (Slide) slides.get(i);
   
    Ani.to(slide, 1.5, "x", i*(width/(slides.size()/2)));
    Ani.to(slide, 1.5, "y", 0);
    Ani.to(slide, 1.5, "z", 0);
   Ani.to(slide, 1.5, "rotY", -45);
    Ani.to(this, 1.5, "rotY", 0);
    Ani.to(this, 1.5, "rotX", radians(-22));
    Ani.to(this, 1.5, "sceneX", -width/2);

  }

}

void saveSlide() {

  saveFrame("flip-####.png");

}

private class FolderFilter implements java.io.FileFilter {
    public boolean accept(File f) {
        
        String name = f.getName();

        if (name.equals(APP_NAME) || name.indexOf("_",0) > -1) {
          return false;
        } else {
          return true;
        }
        
    }
}
 


private class AssetsFileFilter implements java.io.FileFilter {
    public boolean accept(File f) {
      
        String name = f.getName().toLowerCase();
        return name.endsWith("mpeg") || name.endsWith("mp4") || name.endsWith("m4v") || name.endsWith("mov") || name.endsWith("jpeg") || name.endsWith("jpg") || name.endsWith("png") || name.endsWith("text") || name.endsWith("txt");
    }
}

void sequenceEnd() {

  seq.pause();
  
}

void movementEnd() {
  addScreenGrab();
}



void mouseDragged() {
  mouseDragging = true;
  if (!isPlayingVideo) {
    float rate = 0.01;
    rotX += (pmouseY-mouseY) * rate;
    rotY += (mouseX-pmouseX) * rate;
  } else {
    float val = map(mouseX,0,width,0,1.0);
    scrubVideo(val);
  }
}

void mouseReleased() {
  mouseDragging = false;
  if (isPlayingVideo) {
    movie.play();
  }
   
}

void testMe() {

  showAllSlides();
}







 
