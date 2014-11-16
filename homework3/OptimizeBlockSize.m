function [ output_args ] = OptimizeBlockSize( label, im1, im2, grnd )
%OPTIMIZEBLOCKSIZE Summary of this function goes here
%   Detailed explanation goes here

bDraw = false;

dMaps = {};

bestErr = Inf;
bestBlocksize = Inf;

mse = [];
i=1;
allBlocksizes = 4:4:20;
for blocksize = allBlocksizes
    [disparityMap, err] = BlockMatch(im1, im2, grnd, blocksize, bDraw);
    
    if err < bestErr
        bestErr = err;
        bestBlocksize = blocksize;
    end
    
    mse(i) = err;
    i = i+1;
    dMaps{blocksize} = disparityMap;
end

fprintf('>>> %s: best block size is %d\n', label, bestBlocksize);

figure
title(sprintf('%s: MSE vs Blocksize', label))
plot(allBlocksizes, mse)

imwrite(dMaps{bestBlocksize}, [label '.png'], 'png');


end

