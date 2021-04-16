print("\\Clear");
folder_name = getString("Name of output folder", "AllHitsProcessed");

// paths
input_dir = getDirectory("Choose input master folder containing all images to be processed");
top_dir_output = File.getParent(input_dir) + File.separator + folder_name;
File.makeDirectory(top_dir_output);

processFolder(input_dir, "");

function processFolder(input, current_folder) { 
	list_files = getFileList(input);
	for (i = 0; i < lengthOf(list_files); i++) {
		current_file = list_files[i];
		//print(current_file);
		if (File.isDirectory(input + File.separator + current_file)) {
			print(current_file + " is a folder");
			current_folder = current_file;
			processFolder(input + File.separator + current_file, current_folder);
		}
		if (endsWith(current_file, ".png") || endsWith(current_file, ".tif")) {
			path_file = input + File.separator + current_file;
			output_dir = top_dir_output + File.separator + current_folder;
			if (File.isDirectory(output_dir) != true) {
				print("making dir - " + output_dir);
				File.makeDirectory(output_dir);
			}
			print("opening " + current_file);
			//open(path_file);
			//processFile(output_dir, brightness, illumination);	
		}
	}
}
