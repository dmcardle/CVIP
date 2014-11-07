
%Write a script that processes stereo image pair to generate disparity map
%using basic block matching

im1 = imread('Data/view1.png');
im2 = imread('Data/view5.png');


if (size(im1) ~= size(im2))
    error('Images must be the same size');
end

[rows, cols, layers] = size(im1);
disparityMap = zeros( rows, cols );

blocksize = 10;
max_offset = 10;

for r=1:rows
    
    if (mod(r,3) == 0)
        % Report the current progress
        fprintf('%.2f%%\n', 100 * r / rows);
    end
    
    for c=1:cols

        % r, c are in terms of pixels
        % convert to be in terms of blocks
        

        if (r+blocksize > rows || c + blocksize > cols)
            continue
        end
        
        block1 = im1( r:r+blocksize, ...
                     c:c+blocksize, ...
                     :);

        % Determine the best alignment between block1 and block2 within the
        % range defined by max_offset.
        bestSsd = Inf;
        bestOffset = [Inf, Inf];
        
        for deltaR = -max_offset:max_offset
            for deltaC = -max_offset:max_offset

                %fprintf('r = %d, c = %d, dR = %d, dC = %d\n', r, c, deltaR, deltaC);
                %fprintf('%d\n', c + deltaC + 1);
                
                % check if it will be possible to get a block before
                % attempting to
                if ~(r+deltaR >= 1 && c+deltaC >= 1 ...
                   && (r+deltaR+blocksize <= rows && c+deltaC+blocksize <= cols))
               
                    continue
                end
               
                block2 = im2(r+deltaR:r+deltaR+blocksize, ...
                            c+deltaC:c+deltaC+blocksize, ...
                            :);

                sd = (block1 - block2) .^ 2;
                ssd = sum(sum(sum(sd)));

                if ssd < bestSsd
                    bestSsd = ssd;
                    bestOffset = [deltaR, deltaC];
                end

            end
        end

        % Compute this point's disparity value based on the best offset.
        disparityValue = sqrt(sum(bestOffset.^2));
        disparityMap(r,c) = disparityValue;
    end
end

imshow(disparityMap, []);






























%imshow(Disparity,[]), axis image, colormap('jet'), colorbar;
%caxis([0 disparityRange]);
%imwrite('DisparityBasic.png', Disparity);