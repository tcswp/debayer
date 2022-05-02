I = imread('test_images/lighthouse.tiff');

subplot(1,6,1)
imshow(I)
title('Original')

[v,h,b] = size(I);

I = bayer_pref(I,v,h);
subplot(1,6,2)
imshow(I)
title('Prefiltered image')

B = bayer(I,v,h);
subplot(1,6,3)
imshow(B)
title('Bayer-encoded image')

L = bi(B);
subplot(1,6,4)
imshow(L)
title('Bilinear interpolation')
Llmmse = immse(I, L);

D = edi(B,v,h);
subplot(1,6,5)
imshow(D)
title('Edge-directed interpolation')
Dlmmse = immse(I, D);

subplot(1,6,6)
LMMSE =dlmmse(I);
imshow(LMMSE)
title('DLMMSE')
LMMSElmmse = immse(I, LMMSE);
