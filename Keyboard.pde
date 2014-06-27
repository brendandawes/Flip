void keyReleased() {
 
  if (key == CODED) {
    if (keyCode == LEFT) {
      prevSlide();
    } 

    if (keyCode == RIGHT) {
      nextSlide();
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

if (key == 't') {
  isProjectorTest = !isProjectorTest;
}
  
}