# go to https://syn.mrc-lmb.cam.ac.uk/acardona/fiji-tutorial/ to follow along the tutorial

from ij import IJ
from ij.io import FileSaver
import os
from os import path

# empties the log window
IJ.log("\\Clear")
# creates instance of imagePlus object of active image
# imp points to the active image
imp = IJ.getImage()

# get image name
img_name = imp.getTitle()
# string slicing baby
img_name = img_name[:img_name.find(".png")]

# save the image
# create a FileSaver instance with "imp" as its parameter 
fs = FileSaver(imp)
# call function save on the filesaver instance. to save the parameter it has within
# it goes to the last directory used to save (or open? maybe the last acessed directory)
#fs.save()

# we can write the folder + filename where we want to save the image as a parameter for any of the save methods FileSaver has.
# be wary that this overwrites the file
save_folder = r"find/another/path/getter"
#save_file = save_folder + os.sep + img_name + ".tif"
#fs.saveAsTiff(save_file)

# let's write if statments to prevent that
if path.exists(save_folder) and path.isdir(save_folder):
	IJ.log("path exists: " + save_folder)
	file_path = path.join(save_folder, img_name + ".tif") # os specific
	if path.exists(file_path):
		IJ.log("already exists. not saving anything")
	elif fs.saveAsTiff(file_path): # this function returns true if it was able to save
		IJ.log(img_name + " was saved as a tif");
else:
	IJ.log("no folder. kanashi :(")
	
	