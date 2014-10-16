% FUNCTION [MINVEC, MINPADDED] = ALIGN(LAYER, COMPARISON, MAX_OFFSET)
%   LAYER is an unpadded image
%   COMPARISON is an unpadded image
%   MAX_OFFSET is the maximum amount of shift in either dimension
function minVec = align(layer, comparison, max_offset)

    minScore = Inf;
    minVec = [Inf Inf];
    minPadded = [];

    range = -max_offset:max_offset;
    for x=range
        for y=range
            %shifted = padimage(layer, max_offset, x, y);
            shifted = circshift(layer, [y x]);
            diffSq = (comparison - shifted) .^ 2;
            score = sum(sum(diffSq));


            % Select the displacement vector that gives the minimum difference.
            if score < minScore
                minScore = score;
                minVec = [x y];
                minPadded = shifted;
            end
        end
    end
end
