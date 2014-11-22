
n = 100;
m = 50;

% create im1
useim1 = 0.8*rand(n);
useim2 = circshift(useim1,2);
x = rand(50);

useim1(5:5+m-1, 1:1+m-1) = x;
useim2(5:5+m-1, 30:30+m-1) = x;



bDraw = false;
blocksize = 8;
[disp1, err1] = BlockMatch(useim1, useim2, 0, blocksize, bDraw, true);
[disp2, er2] = BlockMatch(useim2, useim1, 0, blocksize, bDraw, false);

figure
subplot(2,2,1), imshow(disp1, [])
subplot(2,2,2), imshow(disp2, [])

disp1Check = ConsistencyCheck(disp1, disp2, true);
disp2Check = ConsistencyCheck(disp2, disp1, false);

subplot(2,2,3), imshow(disp1Check, []);
subplot(2,2,4), imshow(disp2Check, []);