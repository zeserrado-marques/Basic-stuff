/*
 * Macro to count phytoplankton on a single image. Works only in an open image.
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
img = getTitle();
img_name = File.getNameWithoutExtension(img);
run("Set Measurements...", "area mean standard perimeter fit shape redirect=" + img + " decimal=4");
getPixelSize(unit, pixelWidth, pixelHeight);

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

// calibrate binary image
Stack.setXUnit(unit);
run("Properties...", "pixel_width=" + pixelWidth + " pixel_height=" + pixelHeight);

// analyze particles
run("Analyze Particles...", "size=20-Infinity circularity=0.70-1.00 show=Masks display exclude clear summarize add");
mask_img = getTitle();

n = roiManager("count");
for (i = 0; i < n; i++) {
	roiManager("select", i);
	roiManager("rename", "phyto_" + (i+1));
	setResult("Image Name", i, img_name + "_phyto_" + (i+1));
}

selectWindow(img);



