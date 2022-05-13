/*
 * Macro to count phytoplankton. Creates table with all measurements, single image measurements and summary.
 * 
 * Please cite Fiji and Yen thresholding method if you use this macro in your research.
 * 
 * Also, please acknowledge me for using the macro. Many thanks :D
 * 
 * José Serrado Marques
 * 2022-05-13
 * jpmarques@igc.gulbenkian.pt
 * 
 */


// initialize
run("Set Measurements...", "area mean perimeter shape feret's integrated median redirect=None decimal=4");

// variables
extensions_array = newArray(".tif", ".czi");

// paths
input = getDir("folder with images");
name_input = File.getNameWithoutExtension(input);
list_files = getFileList(input);
output = input + "Masks_ROIs_tables";
File.makeDirectory(output);

// create table to have all tables  
all_results_table = "all_phyto_counts";
Table.create(all_results_table);

// loop through images
setBatchMode("hide");
start_time = getTime();

for (i = 0; i < list_files.length; i++) {
	current_file = list_files[i];
	path_current = input + current_file;
	if (desiredFileExtensions(current_file, extensions_array)) {
		// open file
		run("Bio-Formats Importer", "open=["+path_current+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		// process file
		processFile(output, all_results_table);
	}
}

// save big table and summarize
Table.save(input + name_input + "_summarized_table.csv", "Summary");
Table.save(input + name_input + "all_images_table.csv", all_results_table);

end_time = getTime();
runtime(start_time, end_time);

// functions

function processFile(output, all_results_table) {
	// process each file and save output	
	
	// get names
	img = getTitle();
	img_name = File.getNameWithoutExtension(img);
	base_save_name = output + File.separator + img_name;
	
	// color deconvolution
	run("RGB Color");
	run("Colour Deconvolution", "vectors=RGB");
	
	// close unnecessary windows (color matrix, red and blue windows)
	close("Colour Deconvolution");
	close(img + " (RGB)-(Colour_1)");
	close(img + " (RGB)-(Colour_3)");
	
	// pre processing
	run("Median...", "radius=2");
	
	// threshold
	setAutoThreshold("Yen");
	setOption("BlackBackground", false);
	run("Convert to Mask");
	
	// binary operations
	run("Fill Holes");
	run("Open");
	
	// analyze particles
	run("Analyze Particles...", "size=20-Infinity circularity=0.60-1.00 show=Masks display exclude clear summarize add");
	mask_img = getTitle();
	
	// rename ROIs and create column with name info
	n = roiManager("count");
	for (i = 0; i < n; i++) {
		roiManager("select", i);
		roiManager("rename", "phyto_" + (i+1));
		setResult("Image Name", i, img_name + "_phyto_" + (i+1));
	}
	
	// table concatenation
	concatTables(all_results_table);
	
	// save stuff
	// ROIs
	roiManager("deselect");
	roiManager("save", base_save_name + "_ROIs.zip");
	// Results
	selectWindow("Results");
	saveAs("results", base_save_name + "_results_table.csv");
	// mask image
	selectWindow(mask_img);
	saveAs("tiff", base_save_name + "_cell_mask.tif");
	
	// close all
	roiManager("delete");
	run("Clear Results");
	close("*");
}


function desiredFileExtensions(file_name, extensions_array) {
	// this is in the case of union, meaning the file needs to be one of the presented file extensions
	for (i = 0; i < extensions_array.length; i++) {
		if (endsWith(file_name, extensions_array[i])) {
			return true;
		}
	}
	// returns false to not run the processFile function for the particular file
	return false;
}

function concatTables(all_results_table) {
	// an attempet at a modular creation of table concatenation
	
	// get current big table size
	last_table_size = Table.size(all_results_table);
	
	// get headings from Resuts table
	headings = split(String.getResultsHeadings, "\t");
	for (i = 0; i < nResults(); i++) {
		for (j = 0; j < headings.length; j++) {
			value = getResult(headings[j], i);
			// "value" might be a string
			if (isNaN(value)) {
				value = getResultString(headings[j], i);
			}
			Table.set(headings[j], i + last_table_size, value, all_results_table);
		}
	}
	
	Table.update(all_results_table);
}


function runtime(start_time, end_time) { 
	// print time in minutes and seconds
	total_time = end_time - start_time;
	minutes_remanider = total_time % (60 * 1000);
	minutes = (total_time - minutes_remanider) / (60 * 1000);
	seconds = minutes_remanider / 1000;
	print("Macro runtime was " + minutes + " minutes and " + seconds + " seconds.");
}


