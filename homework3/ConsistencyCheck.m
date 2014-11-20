function [ disp1 ] = ConsistencyCheck( disp1, disp2, bRight )
%CONSISTENCYCHECK Does consistency check on disparity maps.
%   Detailed explanation goes here

[rows,cols] = size(disp1);
for r = 1:rows
    for c = 1:cols

        % position of pixel (r,c) in right image according to disp1
        if bRight
            x_r = c + disp1(r,c);
        else
            x_r = c - disp1(r,c);
        end
        
        % Back-project using disp2. Note that it is possible for x_r to be
        % out of bounds if disp1 was in error.
        if x_r <= cols && x_r >= 1
            if bRight
                x_l = x_r - disp2(r,x_r);
            else
                x_l = x_r + disp2(r,x_r);
            end
        else
            x_l = NaN;
        end
        
        % If back-projected position is not equal to THIS pixel, then there
        % must have been an error due to occlusion.
        if c ~= x_l
            disp1(r,c) = NaN;
        end
    end
end

end

