void oscEvent(OscMessage theOscMessage) {

    String addr = theOscMessage.addrPattern();
    float  val  = theOscMessage.get(0).floatValue();
    println("val: "+val);

    if(addr.equals("/1/zoom") && val == 1.0)        { toggleZoom(); }
    if(addr.equals("/1/nextslide") && val == 1.0)        { nextSlide(); }
    if(addr.equals("/1/prevslide") && val == 1.0)        { prevSlide(); }
    if(addr.equals("/1/up") && val == 1.0)        { up(); }
     if(addr.equals("/1/down") && val == 1.0)        { down(); }
    if(addr.equals("/1/play") && val == 1.0)        { playVideo(); }
    if(addr.equals("/1/start") && val == 1.0)        { startPresentation(); }
    if(addr.equals("/2/scrub"))        { scrubVideo(val); }

   
    
}