from ij import IJ
from ij import WindowManager as WM

def findMipName(str1, str2):
	return str1 if str1.find("MAX_") > -1 else str2

# get all images
images = map(WM.getImage, WM.getIDList())

# gets titles and turns them into a string. getImageTitles returns a unicode element
lst_titles = map(str, WM.getImageTitles())

# get image name with "MAX_"
mip_name = reduce(findMipName, lst_titles)


IJ.selectWindow(mip_name)

