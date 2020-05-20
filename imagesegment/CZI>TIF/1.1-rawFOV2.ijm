// Title: 1.1-rawFOV2.ijm

selectWindow("mixed FOV2.czi");
run("Duplicate...", "title=[mixed FOV2-DupCh1-8.czi] duplicate");
saveAs("Tiff", "/Users/sophia/Desktop/CZI > TIF image segmentation/FOV2/mixed FOV2-DupCh1-8.tif");

// I want to add a line to close the original image stack following duplication
// Add line to close the duplicated image stack once saved as TIF
// Add global variable so is generic for any FOV#; maybe a "rename as" command?
// Experiment with whether the Bio Formats window can be bypassed: https://imagej.net/Bio-Formats
