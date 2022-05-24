/*
 * Macro to remove autofluorescence from main signal channel.
 * Developed for Rui Oliveira's group at IGC
 * 
 * please cite: 
 *  - Li threshold paper - https://www.sciencedirect.com/science/article/pii/S0167865598000579?via%3Dihub
 *  - Fiji - https://www.nature.com/articles/nmeth.2019
 * 
 *  Please thank me in your acknowledgements. Many thanks :D
 *  
 * Author: José Serrado Marques
 * Mail: jpmarques@igc.gulbenkian.pt
 * Date: 2022/05/24
 */


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

// subtract autofluo from C2 image
imageCalculator("Subtract create", c2_duplicated, c3);
only_c2 = getTitle(); // binary iamge with, hopefully, only red cells
run("Fill Holes");


run("Create Selection");
selectWindow(c2);
run("Restore Selection");
run("Clear Outside");

run("Merge Channels...", "c1=" + c1 + " c2=" + c2 + " create");
Stack.setChannel(1);
run("Cyan");
Stack.setChannel(2);
run("Magenta");



// functions
function segmentStructures() {
	 run("Subtract Background...", "rolling=50");
	 run("Median...", "radius=3");
	 setAutoThreshold("Li dark");
	 run("Convert to Mask");
}

