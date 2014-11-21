% parameters
interp = 0.5;   % interpolation factor of 0.5 should give a virtual view exactly at the center of line connecting both the cameras. can vary from 0 (left view) to 1 (right view)

% read in images and disparity maps
i1 = imread('Data\view1.png');           % left view
i2 = imread('Data\view5.png');           % right view
d1 = double(imread('Data\disp1.png'));   % left disparity map, 0-255
d2 = double(imread('Data\disp5.png'));   % right disparity map, 0-255

% tag bad depth values with NaNs
d1(d1==0) = NaN;
d2(d2==0) = NaN;

% Assume all images are the same size
[rows,cols,layers] = size(i1);
synth = zeros(rows,cols,layers, 'uint8');

for r = 1:rows
    for c = 1:cols
        offset1 = uint16(interp * d1(r,c));
        offset2 = uint16(interp * d2(r,c));
        
        if c - offset1 >= 1
            synth(r,c-offset1,:) = i1(r,c,:);
        end
        if c + offset2 <= cols && sum(synth(r,c+offset2,:)) == 0
            synth(r,c+offset2,:) = i2(r,c,:);
        end
    end
end

imshow(synth)

% Compute error
grnd = imread('Data\view3.png');
mseErr = imMse(grnd,synth);

fprintf('MSE error is %f\n', mseErr);