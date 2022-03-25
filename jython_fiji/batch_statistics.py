from ij import IJ
from ij.process import ImageStatistics as IS
import os

# define statistics options to get
options = IS.MEAN | IS.MEDIAN | IS.MIN_MAX

def getStatistics(imp):
  """ Return statistics for the given ImagePlus """
  ip = imp.getProcessor()
  stats = IS.getStatistics(ip, options, imp.getCalibration())
  return stats.mean, stats.median, stats.min, stats.max


# Folder to read all images from:
folder = r"G:\zemarques\user_images\carolinaPereira"

# Get statistics for each image in the folder
# whose file extension is ".tif":
for filename in os.listdir(folder):
	if filename.endswith(".tif"):
		# open current image and get its ImagePlus
		path_current = os.path.join(folder, filename)
		current_imp = IJ.openImage(path_current)
		if current_imp is None:  
   			print "Could not open image from file:", filename  
			continue  
		media, mediana, minimo, maximo = getStatistics(current_imp)
		print current_imp.title, media, mediana, minimo, maximo
	else:
		print "not a tif ->", filename

