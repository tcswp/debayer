function L = bi(B)
    mR = [1 0 1;0 0 0;1 0 1]/4;
    mG = [0 1 0;1 0 1;0 1 0]/4;
    mB = mR;
    
    L = double(B);
    
    L(:,:,3) = L(:,:,3) + imfilter(L(:,:,3),mR); %blue @ red
    L(:,:,3) = L(:,:,3) + imfilter(L(:,:,3),mG); %blue @ green
    
    L(:,:,1) = L(:,:,1) + imfilter(L(:,:,1),mB); %red @ blue
    L(:,:,1) = L(:,:,1) + imfilter(L(:,:,1),mG); %red @ green
    
    L(:,:,2) = L(:,:,2) + imfilter(L(:,:,2),mG); %green
    
    L = uint8(L);
end