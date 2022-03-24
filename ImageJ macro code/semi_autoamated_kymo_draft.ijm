/*
 * Semi-automated macro to select 3 regions to create kymographs for each one of them.
 * Images do not need to be registred. This macro uses StackReg to do so. Please cite its paper.
 * 
 * Author: José Serrado Marques
 * Date: 2022/03/24
 * v1.0
 * 
 */


// iniatilize
run("Set Measurements...", "area mean standard min shape median redirect=None decimal=3");
setTool("polyline");
name_rois = newArray("apical", "middle", "basal"); // the size of this array defines the number of rois

// open the image
waitForUser("open the image. If it's open already, disregard this message.");

// get directory info
input = getDirectory("image");
img = getTitle();
img_name = File.getNameWithoutExtension(img);
// make output folder
output = input + img_name + "_kymographs";
File.makeDirectory(output);

// get image info
getDimensions(width, height, channels, slices, frames);

// do stack registration
Stack.setFrame(frames); // IMPORTANT for proper stack reg functioning
run("StackReg", "transformation=Affine");


// do threshold to get background mean
back_mean = getBackMean(frames);

// add rois for kymograph
Stack.setFrame(frames);
addROIs(name_rois);

// do kymographs
n = roiManager("count");
for (i = 0; i < n; i++) {
	selectWindow(img);
	roiManager("select", i);
	run("Reslice [/]...", "output=1.000 start=Top avoid");
	
	// get kymograph image
	run("Enhance Contrast", "saturated=0.35");
	kymo_img = getTitle();
	run("Select All");
	run("Plot Profile");

	// get plot profile values
	name_table = name_rois[i] + "_table";
	Plot.getValues(xpoints, ypoints);
	Table.create(name_table);
	Table.setColumn("Distance_(microns)", xpoints, name_table);
	Table.setColumn("Gray_Value", ypoints, name_table);
	Table.set("background_mean", 0, back_mean);

	// save info 
	selectWindow(kymo_img);
	run("Select None");
	saveAs("tiff", output + File.separator + name_rois[i] + "_kymo_" + img_name + ".tif");
	close();
	selectWindow(name_table);
	Table.save(output + File.separator + name_table + "_" + img_name + ".csv");
	run("Close");
}

// save and colse roi manager
roiManager("deselect");
roiManager("save", output + File.separator + img_name + "_kymo_rois.zip");
roiManager("delete");

if (getBoolean("close everything?")) {
	close("*");
}


// functions
function addROIs(name_rois) {
	// create rois for kymograph
	
	run("Enhance Contrast", "saturated=0.35");
	waitForUser("put segmented line, spline fit and width = 100"); // change later

	// draw rois
	roi_number = name_rois.length;
	for (i = 0; i < roi_number; i++) {
		// make line
		run("Select None");
		waitForUser("Add region to roi manager", "draw the line"); // write a check to verify is line was made
		
		// add the ROI
		roiManager("add");
		roiManager("select", i);
		roiManager("rename", name_rois[i]);
	}
}

function getBackMean(frames) {
	// do threshold to get background mean
	run("Duplicate...", "duplicate range=" + frames + " use");
	temp_img = getTitle();
	run("Duplicate...", "duplicate");
	temp2 = getTitle();
	run("Gaussian Blur...", "sigma=20");
	setAutoThreshold("Triangle dark");
	run("Create Selection");
	run("Make Inverse");
	selectWindow(temp_img);
	run("Restore Selection");
	run("Measure");
	back_mean = getResult("Mean", 0);
	run("Clear Results");
	close("Results");
	// close temporary images
	close(temp2);
	close(temp_img);
	
	return back_mean;
}

