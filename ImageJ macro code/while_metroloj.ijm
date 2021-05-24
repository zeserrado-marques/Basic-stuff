/*
 * Macro to facilitate PSF measurement with metroloJ. PSF iamge needs to be open
 * Currently works only for single channel images.
 * 
 * Dependencies:
 * - MetroloJ
 * - iText library v2.1.4
 * 
 * Soon to come:
 * - measure for different channels
 * 
 * 
 * MetroloJ - https://imagejdocu.tudor.lu/plugin/analysis/metroloj/start
 * 
 * Author: José Serrado Marques
 * Date: 2021/05
 * 
 * My advice:
 * - Create a folder a priori with the month of the measurement. example: "2021-05"
 * - Have a good image file name. example: "PS-speck_100x". Macro will add wavelength name to the final PDF file
 * 
 */
print("\\Clear");
imgID = getImageID();

// dialog box, because Script Parameters were not working for me
items = newArray("WideField", "Confocal");
items2 = newArray("25x", "40x", "50x", "60x", "63x", "100x");
Dialog.create("PSF Settings");
Dialog.addChoice("Microscope Type", items, items[1]);
Dialog.addNumber("Wavelength", 510);
Dialog.addNumber("NA", 1.4);
Dialog.addChoice("Objective", items2, items2[4]);
Dialog.show();

// variables
mic_type = Dialog.getChoice();
wavelength = Dialog.getNumber();
num_ape = Dialog.getNumber();
objective = Dialog.getChoice();
psf_number = 1;

// paths
input = getDir("folder to save PSF info PDFs");
output = input + File.separator + objective;
File.makeDirectory(output);
selectImage(imgID);

// user selects bead to measure PSF. yellow ROI is current bead, red ROIs are measured beads
start_while = true;
while (start_while) {
	if (psf_number == 1) {
		getDimensions(width, height, channels, slices, frames);
		setSlice(slices / 2);
		makeRectangle(width / 2, height / 2, 69, 69);
		run("Select None");
	}
	run("Restore Selection");
	Roi.setStrokeColor("yellow");
	waitForUser("PSF Measurement", "Draw a ROI over the PSF.\n \nMeasured beads: " + psf_number - 1 + "\n \nNo selection to end.");
	getSelectionBounds(x, y, width, height);
	if (x != 0 || y != 0) {
		// code to measure the beads
		print("ROI detected. Measuring PSF number " + psf_number);
		
		runPSFmeasureBaby(psf_number, wavelength, num_ape, mic_type, output);
		
		// pretty rois as overlay to see calculated beads
		Overlay.addSelection("red");
		run("Select None");
		Overlay.show;
		psf_number++;
	} else {
		// gtfo of the macro
		print("No ROI detected. Ending macro");
		selectWindow("Log");
		start_while = false;
	}
}


function runPSFmeasureBaby(psf_number, wavelength, num_ape, mic_type, output) {
	// run code to prepare bead for metroloj	
	org_name = getTitle();
	final_name = substring(org_name, 0, lastIndexOf(org_name, "."));
	run("Duplicate...", "duplicate");
	wave_name =  "wavelength" + wavelength + "_" + final_name + "_bead_" + psf_number;
	rename(wave_name);
	run("Generate PSF report", "microscope=" + mic_type + " wavelength=" + wavelength + " na=" + num_ape + " pinhole=1 text1=[Sample infos:\n] text2=Comments:\n scale=5 save=[" + output + File.separator + wave_name + ".pdf]");
	selectWindow(org_name);
	close("\\Others");
}


