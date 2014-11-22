function [ allBlocksizes, bestBlocksize, minErr, mseVec, bestDispMap ] = OptimizeBlockSize( label, im1, im2, bRight, grnd, from, step, to )
%OPTIMIZEBLOCKSIZE Summary of this function goes here
%   Detailed explanation goes here

bDraw = false;

mseVec = [];
blocksizeVec = [];
dMaps = {};

startBlocksize = from;
stepBlocksize = step;
endBlocksize = to;

allBlocksizes = startBlocksize:stepBlocksize:endBlocksize;
[~, numBlocksizes] = size(allBlocksizes);

for i = 1:numBlocksizes
    
    blocksize = allBlocksizes(i);
    fprintf('====== Trying blocksize %d =======\n', blocksize);
    
    [disparityMap, err] = BlockMatch(im1, im2, grnd, blocksize, bDraw, bRight);
    
    mseVec(i) = err;
    blocksizeVec(i) = blocksize;
    dMaps{i} = disparityMap;
end


% determine best error
[minErr, idxBest] = min(mseVec);
bestBlocksize = blocksizeVec(idxBest);
bestDispMap = dMaps{idxBest};


end

