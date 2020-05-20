// Implement a global variable for stack duplication
n=1;
FOVid=1;

// Get the current image; generic command from https://gist.github.com/petebankhead/53c0651dd1ad4f455622fc8eeefdc21e
idOrig=getImageID();

// Sets up a print window to keep track of which channels of the stack are segmented
print("Channels segmented:");

// For loop to duplicate all channels in a stack, incremented by n
for (i=n; i<9; i++) { 
	ChannelDup(n, idOrig, i);
	idDup=getImageID();
	selectImage(idDup); 
	
	//run("Brightness/Contrast...");
	resetMinAndMax(); 
	
	// Run a Median filter on duplicated image
	run("Median...", "radius=3"); 
	setOption("ScaleConversions", true); //not sure what this step is doing

	// Convert duplicated image to 8-bit
	run("8-bit"); 

	// User input for parameter 1 with Bernsen method
	BernsenParam1(); 

	run("Watershed"); 
	run("Set Measurements...", "area mean min integrated median display redirect=[mixed FOV1.czi] decimal=3"); // need to generalize FOV1
	run("Analyze Particles...", "size=0.50-Infinity display include summarize"); 
	
	// Be careful with renaming and directing to folders based on channel; constant FOV and varying channel number
	SaveAndClose(FOVid, i); 

	// Log to record which channels have been processed through the for-loop
	text="mixedFOV" + FOVid + "-Ch" + i;
	print(text);
	
	// Updates print window after all channels have been processed 
	if(i>=8) {
		print("mixFOV" + FOVid + "-Ch8"); 
		print("\\Update:<All channels processed>"); 
	}
}

// Duplicates a given channel from the uploaded image stack
function ChannelDup(n, idOrig, i) {
	selectImage(idOrig);
	run("Duplicate...", "title=[Dup.czi] duplicate channels=i");
	rename("mixed FOV1-1-Ch" + i + "dup.czi"); // make generic for any FOV 
}

// Inputs a user-defined Bernsen parameter 1 value
function BernsenParam1() {
	// Create a dialog box to try different parameter 1 values
	Dialog.create("Choose a parameter 1 value for the Bernsen method");
	Dialog.addNumber("Parameter 1", 1);
	Dialog.show();
	parameter1=Dialog.getNumber(); 
	// Run Bernsen
	run("Auto Local Threshold", "method=Bernsen radius=15 parameter_1=parameter1 parameter_2=0 white"); 
}

// Saves and closes summary, results, and tif to desktop
function SaveAndClose(FOVid, i) {
	saveAs("Results", "/Users/sophia/Desktop/FIJI image segmentation/20181113_JG_Lepto image source/FOV" + FOVid + "/Channel " + i + "/summary-mixedFOV1-Ch" + i + "dup.csv");
	close("summary-mixedFOV1-Ch" + i + "dup.csv"); 
	saveAs("Results", "/Users/sophia/Desktop/FIJI image segmentation/20181113_JG_Lepto image source/FOV" + FOVid + "/Channel " + i + "/results-mixedFOV1-Ch" + i + "dup.csv");  
	close("Results");
	saveAs("Tiff", "/Users/sophia/Desktop/FIJI image segmentation/20181113_JG_Lepto image source/FOV" + FOVid + "/Channel " + i + "/segimage-mixedFOV1-Ch" + i + "dup.tif");
	close("segimage-mixedFOV1-Ch" + i + "dup.tif");
}
