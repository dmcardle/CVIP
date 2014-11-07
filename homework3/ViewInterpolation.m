% parameters
interp = 0.5;   % interpolation factor of 0.5 should give a virtual view exactly at the center of line connecting both the cameras. can vary from 0 (left view) to 1 (right view)

% read in images and disparity maps
i1 = imread('Data\view1.png');           % left view
i2 = imread('Data\view5.png');           % right view
d1 = double(imread('Data\disp1.png'));   % left disparity map, 0-255
d2 = double(imread('Data\disp5.png'));   % right disparity map, 0-255

% tag bad depth values with NaNs
d1(d1==0) = NaN;
d2(d2==0) = NaN;



















