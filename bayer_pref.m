function J = bayer_pref(B,v,h)
    Hr = zeros(v,h);
    Hr(1:uint8(v/2),1:uint8(h/2)) = ones(uint8(v/2),uint8(h/2)); % embed mask
    Hr = circshift(Hr,[uint8(v/4) uint8(h/4)]); % shift mask to center
    
    Hg = zeros(v,h);
    Hg(1:uint8(sqrt(2)/2*v/2),1:uint8(sqrt(2)/2*h/2)) = ones(uint8(sqrt(2)/2*v/2),uint8(sqrt(2)/2*h/2));
    Hg = circshift(Hg,[uint8(sqrt(2)/2*v/2) uint8(sqrt(2)/2*h/2)]);
    Hg = imrotate(Hg,45,'crop');
    
    Hr = imgaussfilt(Hr,3);
    Hg = imgaussfilt(Hg,3);
   
    Hb = Hr;
    
    Ur = fftshift(fft2(B(:,:,1)));
    Ub = fftshift(fft2(B(:,:,3)));
    Ug = fftshift(fft2(B(:,:,2)));
    
    Yr = Ur .* Hr;
    Yb = Ub .* Hb;
    Yg = Ug .* Hg;
    
    J(:,:,1) = abs(ifft2(Yr));
    J(:,:,3) = abs(ifft2(Yb));
    J(:,:,2) = abs(ifft2(Yg));
    
    J = uint8(J);
end