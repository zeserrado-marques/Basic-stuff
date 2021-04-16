/*
 * Convert .czi into .tif. For big data, use ZEN software to do this.
 * Make sure to have all .czi files in a single folder/directory
 * Works only for split positions
 * 
 * Author: José Serrado Marques
 * Date: December 2020
 */
run("Bio-Formats Macro Extensions");
print("\\Clear");

// variables
parentheses = ")";

// paths
input = getDir("folder with czi");
list_files = getFileList(input);
output = input + File.separator + "Tif";
File.makeDirectory(output);

start_time = getTime();
// run code
setBatchMode("hide");
for (i = 0; i < lengthOf(list_files); i++) {
	current_file = list_files[i];
	path_current = input + File.separator + current_file;
	if (endsWith(current_file, ".czi") && indexOf(current_file, parentheses) == -1 ) {
		Ext.setId(path_current);
		Ext.getSeriesCount(seriesCount);
		seriesCount = seriesCount;
		for (n = 0; n < seriesCount; n++) {
			print("Opening - " + current_file + " position" + (n+1));
			processFile(output, n+1);
		}
	}
}

end_time = getTime();
runtime(start_time, end_time);

// functions
function processFile(output, n) {
	// macro code here
	run("Bio-Formats Importer", "open=["+path_current+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_" + n);
	name = getTitle();
	name = substring(name, 0, indexOf(name, "."));
	name = name + "position_" + n;
	//print(name);
	saveAs("Tiff", output + File.separator + name + ".tif");
	close("*");
}


function runtime(start_time, end_time) { 
	// print time in minutes and seconds
	total_time = end_time - start_time;
	minutes_remanider = total_time % (60 * 1000);
	minutes = (total_time - minutes_remanider) / (60 * 1000);
	seconds = minutes_remanider / 1000;
	print("Macro runtime was " + minutes + " minutes and " + seconds + " seconds.");
}

