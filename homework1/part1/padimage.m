% FUNCTION PADDED = PADIMAGE(IMAGE, MAX_OFFSET, X, Y)
%   IMAGE is a matrix
%   MAX_OFFSET
%   [X Y] is the displacement vector
%
function padded = padimage(image, max_offset, x, y)
    [m, n, d] = size(image);
    padded = zeros(m + 2*max_offset, n + 2*max_offset, d);

    % For example, if x = -15, we want to have x = 0
    x = x + max_offset;
    y = y + max_offset;

    % Adjust for 1-based array indexing!!!
    padded(y+1:y+m, x+1:x+n, :) = image;
end
