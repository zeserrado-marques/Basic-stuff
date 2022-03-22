from ij import IJ, ImagePlus

imp = IJ.getImage()

# print image name
print imp.title

# print other info
print "width:", imp.width  
print "height:", imp.height  
print "number of pixels:", imp.width * imp.height  
print "number of slices:", imp.getNSlices()  
print "number of channels:", imp.getNChannels()  
print "number of time frames:", imp.getNFrames() 

# imp.type returns an integer. might be a specific ID for it. 
# ex, 4 is the ID for RGB. ImagePlus.COLOR_RGB returns 4.
types = {ImagePlus.COLOR_RGB : "RGB",  
         ImagePlus.GRAY8 : "8-bit",  
         ImagePlus.GRAY16 : "16-bit",  
         ImagePlus.GRAY32 : "32-bit",  
         ImagePlus.COLOR_256 : "8-bit color"}  

print "image type:", types[imp.type], imp.type