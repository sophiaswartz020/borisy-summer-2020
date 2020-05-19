// Implement a global variable for stack duplication
n=1;
FOVid=1;

// Get the current image; generic command from https://gist.github.com/petebankhead/53c0651dd1ad4f455622fc8eeefdc21e
idOrig = getImageID();

// For loop to duplicate all channels in a stack, incremented by n
for (i=n; i<3; i++) { // reset to 9 channels and test drive
	ChannelDup(n, idOrig, i);
	idDup = getImageID();
	selectImage(idDup); 
	
	//run("Brightness/Contrast...");
	resetMinAndMax(); 
	
	// Run a Median filter on duplicated image
	run("Median...", "radius=3"); 
	setOption("ScaleConversions", true); //not sure what this step is doing

	// Convert duplicated image to 8-bit
	run("8-bit"); 

	// User input for parameter 1 with Bernsen method
	BernsenParam1(); // tested up until here, so far so good

	run("Watershed"); 
	run("Set Measurements...", "area mean min integrated median display redirect=[mixed FOV1.czi] decimal=3"); // need to generalize FOV1
	run("Analyze Particles...", "size=0.50-Infinity display include summarize"); 
	
	// be careful with renaming and directing to folders based on channel; constant FOV and varying channel number
	SaveAndClose(FOVid, i); 
}

function ChannelDup(n, idOrig, i) {
	selectImage(idOrig);
	run("Duplicate...", "title=[Dup.czi] duplicate channels=i");
	rename("mixed FOV1-1-Ch" + i + "dup.czi"); // make generic for any FOV 
}

// Function for inputting user-defined Bernsen parameter 1 values
function BernsenParam1() {
	// Create a dialog box to try different parameter 1 values
	Dialog.create("Choose a parameter 1 value for the Bernsen method");
	Dialog.addNumber("Parameter 1", 1);
	Dialog.show();
	parameter1=Dialog.getNumber(); 
	// Run Bernsen
	run("Auto Local Threshold", "method=Bernsen radius=15 parameter_1=parameter1 parameter_2=0 white"); 
}

function SaveAndClose(FOVid, i) {
	saveAs("Results", "/Users/sophia/Desktop/FIJI image segmentation/20181113_JG_Lepto image source/FOV" + FOVid + "/Channel " + i + "/summary-mixedFOV1-Ch" + i + "dup.csv");
	close("summary-mixedFOV1-Ch" + i + "dup.csv"); 
	saveAs("Results", "/Users/sophia/Desktop/FIJI image segmentation/20181113_JG_Lepto image source/FOV" + FOVid + "/Channel " + i + "/results-mixedFOV1-Ch" + i + "dup.csv");  
	close("Results");
	saveAs("Tiff", "/Users/sophia/Desktop/FIJI image segmentation/20181113_JG_Lepto image source/FOV" + FOVid + "/Channel " + i + "/segimage-mixedFOV1-Ch" + i + "dup.tif");
	close("segimage-mixedFOV1-Ch" + i + "dup.tif");
}
//Dialog.create("Choose parameter 1 for Bernsen method"); 
//Dialog.addNumber("Parameter 1", 1); 
//Dialog.show();
//parameter1 = Dialog.getNumber();

//run("Auto Local Threshold", "method=Bernsen radius=15 parameter_1=parameter1 parameter_2=0 white");
 
//run("Watershed"); 
//run("Set Measurements...", "area mean min integrated median display redirect=[mixed FOV1.czi] decimal=3"); 
//run("Analyze Particles...", "size=0.50-Infinity display include summarize"); 

// be careful with renaming and directing to folders based on channel
//saveAs("Results", "/Users/sophia/Desktop/FIJI image segmentation/20181113_JG_Lepto image source/FOV1/FOV1_Ch2_Summary.csv"); 
//saveAs("Results", "/Users/sophia/Desktop/FIJI image segmentation/20181113_JG_Lepto image source/FOV1/FOV1_Ch2_Results.csv"); 
//saveAs("Tiff", "/Users/sophia/Desktop/FIJI image segmentation/20181113_JG_Lepto image source/FOV1/mixed FOV1-1-Ch2dup.tif");
