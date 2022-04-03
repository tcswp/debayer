I = imread('test_images/lighthouse.tiff');
[v,h,b] = size(I);
B = bayer(I,v,h);
figure(1)
imshow(B)
title('Lighthouse downsampled to Bayer CFA')

%{
figure(2)
D = edi(B,v,h);
imshow(D)
title('Adaptive edge-directed interpolation')
%}
