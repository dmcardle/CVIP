function  height_map = get_surface(surface_normals, image_size)
% surface_normals: h x w x 3 array of unit surface normals
% image_size: [h, w] of output height map/image
% height_map: height map of object of dimensions [h, w]

height_map = zeros(image_size);
    
%% <<< fill in your code below >>> 

% for each pixel in the left column of the height map
for h = 1:image_size(1)
    if h == 1
        prev_height_value = 0;
    else
        prev_height_value = height_map(h-1, 1);
    end
    q = surface_normals(h,1,2) / surface_normals(h,1,3);
    height_map(h,1) = prev_height_value + q;
end

% for each row
for h = 1:image_size(1)
    % for each element of the row except for leftmost
    for w = 2:image_size(2)
        p = surface_normals(h,w,1) / surface_normals(h,w,3);
        height_map(h,w) = height_map(h,w-1) + p;
    end
end

end

