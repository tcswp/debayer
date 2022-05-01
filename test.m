I = imread('test_images/lighthouse.tiff');

subplot(1,5,1)
imshow(I)
title('Original')

[v,h,b] = size(I);

I = bayer_pref(I,v,h);
subplot(1,5,2)
imshow(I)
title('Prefiltered image')

B = bayer(I,v,h);
subplot(1,5,3)
imshow(B)
title('Bayer-encoded image')

L = bi(B);
subplot(1,5,4)
imshow(L)
title('Bilinear interpolation')

D = edi(B,v,h);
subplot(1,5,5)
imshow(D)
title('Edge-directed interpolation')
