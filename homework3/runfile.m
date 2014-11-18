im1 = rgb2gray(imread('Data/view1.png'));
im2 = rgb2gray(imread('Data/view5.png'));
grnd1 = imread('Data/disp1.png');
grnd2 = imread('Data/disp5.png');

% Block Matching
bDraw = false;
blocksize = 12;
fprintf('============== Computing disp1 =================\n')
[disp1,err1] = BlockMatch(im1, im2, grnd1, blocksize, bDraw);
fprintf('============== Computing disp2 =================\n')
[disp2,err2] = BlockMatch(im2, im1, grnd2, blocksize, bDraw);


%% Consistency Check on the computed disparity maps
disp1Check = ConsistencyCheck(disp1, im1, im2);
disp2Check = ConsistencyCheck(disp2, im2, im1);

% Compute new MSE values
newErr1 = imMse(disp1Check, grnd1);
newErr2 = imMse(disp2Check, grnd2);

fprintf('newErr1 = %f\nnewErr2 = %f\n', newErr1, newErr2)

figure
subplot(2,2,1), imshow(disp1, [])
subplot(2,2,2), imshow(disp2, [])
subplot(2,2,3), imshow(disp1Check, []), title('Disparity Map 1 (After Consistency Check)')
subplot(2,2,4), imshow(disp2Check, []), title('Disparity Map 2 (After Consistency Check)')