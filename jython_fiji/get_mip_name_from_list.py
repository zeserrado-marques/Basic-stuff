from ij import IJ
from ij import WindowManager as WM

# get all images
images = map(WM.getImage, WM.getIDList())

# gets titles and turns them into a string. getImageTitles returns a unicode element
lst_titles = map(str, WM.getImageTitles())

# get image name with "MAX_"
mip_name = reduce(lambda x, y: x if x.find("MAX_") > -1 else y, lst_titles)


IJ.selectWindow(mip_name)

