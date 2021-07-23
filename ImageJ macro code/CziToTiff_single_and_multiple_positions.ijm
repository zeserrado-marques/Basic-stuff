/*
 * Convert .czi into .tif. For big data, use ZEN software to do this.
 * Keeps folder structure.
 * Works for split positions and single files
 * 
 * Author: José Serrado Marques
 * Date: 2021/07/23
 */
run("Bio-Formats Macro Extensions");
print("\\Clear");

// variables
parentheses = ")";

// paths
input_dir = getDirectory("Choose input master folder containing all .czi images");
input_name = File.getNameWithoutExtension(input_dir);
folder_name = getString("Name of output folder", input_name + "_tif");
new_top_dir_output = File.getParent(input_dir) + File.separator + folder_name;
File.makeDirectory(new_top_dir_output);

start_time = getTime();

// run code
setBatchMode("hide");

processFolder(input_dir, new_top_dir_output, "", parentheses);

end_time = getTime();
runtime(start_time, end_time);

// functions
function processFolder(input, new_top_dir_output, current_folder, parentheses) { 
	list_files = getFileList(input);
	for (i = 0; i < lengthOf(list_files); i++) {
		current_file = list_files[i];
		//print(current_file);
		if (File.isDirectory(input + File.separator + current_file)) {
			print(current_file + " is a folder");
			current_folder = current_file;
			output_dir = new_top_dir_output + File.separator + current_folder;
			if (File.isDirectory(output_dir) != true) {
				print("making dir - " + output_dir);
				File.makeDirectory(output_dir);
			}
			processFolder(input + File.separator + current_file, output_dir, current_folder, parentheses);
		}
		if (endsWith(current_file, ".czi") && indexOf(current_file, parentheses) == -1 ) {
			path_current = input + File.separator + current_file;
			Ext.setId(path_current);
			Ext.getSeriesCount(seriesCount);
			seriesCount = seriesCount;
			for (n = 0; n < seriesCount; n++) {
				//print(new_top_dir_output);
				//print("Opening - " + current_file + " position" + (n+1));
				processFile(path_current, new_top_dir_output, n+1);
			}
		}
	}
}

function processFile(path_current, output, n) {
	// macro code here
	run("Bio-Formats Importer", "open=["+path_current+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_" + n);
	Ext.setId(path_current);
	Ext.getSeriesCount(seriesCount);
	seriesCount = seriesCount;
	
	name = File.getNameWithoutExtension(path_current);
	if (seriesCount != 1) {
		name = name + "_position_" + n;
	}
	//print(name);
	saveAs("Tiff", output + File.separator + name + ".tif");
	close("*");
	run("Collect Garbage");
}


function runtime(start_time, end_time) { 
	// print time in minutes and seconds
	total_time = end_time - start_time;
	minutes_remanider = total_time % (60 * 1000);
	minutes = (total_time - minutes_remanider) / (60 * 1000);
	seconds = minutes_remanider / 1000;
	print("Macro runtime was " + minutes + " minutes and " + seconds + " seconds.");
}

