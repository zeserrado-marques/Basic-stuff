/*
 * Macro to facilitate PSF measurement with metroloJ.
 * Currently works only for single channel images.
 * 
 * Dependencies:
 * - MetroloJ
 * - iText library v2.1.4
 * 
 * Soon to come:
 * - user input
 * - measure for different channels
 * 
 * 
 * MetroloJ - https://imagejdocu.tudor.lu/plugin/analysis/metroloj/start
 * 
 * Author: José Serrado Marques
 * Date: 2021/05
 * 
 * 
 */

print("\\Clear");

// variables
psf_number = 1;
num_ape = 1.4;
objective = "63x";
wavelength = 510;

// paths
input = getDir("folder to save PSF info PDFs");
output = input + File.separator + objective;
File.makeDirectory(output);

// user selects bead to measure PSF. yellow ROI is current bead, red ROIs are measured beads
start_while = true;
while (start_while) {
	if (psf_number == 1) {
		makeRectangle(50, 50, 69, 69);
		run("Select None");
	}
	run("Restore Selection");
	Roi.setStrokeColor("yellow");
	waitForUser("PSF Measurement", "Draw a ROI over the PSF.\n \nMeasured beads: " + psf_number - 1 + "\n \nNo selection to end.");
	getSelectionBounds(x, y, width, height);
	if (x != 0 || y != 0) {
		// code to measure the beads
		print("ROI detected. Measuring PSF number " + psf_number);
		
		runPSFmeasureBaby(psf_number, wavelength, num_ape, output);
		
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


function runPSFmeasureBaby(psf_number, wavelength, num_ape, output) {
	// run code to prepare bead for metroloj	
	org_name = getTitle();
	final_name = substring(org_name, 0, lastIndexOf(org_name, "."));
	run("Duplicate...", "duplicate");
	wave_name =  "wavelength" + wavelength + "_zebra_" + final_name + "_bead_" + psf_number;
	rename(wave_name);
	run("Generate PSF report", "microscope=Confocal wavelength=" + wavelength + " na=" + num_ape + " pinhole=1 text1=[Sample infos:\n] text2=Comments:\n scale=5 save=[" + output + File.separator + wave_name + ".pdf]");
	selectWindow(org_name);
	close("\\Others");
}


