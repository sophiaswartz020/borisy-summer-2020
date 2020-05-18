// Get the current image; generic command from https://gist.github.com/petebankhead/53c0651dd1ad4f455622fc8eeefdc21e
idOrig = getImageID();

// Duplicate the image and store the ID of the duplicate
selectImage(idOrig);
run("Duplicate...", "title=[mixed FOV1-1-Ch4dup.czi] duplicate channels=4");
idDup = getImageID();
selectImage(idDup);

//run("Brightness/Contrast...");
resetMinAndMax(); 

// Run a Median filter on duplicated image
run("Median...", "radius=3"); 
setOption("ScaleConversions", true); //not sure what this step is doing

//Convert duplicated image to 8-bit
run("8-bit"); //tested up until here, all good so far
