function DynamicProg(im1, im2)
%Write a script that processes stereo image pair to generate disparity map
%using dynamic programming

% TODO experiment with canny threshold value
im1edges = edge(im1, 'canny');
im2edges = edge(im2, 'canny');

[rows,cols] = size(im1);

for r=1:rows
    
    im1row = im1(r,:);
    im2row = im2(r,:);
    
    C = [];
    B = {};
    
    im1rowEdges = find(im1row == 1);
    im2rowEdges = find(im2row == 1);
    
    m = size(im1rowEdges);
    n = size(im2rowEdges);
    
    % Per-scanline algorithm:
    for k=1:m
        for l=1:n
            C(k,l) = Inf;   % Optimal cost
            B{k,l} = NaN;   % Backward pointer
            
            %infNeigh = InferiorNeighbors(k,l);
            
            
            
            for pair = infNeigh'
                i = pair(1);
                j = pair(2);
                
                d = C(i,j) + ArcCost(i,j,k,l);
                if d < C(k,l)
                    C(k,l) = d;
                    B(k,l) = [i,j];
                end
            end
        end
    end
    
    % Construct optimal path by following backward pointers from (m,n).
    idx_P = 1;
    P = [m n];
    i = m;
    j = n;
    while ~isNan(B{i,j})
        pair = B{i,j};
        i = pair(1);
        j = pair(2);
        
        idx_P = idx_P + 1;
        P(idx_P, :) = [i j];
    end
end


%imshow(Disparity,[]), axis image, colormap('jet'), colorbar;
%caxis([0 disparityRange]);
%imwrite('DisparityDyn.png', Disparity);