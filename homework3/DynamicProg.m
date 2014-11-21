function dispMap = DynamicProg(im1, im2)
%Write a script that processes stereo image pair to generate disparity map
%using dynamic programming

% TODO experiment with canny threshold value
im1edges = edge(im1, 'canny');
im2edges = edge(im2, 'canny');

[rows,cols] = size(im1);

function c = ArcCost(im1RowEdges, im2RowEdges, i,j,k,l)
    % Arc-Cost(i,j,k,l) evaluates and returns the cost of matching the
    % intervals (i,k) and (j,l).
    
    % TODO determine correct ArcCost algorithm.  For now, we are
    % calculuating the difference in size between the two intervals. A
    % large difference in interval size implies that the intervals should
    % not be matched.
    iPos = im1RowEdges(i);
    kPos = im1RowEdges(k);
    jPos = im2RowEdges(j);
    lPos = im2RowEdges(l);
    c = abs((iPos-jPos) - (kPos-lPos));
end
    
    
for r=1:rows
    
    if mod(r,50)
        fprintf('%.2f%% done\n', 100*r/rows);
    end
    
    im1row = im1edges(r,:);
    im2row = im2edges(r,:);
    
    
    
    % We assume the scanlines have m and n edge points, respectively (the
    % endpoints of the scanlines are included for convenience).
    im1rowEdges = [1 find(im1row) cols];
    im2rowEdges = [1 find(im2row) cols];
    [~, m] = size(im1rowEdges);
    [~, n] = size(im2rowEdges);
    
    
    % For correctness, C(1,1) should be initalized with a value of zero.
    C = zeros(m,n);
    % Initialize structure for storing backwards pointers.
    B = {};
    
    
    % Per-scanline algorithm:
    for k=2:m
        for l=2:n
            C(k,l) = Inf;   % Optimal cost
            B{k,l} = NaN;   % Backward pointer
            
            % Inferior neighbors are left, upleft, and up.
            infNeigh = [k-1 l;
                        k-1 l-1;
                        k   l-1];
            
            % for each column of infNeigh'
            for pair = infNeigh'
                i = pair(1);
                j = pair(2);
                
                % Compute new path cost and update backward pointer if
                % necessary.
                d = C(i,j) + ArcCost(im1rowEdges, im2rowEdges, i, j, k, l);
                if d < C(k,l)
                    C(k,l) = d;
                    B{k,l} = [i,j];
                end
            end
        end
    end
    
    % Construct optimal path by following backward pointers from (m,n).
    idx_P = 1;
    P = [m n];
    i = m;
    j = n;
    while ~isnan(B{i,j})
        pair = B{i,j};
        i = pair(1);
        j = pair(2);
        
        idx_P = idx_P + 1;
        P(idx_P, :) = [i j];
    end
    
    imshow(C, [])

%    dispMap(r, :) = abs(P(:,1) - P(:,2))';
end


%imshow(Disparity,[]), axis image, colormap('jet'), colorbar;
%caxis([0 disparityRange]);
%imwrite('DisparityDyn.png', Disparity);

end