MODE_DATA = 0;
MODE_EVAL_BOOKS = 1;
MODE_EVAL_DOLLS = 2;
MODE_EVAL_REINDEER = 3;

mode = MODE_DATA;
debug = true;

if mode == MODE_DATA
    path = 'Data/';
elseif mode == MODE_EVAL_BOOKS
    path = 'Evaluation/Books/';
elseif mode == MODE_EVAL_DOLLS
    path = 'Evaluation/Dolls/';
elseif mode == MODE_EVAL_REINDEER
    path = 'Evaluation/Reindeer/';
end

im1 = rgb2gray(imread([path 'view1.png']));
im2 = rgb2gray(imread([path 'view5.png']));
grnd1 = imread([path 'disp1.png']);
grnd2 = imread([path 'disp5.png']);

if debug
    scale = 0.5;
    im1 = imresize(im1, scale);
    im2 = imresize(im2, scale);
    grnd1 = imresize(grnd1, scale) .* scale;
    grnd2 = imresize(grnd2, scale) .* scale;
end

%% Block Matching
bDraw = false;
blocksize = 10;
fprintf('blocksize = %d\n', blocksize)
fprintf('============== Computing disp1 =================\n')
[disp1,err1] = BlockMatch(im1, im2, grnd1, blocksize, bDraw, false);
fprintf('============== Computing disp2 =================\n')
[disp2,err2] = BlockMatch(im2, im1, grnd2, blocksize, bDraw, true);


%% Consistency Check on the computed disparity maps
disp1Check = ConsistencyCheck(disp1, disp2, false);
disp2Check = ConsistencyCheck(disp2, disp1, true);

% Compute new MSE values
newErr1 = imMse(disp1Check, grnd1);
newErr2 = imMse(disp2Check, grnd2);

fprintf('newErr1 = %f\nnewErr2 = %f\n', newErr1, newErr2)

figure
subplot(2,2,1), imshow(disp1, [])
subplot(2,2,2), imshow(disp2, [])
subplot(2,2,3), imshow(disp1Check, []), title('Disparity Map 1 (After Consistency Check)')
subplot(2,2,4), imshow(disp2Check, []), title('Disparity Map 2 (After Consistency Check)')


%% Dynamic Programming

disp1 = DynamicProg(im1, im2);

grnd1Max = max(grnd1(:));
grnd2Max = max(grnd2(:));
figure
subplot(2,1,1), imshow(disp1, [0 grnd1Max])

err = imMse(disp1, grnd1);
fprintf('DP Error 1 to 2 is %f\n', err);


disp2 = DynamicProg(im2, im1);
subplot(2,1,2), imshow(disp2, [0 grnd2Max])

err = imMse(disp2, grnd2);
fprintf('DP Error 2 to 1 is %f\n', err);