% CSE 473/573 Programming Assignment 1, starter Matlab code
%% Credits: Arun Mallya and Svetlana Lazebnik

% path to the folder and subfolder
root_path = 'croppedyale/';
save_flag = 1; % whether to save output images

subject_names = {'yaleB01', 'yaleB02', 'yaleB05', 'yaleB07'};
for subject_name = subject_names

    subject_name = subject_name{1};
    
    %% load images
    full_path = sprintf('%s%s/', root_path, subject_name);
    [ambient_image, imarray, light_dirs] = LoadFaceImages(full_path, subject_name, 64);
    image_size = size(ambient_image);
    
    %% preprocess the data:
    
    %% subtract ambient_image from each image in imarray
    for i = 1:size(imarray,3)
        imarray(:,:,i) = imarray(:,:,i) - ambient_image;
    end
    
    %% make sure no pixel is less than zero
    
    % compare each element in imarray to zero -- choose the larger value
    imarray = max(imarray, 0);
    
    %% rescale values in imarray to be between 0 and 1
    imarray = imarray .* (1/255);
    
    %% <<< fill in your preprocessing code here (if any) >>>
    
    %% get albedo and surface normals (you need to fill in photometric_stereo)
    [albedo_image, surface_normals] = photometric_stereo(imarray, light_dirs);
    
    %% reconstruct height map (you need to fill in get_surface for different integration methods)
    height_map = get_surface(surface_normals, image_size);
    
    %% display albedo and surface
    h = display_output(albedo_image, height_map);
    
    %% plot surface normal
    plot_surface_normals(surface_normals);
    
    %% save output (optional) -- note that negative values in the normal images will not save correctly!
    if save_flag
        saveas(h, sprintf('%s_mesh_view1.png', subject_name));
        rotate(h, [0 1 0], 45);
        saveas(h, sprintf('%s_mesh_view2.png', subject_name));
        rotate(h, [0 1 0], -45);
        rotate(h, [0 0 1], 45);
        saveas(h, sprintf('%s_mesh_view3.png', subject_name));
        
        imwrite(albedo_image, sprintf('%s_albedo.jpg', subject_name), 'jpg');
        imwrite(surface_normals, sprintf('%s_normals_color.jpg', subject_name), 'jpg');
        imwrite(surface_normals(:,:,1), sprintf('%s_normals_x.jpg', subject_name), 'jpg');
        imwrite(surface_normals(:,:,2), sprintf('%s_normals_y.jpg', subject_name), 'jpg');
        imwrite(surface_normals(:,:,3), sprintf('%s_normals_z.jpg', subject_name), 'jpg');
    end

end