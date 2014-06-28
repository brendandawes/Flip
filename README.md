Flip
----

![Flip](screenshot.jpg?raw=true "Flip screenshot")

Flip is a very simple presentation tool. I built it for myself after having enough of bloated software such as Keynote or Powerpoint, not to mention presentations that became corrupted. Keynote used to be great, then they had a meeting and ruined it. All I needed was a piece of software that would show slides containing images, video and text. 

![Flip](screenshot2.jpg?raw=true "Flip screenshot")

Flip is not for everyone. There's no presenter's notes. There's no multiscreen support. There's no chart making or anything like that. It's also not meant for lots of text. If you like those things in a presentation then continue using Keynote et al. Flip is not for you. What it does do however is remove the need for laying things out such as text, images, video etc, plus it doesn't store your stuff in any kind of proprietary format - your files all live outside of Flip.

It's also very much a work-in-progress; far from perfect but hopefully it's something to build on.

![Flip](screenshot3.jpg?raw=true "Flip screenshot")

How it works
------------

Flip is a viewer rather than an editor, meaning that there is no editing or slide construction within Flip itself. All slides are constructed as folders in the same directory as the exported Flip application. Each folder may contain a text file, a video file or multiple images.

Tip: you can quickly put an outline for a presentation together just by making a series of folders. Flip will use the name of the folder as draft text for the slide. 

Settings.json
-------------

Flip requires the settings.json file to be present in the same directory as the Flip application. You can use this json file to set the presentation title, the typeface, the background colour of the presentation, the background colour of the slides and the number of columns you wish to use for the grid.

Main controls
-------------

When first started Flip will be in intro mode - think of this as a pretty animation of your presentation that you can use to talk over, do an intro, a little dance or whatever. Press "i" to toggle between intro mode and grid mode.

Press "0" to start the presentation.

Use the left and right arrow keys to navigate.

At any time you can zoom out by pressing "f". Press "f" again to zoom back in.

SPACE BAR will play any video.

SHIFT will fade any text on screen.

Press "r" to reload the slides.

Slides
------

Flip comes with example folders (slides) to show how you can display text, images or video.

Text
----

To show text you create a text file with the extension txt. It doesn't matter what you call it as long as it has this extension. Each line of text in the text file will be rendered on the slide, but be aware there is no text wrapping so any text that is longer than the screen will be cut off or bleed onto the next slide.

Text is always rendered at the same default size.

Images
------

Files with the extensions png and jpeg are supported. Images larger than the screen size will be automatically scaled down to fit, whilst images smaller will be centered. You can have many images per slide - just use the up / down arrow keys to navigate multiple images. Any text shown over the first image will fade away when you start to use these keys.

Video
-----

Files with the extension mov, m4v, mpeg and mp4 are supported. To show video correctly you must have an image with the dimensions you wish to show the video at - anything larger than the screen will be scaled down to fit. When you press the SPACEBAR the video will play. Press SPACEBAR again to stop. When the video is playing you can drag with the mouse left or right to jump to a certain point in the video. As with images, any text over the video will fade away when playing.

Touch OSC
---------

Flip comes with support for Touch OSC so you can use an iPhone to control the presentation as long as you're on the same WiFi network.

More info about Touch OSC at http://hexler.net/software/touchosc

Known Issues & Wish List
------------------------

On my Macbook Air it's a little slow whilst my Desktop machine it runs really well.

The video poster image creation is not ideal and needs to be automated in some way.

Think it could also benefit from some kind of multiple text ability for building text points on a slide.

Multiple screen support with presenter notes would be great.

Contribute
----------

Fork this repo, make it better and do a pull request. Would love to see people improve on it.