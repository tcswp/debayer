I = imread('test_images/woman.tiff');
[v,h,b] = size(I);
B = bayer(I,v,h);
figure(1)
imshow(B)
title('Woman downsampled to Bayer CFA')
imwrite(B,'woman_mosaic.tiff');

%{
figure(2)
D = edi(B,v,h);
imshow(D)
title('Adaptive edge-directed interpolation')
%}
