# statistics
from ij import IJ  
from ij.process import ImageStatistics as IS

# get imagePlus and ImageProcessor (here pixel data is stored)
imp = IJ.getImage()
image_processor = imp.getProcessor()

print IS.MEAN

# bitwise operation OR to generate a certain int value. This value will correspond to which kind of statistics we want to retrieve from the IS.getStatistics method.
options = IS.MEAN | IS.MEDIAN | IS.MIN_MAX
stats = IS.getStatistics(image_processor, options, imp.getCalibration())

print options, imp.title