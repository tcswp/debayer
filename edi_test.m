images = dir("dubois_images/*.tiff");

i = 1;
for image = images'
    I = imread("dubois_images/"+image.name);
    
    [v,h,b] = size(I);

    B = bayer(I,v,h);

    L = bi(B); 
    D = edi(B,v,h);

    %crop borders
    m = 5;
    I = I(m:v-m,m:h-m,:);
    L = L(m:v-m,m:h-m,:);
    D = D(m:v-m,m:h-m,:);
    
    bi_mse = immse(L,I);
    bi_psnr = psnr(L,I);
    edi_mse = immse(D,I);
    edi_psnr = psnr(D,I);
    
    figure(i)
    i = i+1;

    subplot(1,3,1)
    imshow(I)
    title("Original")

    subplot(1,3,2)
    imshow(L)
    title("Bilinear MSE="+bi_mse+", PSNR="+bi_psnr)

    subplot(1,3,3)
    imshow(D)
    title("GEDI+CHI MSE="+edi_mse+", PSNR="+edi_psnr)
end
