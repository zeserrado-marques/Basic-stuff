from ij import IJ
from ij import WindowManager as WM
from ij.plugin import ZProjector

raw_img = IJ.getImage()

# MIP
max_project = ZProjector.run(raw_img, "max all")
max_project.show()
IJ.run("Enhance Contrast", "saturated=0.35")

