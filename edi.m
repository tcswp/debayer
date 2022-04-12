function D = edi(B,v,h)
  B = double(B);
  D = B;
  
  % detect edge and interpolate G
  for i = 2:v-1
    for j = 2:2:h-1
      
      k = j + mod(i,2);
      
      dh = abs(B(i,j-1,2)-B(i,k+1,2));
      dv = abs(B(i-1,k,2)-B(i+1,k,2));
      
      if (dh > dv)
        D(i,k,2) = (B(i-1,k,2)+B(i+1,k,2))/2;
      elseif (dh < dv)
        D(i,k,2) = (B(i,k-1,2)+B(i,k+1,2))/2;
      else
        D(i,k,2) = (B(i-1,k,2)+B(i+1,k,2)+B(i,k-1,2)+B(i,k+1,2))/4;
      end
    end
  end
 
  % interpolate R at B
  for i = 3:2:v-1
    for j = 3:2:h-1
      D(i,j,1) = D(i,j,2)*(D(i-1,j-1,1)/D(i-1,j-1,2)...
                         + D(i-1,j+1,1)/D(i-1,j+1,2)...
                         + D(i+1,j-1,1)/D(i+1,j-1,2)...
                         + D(i+1,j+1,1)/D(i+1,j+1,2))/4;
    end
  end
  
  % interpolate B at R
  for i = 2:2:v-1
    for j = 2:2:h-1
      D(i,j,3) = D(i,j,2)*(D(i-1,j-1,3)/D(i-1,j-1,2)...
                         + D(i-1,j+1,3)/D(i-1,j+1,2)...
                         + D(i+1,j-1,3)/D(i+1,j-1,2)...
                         + D(i+1,j+1,3)/D(i+1,j+1,2))/4;
                        
    end
  end
  
  % interpolate R and B at remaining G
  for i = 3:v-2
    for j = 3:2:h-2

        k = j + mod(i,2);

        D(i,k,1) = D(i,k,2)*(D(i-1,k,1)/D(i-1,k,2)...
                           + D(i+1,k,1)/D(i+1,k,2)...
                           + D(i,k-1,1)/D(i,k-1,2)...
                           + D(i,k+1,1)/D(i,k+1,2))/4;

        D(i,k,3) = D(i,k,2)*(D(i-1,k,3)/D(i-1,k,2)...
                           + D(i+1,k,3)/D(i+1,k,2)...
                           + D(i,k-1,3)/D(i,k-1,2)...
                           + D(i,k+1,3)/D(i,k+1,2))/4;
    end
  end

  D = uint8(D);
end