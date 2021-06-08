import time

def calc_fwhm(criterion, NA, wavelength):
	fwhm = (criterion * (wavelength / 1000)) / NA
	nyquist = fwhm / 2.5
	return fwhm, nyquist

# get criterion for resolution formula
criterion = input('widefield (1) or confocal (2)? -  ')
if criterion == '1':
	criterion = 0.61
elif criterion == '2':
	criterion = 0.4
else:
	print('error. ending script. lols')
	time.sleep(2.5)
	quit()

# get wavelength
wave = int(input('wavelength: '))

# get NA to measure
# uncomment if you want something hard-coded
# NA_array = [0.085, 0.3, 0.8, 1.1, 1.4]
NA_array = []
while True:
	na_input = input('Enter here the NA (enter "n" to end it): ')
	if na_input == 'n':
		break
	else:
		NA_array.append(float(na_input))

for NA in NA_array:
    resolution, sampling = calc_fwhm(criterion, NA, wave)
    print(f"For {NA} NA:\nfwhm = {round(resolution, 3)} µm and nyquist = {round(sampling, 3)} µm")

while True:
	end = input('Close? (y/n): ')
	if end == 'y':
		break
	else:
		print('Okay big shot. Now what? This code is will loop forever on this part. \nlols \n')

