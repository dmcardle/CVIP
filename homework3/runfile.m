MODE_DATA = 0;
MODE_EVAL_BOOKS = 1;
MODE_EVAL_DOLLS = 2;
MODE_EVAL_REINDEER = 3;

mode = MODE_EVAL_BOOKS;
debug = false;

if mode == MODE_DATA
    path = 'Data/';
elseif mode == MODE_EVAL_BOOKS
    path = 'Evaluation/Books/';
elseif mode == MODE_EVAL_DOLLS
    path = 'Evaluation/Dolls/';
elseif mode == MODE_EVAL_REINDEER
    path = 'Evaluation/Reindeer/';
end
outputPath = ['writeup/output/' path];
statsFile = fopen([outputPath 'stats.txt'], 'a');

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

%% Block Match Window Size Optimization
fprintf(statsFile, '\n\nBLOCK MATCH WINDOW SIZE OPTIMIZATION\n');

[ allBlocksizes, bestBlocksize, minErr, mseVec, bestDispMap ] = OptimizeBlockSize('1 vs. 5', im1, im2, false, grnd1, 6, 10, 26);

% output results
fprintf(statsFile, '==> 1 vs 5: best block size is %d\n', bestBlocksize);
fprintf(statsFile, '==> 1 vs 5: best error is %f\n', minErr);

f = figure
plot(allBlocksizes, mseVec)
title(sprintf('1 vs 5: MSE vs Blocksize'))
print(f, [outputPath 'mse_vs_blocksize.png'], '-dpng');


imshow(bestDispMap, [0 70]);
title(sprintf('1 vs 5: best disparity map'))
print(f, [outputPath 'best_dispmap.png'], '-dpng');



[ allBlocksizes, bestBlocksize, minErr, mseVec, bestDispMap ] = OptimizeBlockSize('5 vs. 1', im2, im1, true, grnd2, 6, 10, 26);

fprintf(statsFile, '==> 5 vs 1: best block size is %d\n', bestBlocksize);
fprintf(statsFile, '==> 5 vs 1: best error is %f\n', minErr);

figure
plot(allBlocksizes, mseVec)
title(sprintf('5 vs 1: MSE vs Blocksize'))
print(f, [outputPath 'mse_vs_blocksize.png'], '-dpng');


imshow(bestDispMap, [0 70]);
title(sprintf('5 vs 1: best disparity map'))
print(f, [outputPath 'best_dispmap.png'], '-dpng');



%% Block Matching
bDraw = false;
blocksize = 10;
fprintf('blocksize = %d\n', blocksize)
fprintf('============== Computing disp1 =================\n')
[disp1,err1] = BlockMatch(im1, im2, grnd1, blocksize, bDraw, false);
fprintf('============== Computing disp2 =================\n')
[disp2,err2] = BlockMatch(im2, im1, grnd2, blocksize, bDraw, true);

fprintf(statsFile, '\nBLOCK MATCHING\n  im1 -> im2 error = %d\n  im2 -> im1 error = %d\n', err1, err2);

disparityRange1 = max(grnd1(:));
f = figure;
imshow(disp1,[]),axis image, colormap('jet'), colorbar;
caxis([0 disparityRange1]);
print(f, [outputPath 'disp1.png'], '-dpng');

disparityRange2 = max(grnd2(:));
imshow(disp2,[]),axis image, colormap('jet'), colorbar;
caxis([0 disparityRange2]);
print(f, [outputPath 'disp2.png'], '-dpng');


%% Consistency Check on the computed disparity maps
disp1Check = ConsistencyCheck(disp1, disp2, false);
disp2Check = ConsistencyCheck(disp2, disp1, true);

% Compute new MSE values
newErr1 = imMse(disp1Check, grnd1);
newErr2 = imMse(disp2Check, grnd2);

fprintf(statsFile, '\nAFTER CONSISTENCY CHECK\nnewErr1 = %f\nnewErr2 = %f\n', newErr1, newErr2);

f = figure;
subplot(2,1,1), imshow(disp1Check, []), title('Disparity Map 1 (After Consistency Check)')
subplot(2,1,2), imshow(disp2Check, []), title('Disparity Map 2 (After Consistency Check)')
print(f, [outputPath 'after_consistency_check.png'], '-dpng');

%% Dynamic Programming

disp1 = DynamicProg(im1, im2);

grnd1Max = max(grnd1(:));
grnd2Max = max(grnd2(:));
f = figure;
subplot(2,1,1), imshow(disp1, [0 grnd1Max])

err1 = imMse(disp1, grnd1);
fprintf('DP Error 1 to 2 is %f\n', err1);

disp2 = DynamicProg(im2, im1);
subplot(2,1,2), imshow(disp2, [0 grnd2Max])

err2 = imMse(disp2, grnd2);
fprintf('DP Error 2 to 1 is %f\n', err2);

fprintf(statsFile, '\nDYNAMIC PROG\n  im1 -> im2 error = %d\n  im2 -> im1 error = %d\n', err1, err2);
print(f, [outputPath 'dynamic_prog.png'], '-dpng');
