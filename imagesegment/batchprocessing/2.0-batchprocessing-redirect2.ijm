// Title: 2.0-batchprocessing-redirect2.ijm

// Asks user to choose input and output folders 
input = getDirectory("Input directory");
output = getDirectory("Output directory");

// Screens for .tif files exclusively
suffix = ".tif"; 

// Initiates batch mode processing; check that there is a set to false at end
setBatchMode(true);

// Declare a counter variable for the FOV
FOVid=2; 

processFolder(input);

// Processes through the input folder and identifies whether item is a file or folder
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list); // not sure precisely what this does
	print(list.length);
	for(i=0; i<list.length; i++) { // for-loop to iterate through contents of the input folder
		if(File.isDirectory(input + File.separator + list[i])); { // returns true if file is subdirectory aka folder
			processFolder(input + File.separator + list[i]);  
		}
		if(endsWith(list[i], suffix)) { // checks if .tif suffix is present, suffix means is file not subdirectory 
			open(input + list[i]);
			titleOrig=File.nameWithoutExtension;
			print(titleOrig);
			idOrig=getImageID();
			print(idOrig);
			// selectImage(idOrig);
			nameOrig=File.name;
			// print(nameOrig);
			processFile(input, output, list[i]);	
			
			// Iterate to next FOVid; set to 3 now due to testing
			// FOVid++;
		}
	}
}

function processFile(input, output, file) {
	print("Channels processed:");
	
	// For loop to duplicate all channels in a stack
	for (j=1; j<9; j++) { 
		// Initiates batch mode processing; check that there is a set to false at end
		setBatchMode(true);
		
		ChannelDup(titleOrig, idOrig, j);
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
		print(nameOrig);
		// a="["+nameOrig+"]";
		// print(a); 
		run("Set Measurements...", "area mean min integrated median display redirect=[" + nameOrig + "] decimal=3"); // try a FOVid combination
		print(titleOrig); // titleOrig instead?
		run("Analyze Particles...", "size=0.50-Infinity display include summarize");

		// pseudo-coloring images
		// OrangeLUT();
		// PurpleLUT();
		if(j==1) {
			function PurpleLUT() {
				red = newArray(256);
				green = newArray(256);
				blue = newArray(256);
				for (i=0; i<256; i++) {
			    	    red[i] = i/2;
				}
				for (i=0; i<256; i++) {
			    	    green[i] = 0;
				}
				for (i=0; i<256; i++) {
			    	    blue[i] = i;
				}
				setLut(red, green, blue);
			}
			PurpleLUT();
			// run("Purple");
		}
		if(j==2) {
			run("Blue");
		}
		if(j==3) {
			run("Cyan");
		}
		if(j==4) {
			run("Green");
		}
		if(j==5) {
			run("Yellow");
		}
		if(j==6) {
			// Defines new LUT colors (orange, purple)
			function OrangeLUT() {
				red=newArray(256);
				green=newArray(256);
				blue=newArray(256);
				for(i=0; i<256; i++) {
					red[i]=i;
				}
				for(i=0; i<256; i++) {
					green[i]=i/2; 
				}
				for(i=0; i<256; i++) {
					blue[i]=0; 
				}
				setLut(red, green, blue);
			}
			OrangeLUT();
			// run("Orange");
		}
		if(j==7) {
			run("Red");
		}
		if(j==8) {
			run("Magenta");
		}
			
		// Be careful with renaming and directing to folders based on channel; constant FOV and varying channel number
		SaveAndClose(file, output, j); 
		
		// Log to record which channels have been processed through the for-loop
		if(j<8) {
			print("Channel " + j); // tinker with this message
		}
			
		// Updates print window after all channels have been processed 
		if(j>=8) {
			print("<All channels processed>"); 
			close();
		}
	}
	
	// Duplicates a given channel from the uploaded image stack
	function ChannelDup(titleOrig, idOrig, j) {
		selectImage(idOrig);
		run("Duplicate...", "title=[Dup.tif] duplicate channels=j");
		rename(titleOrig + "-Ch" + j + "-dup.tif"); // make generic for any FOV 
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
	function SaveAndClose(file, output, j) {
		saveAs("Results", output + titleOrig + "/Channel " + j + "/summary-" + titleOrig + "dup-Ch" + j + ".csv");
		close("summary-" + titleOrig + "dup-Ch" + j + ".csv");
		saveAs("Results", output + titleOrig + "/Channel " + j + "/results-" + titleOrig + "-dup-Ch" + j + ".csv");  
		close("Results");
		saveAs("Tiff", output + titleOrig + "/Channel " + j + "/segimage-" + titleOrig + "-dup-Ch" + j + ".tif");
		close(output + titleOrig + "/Channel " + j + "/segimage-dup-Ch" + j + ".tif"); // this is probably redundant w BM = true
	}
	
	if(endsWith(input, File.separator)) {
		print("Processing: " + input + file);
	}
	else {
		print("Processing: " + input + File.separator + file); 
	}
	print("Saving to: " + output); 
}

print("Macro finished");
setBatchMode(false); // setting Batch Mode to false at end of macro
close();
