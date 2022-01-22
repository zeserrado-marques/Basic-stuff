/*
 * Macro template to go through folders recursively, replicate folder tree structure and save output there
 * 
 * Developed for COLife macro scripting course 2022
 * 
 * Author: José Serrado Marques
 * Date: 2022/01/22
 * 
 */
print("\\Clear");

// paths
input = getDir("input top tree folder");
parent = File.getParent(input);
top_folder = getString("name output folder", File.getNameWithoutExtension(input) + "_processed");
output = parent + File.separator + top_folder;
File.makeDirectory(output);

// run code
start_time = getTime();

setBatchMode("hide");
processFolder(input, output);

end_time = getTime();
runtime(start_time, end_time);

// functions
// write the recursive functions to copy the input directory tree

function processFolder(input_path, output_path) {
	list_files = getFileList(input_path);
	for (i = 0; i < list_files.length; i++) {
		current = list_files[i];
		path_current = input_path + File.separator + current;
		if (File.isDirectory(path_current)) {
			mirror_folder = output_path + File.separator + current;
			File.makeDirectory(mirror_folder);
			// open folder to check files
			processFolder(path_current, mirror_folder);
		} else if (endsWith(current, ".tif")) {
			// opens, processes and saves file
			processFile(path_current, output_path);
		}
	}
}



function processFile(path_current, output) {
	// macro code here
	
}


function runtime(start_time, end_time) { 
	// print time in minutes and seconds
	total_time = end_time - start_time;
	minutes_remanider = total_time % (60 * 1000);
	minutes = (total_time - minutes_remanider) / (60 * 1000);
	seconds = minutes_remanider / 1000;
	print("Macro runtime was " + minutes + " minutes and " + seconds + " seconds.");
}


