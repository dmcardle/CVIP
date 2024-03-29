
function transfer_all_foregrounds(imname, idx, fgs)

    I = imread( ['images/' imname '.jpg'] );

    bg = imread('images/bg.jpg');
    bg2 = imread('images/bg2.jpg');
    bg3 = imread('images/bg3.jpg');
    bg4 = 255 .* bg;
    
    out1 = transferImg(fgs, idx, I, bg);
    out2 = transferImg(fgs, idx, I, bg2);
    out3 = transferImg(fgs, idx, I, bg3);
    out4 = transferImg(fgs, idx, I, bg4);
    
    imwrite(out1, ['output/' imname '1.png']);
    imwrite(out2, ['output/' imname '2.png']);
    imwrite(out3, ['output/' imname '3.png']);
    imwrite(out4, ['output/' imname '4.png']);
    
    