function [albedo_image, surface_normals] = photometric_stereo(imarray, light_dirs)
% imarray: h x w x Nimages array of Nimages no. of images
% light_dirs: Nimages x 3 array of light source directions
% albedo_image: h x w image
% surface_normals: h x w x 3 array of unit surface normals

%% <<< fill in your code below >>>

    % create 2D zero matrices of the correct size
    [m n d] = size(imarray);
    albedo_image = zeros(m, n);
    surface_normals = zeros(m, n, 3);

    for x = 1:size(imarray,1)
        for y = 1:size(imarray,2)
            i = squeeze(imarray(x,y,:));

            % X = linsolve(A,B) solves AX = B
            % We are solving i(x,y) = Vg(x,y)
            g = light_dirs\i;
            
            albedo_image(x,y) = sqrt( sum( g.^2 ) );
            surface_normals(x,y,:) = g / albedo_image(x,y);
        end
    end

end

