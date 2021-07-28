/*
 * Macro uniformize brightness for all DIC images using Retrospective (a posteriori) correction
 * 
 * Transform images into grayscale and puts a scale bar for 20µm
 * Saves processed image in a new folder, with a name given by the user. Keeps folder structure
 * 
 * Conditions: 
 * - top folder (directory) with images and/or folders. Those folders must have images inside that are .png or .tif
 * 
 * Author: José Serrado Marques
 * Date: 2021-07-28
 * Version: v1
 * 
 * References:
 * - Landini G. (2006-2020) Background illumination correction. Available at: https://blog.bham.ac.uk/intellimic/background-illumination-correction
 * 
 * Please cite the reference and me if you this macro :D. Thx
 */
print("\\Clear");

// conversion of RGB to grayscale is weighted
run("Conversions...", "scale weighted");

// variables
brightness = "brightness";
illumination = "illumination";

// path input
input_dir = getDirectory("Choose input master folder containing all images to be processed");
input_name = File.getNameWithoutExtension(input_dir);

// user input
Dialog.create("User input");
Dialog.addMessage("The gray value can be obtained by \napplying a big guassian filter (sigma=500)\nand measure the mean intensity.");
Dialog.addNumber("gray level", 95);
Dialog.addNumber("scale bar size", 20);
Dialog.addString("Name of output folder", input_name + "_processed");
Dialog.addCheckbox("Are images calibrated?", false);
Dialog.show();
gray_level = Dialog.getNumber();
scalebar_size = Dialog.getNumber();
folder_name = Dialog.getString();
is_scaled = Dialog.getCheckbox();

// pixel_size = 0 will be replaced inside the function
if (is_scaled == false) {
	Dialog.create("Pixel size");
	Dialog.addNumber("Please introduce pixel size in microns (um)", 0.1377410, 4, 6, "um");
	Dialog.show();
	pixel_size = Dialog.getNumber();
} else {
	pixel_size = "";
}

// create output dir
new_top_dir_output = File.getParent(input_dir) + File.separator + folder_name;
File.makeDirectory(new_top_dir_output);

// initialize
start_time = getTime();

setBatchMode("hide");
processFolder(input_dir, new_top_dir_output, "");

end_time = getTime();
runtime(start_time, end_time);

// functions

function processFolder(input, new_top_dir_output, current_folder) { 
	list_files = getFileList(input);
	for (i = 0; i < lengthOf(list_files); i++) {
		current_file = list_files[i];
		//print(current_file);
		if (File.isDirectory(input + File.separator + current_file)) {
			print(current_file + " is a folder");
			current_folder = current_file;
			output_dir = new_top_dir_output + File.separator + current_folder;
			// create folder if it does not exist
			if (File.isDirectory(output_dir) != true) {
				print("making dir - " + output_dir);
				File.makeDirectory(output_dir);
			}
			processFolder(input + File.separator + current_file, output_dir, current_folder);
		}
		if (endsWith(current_file, ".png") || endsWith(current_file, ".tif")) {
			path_current = input + File.separator + current_file;
			print("opening " + current_file);
			open(path_current);
			processFile(new_top_dir_output, brightness, illumination, pixel_size, scalebar_size);
		}
	}
}

function processFile(output_dir, brightness, illumination, pixel_size, scalebar_size) { 
	// light uniformization. Brightness and illumination are strings
	org_name = getTitle();
	file_type = substring(org_name, lastIndexOf(org_name, ".") + 1);
	rename(brightness);
	// turn into grayscale
	RGB_to_grayscale(brightness);

	// creates the a-posteriori flat-field
	run("Duplicate...", "title=" + illumination);
	run("Gaussian Blur...", "sigma=500");
	run("Calculator Plus", "i1=" + brightness + " i2=" + illumination + " operation=[Divide: i2 = (i1/i2) x k1 + k2] k1=" + gray_level + " k2=0 create");
	selectWindow("Result");
	close("\\Others");
	
	// set and insert scale at 20 µm
	getPixelSize(unit, pixelWidth, pixelHeight);
	if (unit != "pixels") {
		run("Scale Bar...", "width=" + scalebar_size + " height=12 font=42 color=White background=None location=[Lower Right] bold hide");
	} else {
		Stack.setXUnit("um");
		run("Properties...", "channels=1 slices=1 frames=1 pixel_width=" + pixel_size + " pixel_height=" + pixel_size + " voxel_depth=1");
		run("Scale Bar...", "width=" + scalebar_size + " height=12 font=42 color=White background=None location=[Lower Right] bold hide");
	}

	//run("Set Scale...", "distance=363 known=50 unit=um");

	saveAs(file_type, output_dir + File.separator + org_name);
	close("*");
}

function RGB_to_grayscale(imagename) { 
// Checks if image is RGB. If RGB, converts to 8bit grayscale. Else, kills script
	selectWindow(imagename);
	if (bitDepth() == 24) {
		run("8-bit");	
	} else {
		waitForUser("The image needs to be a RGB image");
		exit;
	}
}

function runtime(start_time, end_time) { 
	// print time in minutes and seconds
	total_time = end_time - start_time;
	minutes_remanider = total_time % (60 * 1000);
	minutes = (total_time - minutes_remanider) / (60 * 1000);
	seconds = minutes_remanider / 1000;
	print("Runtime is " + minutes + " minutes and " + seconds + " seconds.\n");
}
