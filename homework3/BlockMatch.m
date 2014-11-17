function [disparityMap,err] = BlockMatch(im1, im2, grnd, blocksize, bDraw)
%Write a script that processes stereo image pair to generate disparity map
%using basic block matching

%im1 = imread('Data/view1.png');
%im2 = imread('Data/view5.png');
%blocksize = 10;
%max_offset = 50;

halfblocksize = round(blocksize/2);

[rows_orig, cols_orig, ~] = size(im1);
im1 = padarray(im1, [halfblocksize halfblocksize], 'replicate');
im2 = padarray(im2, [halfblocksize halfblocksize], 'replicate');
[rows, cols, ~] = size(im1);

if (size(im1) ~= size(im2))
    error('Images must be the same size');
end

disparityMap = zeros(rows_orig, cols_orig);

if bDraw
    f = figure;
    hIm1 = subplot(2,2,1); imshow(im1);
    hIm2 = subplot(2,2,2); imshow(im2);
    hIm3 = subplot(2,2,3);
    hIm4 = subplot(2,2,4);
end



%block1 = zeros([blocksize, blocksize, 3]);
%block2 = zeros([blocksize, blocksize, 3]);

for r=halfblocksize+1:rows-halfblocksize
    
    if (mod(r,20) == 0)
        % Report the current progress
        fprintf('%.2f%%\n', 100 * r / rows);
    end
    
    for c=halfblocksize+1:cols-halfblocksize

        % r, c are in terms of pixels
        % convert to be in terms of blocks
        
        block1 = im1(r-halfblocksize+1:r+halfblocksize, ...
                     c-halfblocksize+1:c+halfblocksize, ...
                     :);

        % Determine the best alignment between block1 and block2 within the
        % range defined by max_offset.
        bestSsd = Inf;
        bestOffset = Inf; % value is irrelevant because it will be changed
        
        searchCoeff = 0.3;
        minC2 = max(halfblocksize+1, round(c - cols*searchCoeff));
        maxC2 = min(cols-halfblocksize, round(c + cols*searchCoeff));
        
        % draw rectangle on im1
        if bDraw
            if exist('hRect1')
                delete(hRect1);
            end
            hRect1 = rectangle('Parent', hIm1, 'Position', [c r 10 10], 'FaceColor', 'r');
            imshow(block1, 'Parent', hIm3);
        end
        
        %fprintf('for r=%d, c=%d, searching range (%d,%d)\n', r, c, minC2, maxC2);
        
        
        c2Range = [c:maxC2 minC2:c-1 ];
        for c2 = c2Range

            
            %fprintf('r = %d, c = %d, dR = %d, dC = %d\n', r, c, deltaR, deltaC);
            %fprintf('%d\n', c + deltaC + 1);

            block2 = im2(r-halfblocksize+1:r+halfblocksize, ...
                        c2-halfblocksize+1:c2+halfblocksize, ...
                        :);

            if bDraw
                if exist('hRect2')
                    delete(hRect2);
                end
                hRect2 = rectangle('Parent', hIm2, 'Position', [c2 r 10 10], 'FaceColor', 'r');
                imshow(block2, 'Parent', hIm4);

                imshow(block2);
                pause(0.0000001);
            end
            
            % squared differences matrix
            sd = (block1 - block2) .^ 2;
            ssd = sum(sd(:));

            if ssd < bestSsd
                if bDraw
                    fprintf('c2 - c = %d\n', c2-c);
                end
                bestSsd = ssd;
                bestOffset = abs(c2 - c);
            end

        end
        %end
        
        % Compute this point's disparity value based on the best offset.
        disparityMap(r-halfblocksize,c-halfblocksize) = bestOffset;
    end
end

if bDraw
    imshow(disparityMap, []);
end

fprintf('size of disparity map = %d\n', size(disparityMap))
fprintf('size of grnd = %d\n', size(grnd))

grnd = double(grnd);
sd = (disparityMap - grnd).^2;
err = (1 / rows*cols) * sum(sd(:));




%imshow(Disparity,[]), axis image, colormap('jet'), colorbar;
%caxis([0 disparityRange]);
%imwrite('DisparityBasic.png', Disparity);