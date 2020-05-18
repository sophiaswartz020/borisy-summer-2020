selectWindow("mixed FOV1.czi"); 
run("Duplicate...", "title=[mixed FOV1-1-Ch2dup.czi] duplicate channels=2"); 
selectWindow("mixed FOV1.czi"); 
selectWindow("mixed FOV1-1-Ch2dup.czi"); 
//run("Brightness/Contrast..."); 
resetMinAndMax(); 
run("Close"); 
run("Median...", "radius=3"); 
setOption("ScaleConversions", true); 
run("8-bit"); 
run("Auto Local Threshold", "method=Bernsen radius=15 parameter_1=35 parameter_2=0 white"); 
run("Watershed"); 
run("Set Measurements...", "area mean min integrated median display redirect=[mixed FOV1.czi] decimal=3"); 
run("Analyze Particles...", "size=0.50-Infinity display include summarize"); 
saveAs("Results", "/Users/sophia/Desktop/FIJI image segmentation/20181113_JG_Lepto image source/FOV1/FOV1_Ch2_Summary.csv"); 
saveAs("Results", "/Users/sophia/Desktop/FIJI image segmentation/20181113_JG_Lepto image source/FOV1/FOV1_Ch2_Results.csv"); 
saveAs("Tiff", "/Users/sophia/Desktop/FIJI image segmentation/20181113_JG_Lepto image source/FOV1/mixed FOV1-1-Ch2dup.tif"); 
