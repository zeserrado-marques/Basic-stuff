/* macro to automatically create .czi files into .tif files
   By José Serrado Marques at Tue May 19 13:31:17 BST 2020
 */

// get folder path with image files inside
input = getDirectory("Choose image's folder");
list_files = getFileList(input);

// Creates a dialog box for the user to write the name of the input folder
Dialog.create("User input for folder name");
Dialog.addString("Name of the output folder:", "Output_folder");
Dialog.show();
folder_name = Dialog.getString();

// create the output folder to have only the tif images
parent_dir = File.getParent(input);
output = parent_dir + File.separator + folder_name;
File.makeDirectory(output);

// batch mode enables macro to run faster (because images are not displayed
setBatchMode("hide");
// go through all the files
for (i = 0; i < lengthOf(list_files); i++) {
	current_file = list_files[i]; // so i don't have to write the list indexing everytime inside the loop 
	path_current_file = input + File.separator + current_file;
	// open all images that end with .czi (images that are czi files) and saves them as tif in the output folder
	if (endsWith(current_file, ".czi")) {
		run("Bio-Formats Windowless Importer", "open=" + path_current_file);
		name_current_file = substring(current_file, 0, lengthOf(current_file) - 4);
		saveAs("Tiff", output + File.separator + name_current_file);
	}
}
