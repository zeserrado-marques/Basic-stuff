# REDO ALL OF THIS WITH AN OBJECT. AND MAYBE USE A WRAPPER

import os
import glob
import numpy as np
import re
import skimage.io
import matplotlib.pyplot as plt
import tifffile

def openzeds(img_list, zeds, xy_index, img_shape, data_type):
    '''for each xy, opens all the zeds of that image and creates a dict'''

    z_stack = np.zeros(img_shape, data_type)
    #z_stack_dict = dict()
    for z in range(zeds):
        # z_key = re.findall('(xy\d+z\d+)', img_list[z + xy_index])[0]
        #z_stack_dict[z_key] = skimage.io.imread(img_list[z + xy_index])

        # assign to each plane the corresponding image
        z_stack[z,...] = tifffile.imread(img_list[z + xy_index])
    
    return z_stack

# input path, pixel and voxel size
path = input('insert path to folder with images: ')
if path == '':
    path = 'G:\\zemarques\\user_images\\Nuria\\export'
try:
    pixelsize, voxeldepth = map(float, (input('insert pixel size and voxel depth, seperated by a space: ').split(' ')))
except:
    pixelsize, voxeldepth = (0.0646893, 0.2)
    print(f'pixel size will be {pixelsize} and voxel depth {voxeldepth}')

img_list = glob.glob(path + os.sep + '*.tif')

# create output dir
parent_dir = os.path.dirname( os.path.dirname(img_list[0]) )
output = parent_dir + os.sep + 'concat'
if not os.path.isdir(output):
    os.mkdir(output)

# gets the number of positions (total_xy) and planes (zeds)
total_xy = int(re.findall('xy(\d+)', img_list[-1])[0])
zeds = int(re.findall('z(\d+)', img_list[-1])[0])

# gets the name of the file from the full path
image_name =  os.path.basename(re.findall('(.*)xy\d+z\d+', img_list[-1])[0])

# get shape and data type
sample_image = tifffile.imread(img_list[0])
desired_shape = (zeds,) + sample_image.shape
data_type = sample_image.dtype


# save z_stack for each position 
for xy in range(total_xy):
    xy_index = xy * zeds
    z_stack = openzeds(img_list, zeds, xy_index, desired_shape, data_type)
    fname = output + os.sep + image_name + f'_position{xy+1}.tif'
    tifffile.imwrite(fname, z_stack, imagej=True, resolution=(1./pixelsize, 1./pixelsize), metadata={'spacing': voxeldepth, 'unit': 'um', 'axes': 'ZCYX'} )

# visualization with matplotlib
#hi = skimage.io.imread(img_list[14])
yo = tifffile.imread(img_list[14])
#print(hi.shape)
print(yo.shape)

plt.imshow(yo[3, ...])
plt.show()
