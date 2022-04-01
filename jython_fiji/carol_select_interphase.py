from ij import IJ
from ij import WindowManager as WM
from ij.plugin import ZProjector

raw_img = IJ.getImage()

#imp_duplicated = new Duplicator().run(imp, 1, 1, 1, 26, 1, 40);
# mip_img = ZProjector.run(imp,"max all");

IJ.run("Z Project...", "projection=[Max Intensity] all")

mip_img = IJ.getImage()

