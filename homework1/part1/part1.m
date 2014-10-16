% CSE 473/573 Programming Assignment 1
% Daniel McArdle

WRITE_MODE = 1;
DISP_MODE = 2;
mode = WRITE_MODE;

for imnum=1:6
    imname = sprintf('part1_%d.jpg', imnum);
    fprintf('\nProcessing image %d\n', imnum)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Adapted from A. Efros
    % (http://graphics.cs.cmu.edu/courses/15-463/2010_fall/hw/proj1/)
    % and R. Fergus
    % http://cs.nyu.edu/~fergus/teaching/vision/assign1.pdf

    % read in the image
    fullim = imread(imname);
    % convert to double matrix 
    fullim = im2double(fullim);

    % compute the height of each part (just 1/3 of total)
    height = floor(size(fullim,1)/3);
    % separate color channels
    B = fullim(1:height,:);
    G = fullim(height+1:height*2,:);
    R = fullim(height*2+1:height*3,:);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Crop the images to remove the glass plate border
    crop_amt = 20;
    cB = crop(B, crop_amt);
    cG = crop(G, crop_amt);
    cR = crop(R, crop_amt);

    % Detect edges in each layer
    edge_method = 'canny'; % 'sobel'
    eB = edge(cB, edge_method);
    eG = edge(cG, edge_method);
    eR = edge(cR, edge_method);

    % Automatically align the Green and Red layers with the Blue layer.
    max_offset = 15;
    vecG = align(eG, eB, max_offset);
    vecR = align(eR, eB, max_offset);

    fprintf('\tGreen displacement vector = [%d %d]\n', vecG(1), vecG(2))
    fprintf('\t  Red displacement vector = [%d %d]\n', vecR(1), vecR(2))

    % Pad the images with their computed displacement vectors
    aB = padimage(B, max_offset, 0, 0);
    aG = padimage(G, max_offset, vecG(1), vecG(2));
    aR = padimage(R, max_offset, vecR(1), vecR(2));

    % Compute images for display
    auto = cat(3, aR, aG, aB);

    if mode == DISP_MODE
        naive = cat(3, R, G, B);
        naive = padimage(naive, max_offset, 0, 0);

        figure

        % =========== Plot the naive alignment
        subplot('Position', [0 0 0.5 1])
        imshow(naive)
        title('Naive Alignment')

        % =========== Plot the auto alignment
        subplot('Position', [0.5 0 0.5 1])
        imshow(auto)
        title('Automatic Alignment')

    elseif mode == WRITE_MODE
        % save result image
        imwrite(auto, ['result-' imname]);
    end
end
