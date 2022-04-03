function D = edi(B,v,h)
  D = B;
  
  % detect edge and interpolate G (minus border)
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
  
  % fill in border
  
  % interpolate R at B
  for i = 3:2:v-1
    for j = 3:2:h-1
      D(i,j,1) = B(i,j,2)*(B(i-1,j-1,1)/B(i-1,j-1,2)
                         + B(i-1,j+1,1)/B(i-1,j+1,2)
                         + B(i+1,j-1,1)/B(i+1,j-1,2)
                         + B(i+1,j+1,1)/B(i+1,j+1,2))/4;
    end
  end
  
  % interpolate B at R
  for i = 2:2:v-1
    for j = 2:2:h-1
      D(i,j,3) = B(i,j,2)*(B(i-1,j-1,3)/B(i-1,j-1,2)
                         + B(i-1,j+1,3)/B(i-1,j+1,2)
                         + B(i+1,j-1,3)/B(i+1,j-1,2)
                         + B(i+1,j+1,3)/B(i+1,j+1,2))/4;
                        
    end
  end
  
  % interpolate R,B at remaining G
  
end