// Title: 1.0-concordance checker.ijm

requires( "1.52g" );
n = nImages;
if (n!=2) exit("Two images need to be open.");
setBatchMode(true);
selectImage(1);
img1 = getTitle;
selectImage(2);
img2 = getTitle;
imageCalculator( "Difference create", img1, img2 );
run("8-bit");
changeValues(1, 255, 255);
run("Create Selection");
List.setMeasurements;
percent = List.getValue("Area")*100/(getWidth()*getHeight());
close();
print("Percentage identical: "+ d2s(percent, 6) );
setBatchMode(false);
exit();
