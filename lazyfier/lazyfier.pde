/*
LAZIFIER Beta

Compare multiple frames previously extracted from a video.
Each pixel from the current frame is compare to its state at the previous frame.  
If the color between the two states of a pixel match (following an accuracy setting) the pixel is not displayed (draw green).

>> this experiment is about non calculated pixels from frame to frame during DivX compression encoding.  

*/
// PARAMETERS
String loadPath = "/imageSequence/sujet/";
String savePath = "/lazifiedImageSequence/sujet/"; // where each lazified frames will be saved

int videoWidth = 1888;
int videoHeight = 1062;

int frameIndex = 1;

byte accuracy = 1; // range: from 0 to 127 (0 = most accurate)
byte radius = 5; // area around each pixel to smooth it after pixel comparing (big value is longer to process)

// VARIABLES
PImage currentFrame;
PImage previousFrame;
File[] files;

int totalFrame;


void setup() {
	size(videoWidth, videoHeight); // Set the canvas size at the size of the images you want to process

	files = listFiles(sketchPath + loadPath);

	totalFrame = files.length;
	println("Number of files found: " + totalFrame); // number of files in the folder

	println("load previousFrame: " + (frameIndex-1) + " --> " + files[frameIndex-1].getName());
	previousFrame = loadImage((files[frameIndex-1])+"");
	println("load currentFrame: " + frameIndex + " --> " + files[frameIndex].getName());
	currentFrame = loadImage((files[frameIndex])+"");

}

void draw() {

	// Loads the pixel data for the display window into the pixels[] array 
	loadPixels();
	currentFrame.loadPixels();
	previousFrame.loadPixels();

	findLazyPixel(currentFrame, previousFrame, accuracy);

    smoothPixel(currentFrame);
        
	updatePixels();

	saveFrame(sketchPath + savePath + "lazy-" + (frameIndex) + ".png");
	println ("image saved @ " + savePath + "lazy-" + (frameIndex) + ".png");

	if ( frameIndex < totalFrame-1 )
	{
		frameIndex++;
		previousFrame = currentFrame;
		println("load currentFrame: " + frameIndex + " --> " + files[frameIndex].getName());
		currentFrame = loadImage((files[frameIndex])+"");
	}
	else
	{
		background(0);
		fill(255);
		textSize(24);
		text("Your frames are lazyfied!",10,34);
		println("Processing done in: " + (millis()/1000) + "seconds");
		noLoop();
	}
  
}

//taken from http://processing.org/learning/topics/directorylist.html
File[] listFiles(String dir) {

	println("Frames directory: "+dir);
	File file = new File(dir);

	if (file.isDirectory())
	{
		File[] files = file.listFiles();
		return files;
	}
	else
	{
		// If it's not a directory
		return null;
	}
}

void findLazyPixel(PImage c, PImage p, byte t) {
	// Compare current image and previous image
	for (int y = 0; y < height; y++ ) {
		for (int x = 0; x < width; x++ ) {
			int loc = x + y*width;

			// The functions red(), green(), and blue() pull out the three color components from a pixel.
			float rc = red(c.pixels[loc]); 
			float gc = green(c.pixels[loc]);
			float bc = blue(c.pixels[loc]);

			float rp = red(p.pixels[loc]);
			float gp = green(p.pixels[loc]);
			float bp = blue(p.pixels[loc]);

			// Image Processing would go here
			//if (rc == rp && gc == gp && bc == bp)
			if (abs(rc-rp) <= t || abs(gc-gp) <= t || abs(bc-bp) <= t) 
			{
				pixels[loc] = color(0,255,0);
			}
			else
			{
				pixels[loc] = color(rc,gc,bc);
			}
		}
	}
}

void smoothPixel(PImage c) {

	// Smooth the shape of the masking looking at each pixel's neighbours
	for (int y = radius; y < height-radius; y++ ) {
		for (int x = radius; x < width-radius; x++ ) {

			int squareW = radius*2+1;
			int gCount = 0;
			int loc = x + y*width;
			
			// Count the number of green pixels around the current pixel
			for (int y2 = y-radius; y2 < y-radius+squareW; y2++ ) {
				for (int x2 = x-radius; x2 < x-radius+squareW; x2++ ) {
					int locAround = x2 + y2*width;

					if (pixels[locAround] == color(0,255,0)) {
						gCount++; 
					}
				}
			}

			// if the pixel is green and there are more of new make it new
			// if the pixel is new and there are more of green make it green
			if (pixels[loc] == color(0,255,0) && gCount < squareW*squareW/2) {
				pixels[loc] = color(
									red(c.pixels[loc]),
									green(c.pixels[loc]),
									blue(c.pixels[loc])
								);
			} else if (gCount > squareW*squareW/2) {
				pixels[loc] = color(0,255,0);
			}
		}
	}
}
