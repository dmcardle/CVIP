function [ disp1 ] = ConsistencyCheck( disp1, disp2 )
%CONSISTENCYCHECK Does consistency check on disparity maps.
%   Detailed explanation goes here


[rows,cols] = size(disp1);
for r = 1:rows
    for c = 1:cols

        % position of pixel (r,c) in right image according to disp1
        x_r = c + disp1(r,c);
        
        % back-project using disp2
        x_l = x_r - disp2(r,c);
        
        % if back-projected position is not equal to THIS pixel...
        if c ~= x_l
            disp1(r,c) = NaN;
        end
    end
end

end

