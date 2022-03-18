# go to https://syn.mrc-lmb.cam.ac.uk/acardona/fiji-tutorial/ to follow along the tutorial

from ij import IJ
from ij.io import FileSaver
import os

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
save_folder = r"G:\zemarques\user_images\carolinaPereira"
save_file = save_folder + os.sep + img_name + ".tif"
fs.saveAsTiff(save_file)

# let's write if statments to prevent that
