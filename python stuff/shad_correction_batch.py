import os
import glob
from aicsimageio import AICSImage
import tifffile

def openImageXY(image_path):
    # returns the img array
    image = AICSImage(image_path, reader=AICSImage.ReaderClass)
    img_data = image.get_image_data('YX')
    return img_data

def openImageZYX(image_path):
    # returns the img array
    image = AICSImage(image_path, reader=AICSImage.ReaderClass)
    img_data = image.get_image_data()
    return img_data

def processFolder(parent_dir, output_dir, mean_multiplier):
    #print(parent_dir)
    list_files = glob.glob(f'{parent_dir}*')
    for path_current in list_files:
        current_file = os.path.basename(path_current)
        #print(path_current)
        if os.path.isdir(path_current):
            # add the subfolder to the output path
            output_current = output_dir + current_file
            print(f'going inside {path_current}')
            processFolder(path_current + os.sep, output_current + os.sep, mean_multiplier)
        else:
            if path_current.endswith('.tif') or path_current.endswith('.TIF'):
                if not os.path.isdir(output_dir):
                    os.makedirs(output_dir)

                print(f'opening {path_current}')
                processFile(path_current, output_dir, mean_multiplier)

def processFile(file_path, save_path, mean_multiplier):
    ''' Does the shading correction for each image'''
    filename = os.path.basename(file_path)
    current_image = openImageZYX(file_path)
    bit_depth = current_image.dtype
    z_stack, t, c, y, x = current_image.shape
    # correct shading for each z plane
    for zed in range(z_stack):
        current_image[zed] = current_image[zed] * mean_multiplier
    
    current_image = current_image.astype(bit_depth)
    current_image = current_image.reshape(z_stack, y, x)

    # save image in output folder
    print(f'saving in {save_path + filename}')
    tifffile.imwrite(save_path + filename, current_image, imagej=True, metadata={'axes': 'ZYX'} )

# runs the processing
if __name__ == '__main__':
    # user input. basically paths
    flatfield_path = input('Shading reference file path: ')
    images_dir = input('top folder with all images: ')

    # create path names
    name_output = os.path.basename(images_dir) + '_processed'
    output = os.path.join(images_dir, os.pardir)
    output = os.path.abspath(output) + os.sep + name_output

    # get shading multiplier matrix
    shade_img_data = openImageXY(flatfield_path)
    shading_multiplier = shade_img_data.mean() / shade_img_data

    processFolder(images_dir + os.sep, output + os.sep, shading_multiplier)

