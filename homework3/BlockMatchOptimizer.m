im1 = rgb2gray(imread('Data/view1.png'));
im2 = rgb2gray(imread('Data/view5.png'));
grnd1 = imread('Data/disp1.png');
grnd2 = imread('Data/disp5.png');

% rescaled versions
scalingFactor = 1/5;
im1_scaled = imresize(im1, scalingFactor );
im2_scaled = imresize(im2, scalingFactor );
grnd1_scaled = imresize(grnd1, scalingFactor );
grnd2_scaled = imresize(grnd2, scalingFactor );

OptimizeBlockSize('1vs2', im1, im2, grnd1);
%OptimizeBlockSize('1vs2', im1, im2, grnd1);