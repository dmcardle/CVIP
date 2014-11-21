function [ err ] = imMse( im1, grnd )
%IMMSE Summary of this function goes here
%   Detailed explanation goes here

grnd = double(grnd);
im1 = double(im1);

[rows,cols] = size(im1);

sd = (im1(:) - grnd(:)).^2;
err = (1 / (rows*cols)) * sum(nansum(sd));

end

