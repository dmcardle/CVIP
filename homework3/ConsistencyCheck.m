function [ disp ] = ConsistencyCheck( disp, im1, im2 )
%CONSISTENCYCHECK Does consistency check on disparity maps.
%   Detailed explanation goes here

[rows,cols] = size(im1);
for r = 1:rows
    for c = 1:cols

        % There is an inconsistency if the pixel value from im1 cannot be
        % found at + or - offset. This is because the disparity value is an
        % absolute value.
        offset = disp(r,c);
        if ~(   (c+offset <= cols && im1(r,c) == im2(r,c+offset)) ...
             || (c-offset >= 1    && im1(r,c) == im2(r,c-offset)))
            
            disp(r,c) = NaN;
        end
    end
end

end

