/* Macro to make MIP (maximum intensity projection) of z-stack images wtih multiple and join time series images 
 * taken using mouse recorder pro setup on zeiss imager with ZEN software without timelapse module
 * 
 * By José Serrado Marques
 * v1.0 - 2020/07/08
*/
print("\\Clear");

input = getDirectory("Choose input folder containing all images to be concatenated");
//create output directory wiht user input for output folder name
folder_name = getString("Name of output folder", "timeseries_concatenated_MIP");
parent = File.getParent(input);
output = parent + File.separator + folder_name;
File.makeDirectory(output);

run("Close All");
// prompts the user for number of positions
total_positions = getNumber("Number of positions", 8);

// setBatchMode("hide") sets ImageJ to not display images, allowing the macro to run faster
setBatchMode("hide");
// for loop to concatenate timeseries for each positions
for (j = 0; j < total_positions; j++) {
	n = j+1;
	concat_timeseries(input, output, n);
}


function concat_timeseries(input, output, n) { 
	// opens all frames of position "n" to make MIP and concatenate them into a single file. Saves them in "output"
	list_files = getFileList(input);
	for (i = 0; i < lengthOf(list_files); i++) {
		current_file = list_files[i]; 
		path_current_file = input + File.separator + current_file;
		
		// conditional to open only one image for each time point and do the MIP
		if (matches(current_file, ".*[^\w)].czi")) {
			print("opening " + current_file + ", position " + n);
			run("Bio-Formats Importer", "open=" + path_current_file + " autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_" + n);
			image_name = getTitle();
			run("Z Project...", "projection=[Max Intensity]");
			selectWindow(image_name);
			close();
		} 
	
	}

	// concatenate all the time frames into a single image
	run("Concatenate...", "all_open title=test_concat open");
	getDimensions(width, height, channels, slices, frames);
	
	// create string = name to save the file
	name_concat = substring(current_file, 0, lengthOf(current_file) - 7);
	if (endsWith(name_concat, "GFP")) {
		name_concat = name_concat + "-position_" + n;
	} else { name_concat = name_concat + "position_" + n;}
	
	
	// Save the file
	print("saving " + output + File.separator + name_concat + ".tif");
	saveAs("Tiff", output + File.separator + name_concat + ".tif");
	close();
}



