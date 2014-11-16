
n = 100;
m = 50;

% create im1
useim1 = zeros(n);
x = rand(50);
useim1(5:5+m-1, 5:5+m-1) = x;
% create im2 (using same random block)
useim2 = zeros(n);
useim2(5:5+m-1, 23:23+m-1) = x;

temp = useim1;
useim1 = useim2;
useim2 = temp;

blocksize = 2;
bDraw = false;
[disparityMap, err] = BlockMatch(useim1, useim2, useim1, blocksize, bDraw);

fprintf('min val = %d\n', min(disparityMap(:)));
fprintf('max val = %d\n', max(disparityMap(:)));
