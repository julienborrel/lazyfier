# Lazyfier
New way to watch moving image!

## How to use?
1. First you have to generate an image sequence from the video you want to lazyfy.
You can do it with QuickTime Player 7 under "File > Export...", then choose "Movie to Image Sequence" (you can set the frame rate you want under "Options").
2. Then put the all the frames generated in a folder under "imageSequence".
3. Then launch "lazyfier.pde" (you need Processing IDE)
4. Before running the sketch, set these parameters:

```
// PARAMETERS
String loadPath = "/imageSequence/yourProjectName/";
String savePath = "/lazifiedImageSequence/yourProjectName/";

int videoWidth = 1920;
int videoHeight = 1024;
```

5. Run the sketch! The process is long and depends of your computer hardware.

6. When the process is done, the new frames are stored in the "lazyfiedImageSequence" folder.
To generate the video, you can use Quicktime Palyer 7 again: "File > Open Image Sequence..." and select the correct folder.

Enjoy your new video without unnecessary information!
