# statistics
from ij import IJ  
from ij.process import ImageStatistics as IS

# get imagePlus and ImageProcessor (here pixel data is stored)
imp = IJ.getImage()
image_processor = imp.getProcessor()

print IS.MEAN
