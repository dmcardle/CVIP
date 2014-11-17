function [ mseVec ] = OptimizeBlockSize( label, im1, im2, grnd )
%OPTIMIZEBLOCKSIZE Summary of this function goes here
%   Detailed explanation goes here

bDraw = false;

mseVec = [];
blocksizeVec = [];
dMaps = {};

startBlocksize = 14;
endBlocksize = 14;
stepBlocksize = 2;

allBlocksizes = startBlocksize:stepBlocksize:endBlocksize;
[~, numBlocksizes] = size(allBlocksizes);

parfor i = 1:numBlocksizes
    
    blocksize = allBlocksizes(i);
    fprintf('====== Trying blocksize %d =======\n', blocksize);
    
    [disparityMap, err] = BlockMatch(im1, im2, grnd, blocksize, bDraw);
    
    mseVec(i) = err;
    blocksizeVec(i) = blocksize;
    dMaps{i} = disparityMap;
end


% determine best error
[minErr, idxBest] = min(mseVec);
bestBlocksize = blocksizeVec(idxBest);
bestDispMap = dMaps{idxBest};


fprintf('>>> %s: best block size is %d\n', label, bestBlocksize);

figure
title(sprintf('%s: MSE vs Blocksize', label))
plot(allBlocksizes, mseVec)
figure
imshow(dMaps{bestBlocksize}, []);


end

