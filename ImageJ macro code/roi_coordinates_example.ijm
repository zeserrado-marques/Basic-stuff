newImage("Untitled", "8-bit ramp", 500, 500, 1);
makeRectangle(141, 107, 162, 154);
Overlay.addSelection;
Overlay.show;

// Stack.setXUnit("um");
// run("Properties...", "channels=1 slices=1 frames=1 pixel_width=0.065 pixel_height=0.065 voxel_depth=0.065");
run("Set Measurements...", "area centroid shape limit redirect=None decimal=4");
img = getTitle();
Roi.getBounds(x, y, width, height);
Roi.getCoordinates(xpoints, ypoints);
print(xpoints.length);
for (i = 0; i < xpoints.length; i++) {
	print(xpoints[i]);
	print(ypoints[i]);
}
b = Roi.getProperties;
print(b);
getPixelSize(unit, pixelWidth, pixelHeight);
print(pixelWidth);

run("Measure");
centroid_x = getResult("X", 0) / pixelWidth;
centroid_y = getResult("Y", 0) / pixelHeight;
print(centroid_x);
print(centroid_y);
makeOval(centroid_x - 10, centroid_y - 10, 20, 20);
selectWindow(img);
