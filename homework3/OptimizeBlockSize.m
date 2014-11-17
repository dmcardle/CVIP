function [ mseVec ] = OptimizeBlockSize( label, im1, im2, grnd )
%OPTIMIZEBLOCKSIZE Summary of this function goes here
%   Detailed explanation goes here

bDraw = false;

dMaps = {};

bestErr = Inf;
bestBlocksize = Inf;

mseVec = [];
i=1;
allBlocksizes = 14:14;

figure

for blocksize = allBlocksizes
    
    fprintf('====== Trying blocksize %d =======\n', blocksize);
    
    [disparityMap, err] = BlockMatch(im1, im2, grnd, blocksize, bDraw);
    imshow(disparityMap, []);
    
    if err < bestErr
        bestErr = err;
        bestBlocksize = blocksize;
    end
    
    mseVec(i) = err;
    i = i+1;
    dMaps{blocksize} = disparityMap;
end

fprintf('>>> %s: best block size is %d\n', label, bestBlocksize);

figure
title(sprintf('%s: MSE vs Blocksize', label))
plot(allBlocksizes, mseVec)
figure
imshow(dMaps{bestBlocksize}, []);


end

