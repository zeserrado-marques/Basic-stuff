# Basic-stuff
Basic scripts in python and imageJ macro language

## Python
**Download pdfs from url inside a pdf**
- Contains code used to download pdfs from the web, using urls inside a pdf file as an input


## ImageJ Macro
### CziToTiff_macro.ijm

Script that saves .czi image files as .tif files

### CziToTiff_multiple_positions.ijm

Convert .czi into .tif. For big data, use ZEN software to do this. Make sure to have all .czi files in a single folder/directory. Works only for split positions

### MIP_concat_timeseries_for_positions.ijm

Script that opens a single position from a .czi file and does a Maximum intensity projection (MIP) and concatenates images into a single file as a time series. Does this for how many positions you want.

### while_metroloj.ijm

Macro to facilitate PSF measurement with MetroloJ
(PSF image needs to be open in ImageJ). Currently works only for single channel images.

Soon to come:
- measure for different channels

My advice:
- Create a folder a priori with the month of the measurement. example: "2021-05"
- Have a good image file name. example: "PS-speck_100x". Macro will add wavelength name to the final PDF file.
