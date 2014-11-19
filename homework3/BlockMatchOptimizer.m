
im1 = rgb2gray(imread('Data/view1.png'));
im2 = rgb2gray(imread('Data/view5.png'));
grnd1 = imread('Data/disp1.png');
grnd2 = imread('Data/disp5.png');

% rescaled versions
scalingFactor = 0.5;
im1_scaled = imresize(im1, scalingFactor );
im2_scaled = imresize(im2, scalingFactor );
grnd1_scaled = imresize(grnd1, scalingFactor );
grnd2_scaled = imresize(grnd2, scalingFactor );

%OptimizeBlockSize('1vs2', im1_scaled, im2_scaled, false, grnd2_scaled, 12, 2, 12);
%OptimizeBlockSize('2vs1', im2_scaled, im1_scaled, true, grnd2_scaled, 12, 2, 12);
OptimizeBlockSize('1 vs. 5', im1, im2, false, grnd1, 6, 6, 30);
%OptimizeBlockSize('5 vs. 1', im2, im1, grnd2, 12, 6, 24);
