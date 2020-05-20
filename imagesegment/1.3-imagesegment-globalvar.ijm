// Implement a global variable for stack duplication
n = 1; 

// Get the current image; generic command from https://gist.github.com/petebankhead/53c0651dd1ad4f455622fc8eeefdc21e
idOrig = getImageID();

// For loop to duplicate all channels in a stack, incremented by n
for (i=n; i<9; i++) { 
	ChannelDup(n, idOrig, i);
	idDup = getImageID();
	selectImage(idDup); 
	// Make functions for each filter/step
}

function ChannelDup(n, idOrig, i) {
	selectImage(idOrig);
	run("Duplicate...", "title=[Dup.czi] duplicate channels=i");
	rename("mixed FOV1-1-Ch" + i + "dup.czi"); // make generic for any FOV 
} //tested up until here, all good so far

//run("Brightness/Contrast...");
//resetMinAndMax(); 

// Run a Median filter on duplicated image
//run("Median...", "radius=3"); 
//setOption("ScaleConversions", true); //not sure what this step is doing

//Convert duplicated image to 8-bit
//run("8-bit"); 
