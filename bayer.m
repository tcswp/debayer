function B = bayer(I,v,h)
  B = zeros(v,h,3,'uint8');
  for i = 1:2:v-1
    for j = 1:2:h-1
      B(i,j,3)     = I(i,j,3);
      B(i,j+1,2)   = I(i,j+1,2);
      B(i+1,j,2)   = I(i+1,j,2);
      B(i+1,j+1,1) = I(i+1,j+1,1);
    end
  end
end

