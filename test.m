I = imread('test_images/barbara.tif');
[v,h,b] = size(I);
B = bayer(I,v,h);
imshow(B)