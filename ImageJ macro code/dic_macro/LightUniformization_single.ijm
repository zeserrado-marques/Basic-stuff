/*
 * Macro to do make brightness for DIC images. Also sets the scale
 * 
 */
brightness = "brightness";
illumination = "illumination";
gray_level = 95;

run("Duplicate...", "title=" + brightness);
RGB_to_grayscale(brightness);

run("Duplicate...", "title=" + illumination);
run("Gaussian Blur...", "sigma=500");
run("Calculator Plus", "i1=" + brightness + " i2=" + illumination + " operation=[Divide: i2 = (i1/i2) x k1 + k2] k1=" + gray_level + " k2=0 create");

// scale for 40x objective
run("Set Scale...", "distance=363 known=50 unit=um");
run("Scale Bar...", "width=20 height=12 font=42 color=White background=None location=[Lower Right] bold hide");
// close("\\Others");


function RGB_to_grayscale(imagename) { 
// checks if image is RGB. If RGB, converts to 8bit grayscale. else, kills script
	selectWindow(imagename);
	if (bitDepth() == 24) {
		run("8-bit");	
	} else {
		waitForUser("The image needs to be a RGB image");
		exit;
	}
}