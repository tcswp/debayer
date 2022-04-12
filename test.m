I = imread('test_images/lighthouse.tiff');

subplot(1,3,1)
imshow(I)
title('Original')

[v,h,b] = size(I);
B = bayer(I,v,h);
subplot(1,3,2)
imshow(B)
title('Bayer CFA')

D = edi(B,v,h);
subplot(1,3,3)
imshow(D)
title('Edge-directed interpolation')

