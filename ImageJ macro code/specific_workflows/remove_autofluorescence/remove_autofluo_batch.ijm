/*
 * Macro to remove autofluorescence from main signal channel. Converts .czi into .tif. Keeps folder structure.
 * Developed for Rui Oliveira's group at IGC
 * 
 * please cite: 
 *  - Li threshold paper - https://www.sciencedirect.com/science/article/pii/S0167865598000579?via%3Dihub
 *  - Bioformats -  https://rupress.org/jcb/article/189/5/777/35828/Metadata-matters-access-to-image-data-in-the-real
 *  - Fiji - https://www.nature.com/articles/nmeth.2019
 * 
 *  Please thank me in your acknowledgements. Many thanks :D
 *  
 * Author: José Serrado Marques
 * Mail: jpmarques@igc.gulbenkian.pt
 * Date: 2022/05/24
 */
print("\\Clear");

// paths
input_dir = getDirectory("Choose input master folder containing all .czi images");
input_name = File.getNameWithoutExtension(input_dir);
folder_name = getString("Name of output folder", input_name + "_tif");
new_top_dir_output = File.getParent(input_dir) + File.separator + folder_name;
File.makeDirectory(new_top_dir_output);

start_time = getTime();

// run code
setBatchMode("hide");

processFolder(input_dir, new_top_dir_output, "");

end_time = getTime();
runtime(start_time, end_time);

// end of script

// functions
function processFolder(input, new_top_dir_output, current_folder) { 
	list_files = getFileList(input);
	for (i = 0; i < lengthOf(list_files); i++) {
		current_file = list_files[i];
		if (File.isDirectory(input + File.separator + current_file)) {
			print(current_file + " is a folder");
			current_folder = current_file;
			output_dir = new_top_dir_output + File.separator + current_folder;
			// create mirror folder 
			if (File.isDirectory(output_dir) != true) {
				print("making dir - " + output_dir);
				File.makeDirectory(output_dir);
			}
			processFolder(input + File.separator + current_file, output_dir, current_folder);
		} else {
			if (endsWith(current_file, ".czi")) {
				path_current = input + File.separator + current_file;
				processFile(path_current, new_top_dir_output);
			}
		}
	}
}


function processFile(path_current, output) {
	// macro code here
	run("Bio-Formats Importer", "open=["+path_current+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_1");
	
	name_to_save = File.getNameWithoutExtension(path_current);

	img_name = "raw_data";
	rename(img_name);
	
	c1 = "C1-" + img_name;
	c2 = "C2-" + img_name;
	c3 = "C3-" + img_name;
	
	// separate and prepare channels
	// C1 - DAPI, C2- ps6, C3 - autofluorescence
	run("Split Channels");
	
	// subtract background for DAPI
	selectWindow(c1);
	run("Subtract Background...", "rolling=50");
	
	// segment both C2 and 3
	selectWindow(c2);
	run("Duplicate...", "duplicate");
	c2_duplicated = getTitle();
	segmentStructures();
	
	selectWindow(c3);
	segmentStructures();
	
	// subtract autofluo from raw C2 image
	imageCalculator("Subtract create", c2_duplicated, c3);
	run("Fill Holes");
	run("Create Selection");
	selectWindow(c2);
	run("Restore Selection");
	run("Clear Outside");
	
	// merge channels
	run("Merge Channels...", "c1=" + c1 + " c2=" + c2 + " create");
	Stack.setChannel(1);
	run("Cyan");
	Stack.setChannel(2);
	run("Magenta");
	
	// save image
	saveAs("Tiff", output + File.separator + name_to_save + ".tif");
	
	// close all
	close("*");
	run("Collect Garbage");
}

function segmentStructures() {
	 run("Subtract Background...", "rolling=50");
	 run("Median...", "radius=3");
	 setAutoThreshold("Li dark");
	 run("Convert to Mask");
}

function runtime(start_time, end_time) { 
	// print time in minutes and seconds
	total_time = end_time - start_time;
	minutes_remanider = total_time % (60 * 1000);
	minutes = (total_time - minutes_remanider) / (60 * 1000);
	seconds = minutes_remanider / 1000;
	print("Macro runtime was " + minutes + " minutes and " + seconds + " seconds.");
}
