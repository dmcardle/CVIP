function dispMap = DynamicProg(im1, im2)
%Write a script that processes stereo image pair to generate disparity map
%using dynamic programming

% TODO experiment with canny threshold value
im1edges = edge(im1, 'canny');
im2edges = edge(im2, 'canny');

[rows,cols] = size(im1);
dispMap = zeros(rows,cols);
        
function c = ArcCost()

end
    
for r=1:rows
    
    if mod(r,50) == 0
        fprintf('%.2f%% done\n', 100*r/rows);
    end
    
    im1Row = im1edges(r,:);
    im2Row = im2edges(r,:);
    
    
    
    % We assume the scanlines have m and n edge points, respectively (the
    % endpoints of the scanlines are included for convenience).
    im1RowEdges = [1 find(im1Row) cols];
    im2RowEdges = [1 find(im2Row) cols];
    [~, m] = size(im1RowEdges);
    [~, n] = size(im2RowEdges);
    
    

    
    
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
                
                % ===== inlined version of ArcCost function =====
                % Arc-Cost(i,j,k,l) evaluates and returns the cost of
                % matching the intervals (i,k) and (j,l).
                
                iVal = im1RowEdges(i);
                kVal = im1RowEdges(k);

                jVal = im2RowEdges(j);
                lVal = im2RowEdges(l);

                range1 = im1(r, iVal:kVal);
                range2 = im2(r, jVal:lVal);

                mean1 = mean(range1);
                mean2 = mean(range2);
                arcCost = (mean1-mean2) .^ 2;
                % ===============================================
                
                d = C(i,j) + arcCost;
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
        
        % So we know that edge i matched with edge j
        
        iPos = im1RowEdges(i);
        if i+1 > size(im1RowEdges)
            i2Pos = im1RowEdges(end);
        else
            i2Pos = im1RowEdges(i+1);    
        end
        
        jPos = im2RowEdges(j);
        dispMap(r, iPos:i2Pos) = abs(jPos - iPos);

    end
    

%    dispMap(r, :) = abs(P(:,1) - P(:,2))';
end


%imshow(Disparity,[]), axis image, colormap('jet'), colorbar;
%caxis([0 disparityRange]);
%imwrite('DisparityDyn.png', Disparity);

end