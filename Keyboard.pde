void keyReleased() {
 
  if (key == CODED) {
    if (keyCode == LEFT) {
      rewindPresentation();
    } 

    if (keyCode == RIGHT) {
      advancePresentation();
      //Ani.to(this, 1.5, "sceneY", (width/2)-(width*currentSlide));
    }

    if (keyCode == DOWN) {

     down();

    }

    if (keyCode == UP) {

      up();

    }

    if (keyCode == SHIFT) {

      if (isTypeVisible) {
        fadeOutTextCurrentSlide();
      } else {
        fadeInTextCurrentSlide();
      }

    }


  } 

if (key == 'p') {
  advancePresentation();
   // Ani.to(this, 1.5, "roty", PI/4);
 }

 if (key == 'o') {
  rewindPresentation();
   // Ani.to(this, 1.5, "roty", PI/4);
 }

 if (key == 'f') {
  toggleZoom();
   // Ani.to(this, 1.5, "roty", PI/4);
 }

  if (key == 'i') {
  toggleIntro();
 }

if (key == '0') {

  startPresentation();

}

if (key == ' ') {
  playVideo();
}

if (key == 'r') {
  resetVideo();

  initApp();
}

if (key == 's') {
  saveSlide();
}

if (key == '`') {
  testMe();
}

if (key == 't') {
  isProjectorTest = !isProjectorTest;
}
  
}