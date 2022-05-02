function out = dlmmse(img)

[row,col,ch] = size(img);
img = im2double(img);

if ch==3
    temp = zeros(row, col);
    for i = 1:row
        for j=1:col
            if mod(i, 2) == 0 && mod(j, 2) == 0
                temp(i, j) = img(i, j, 3);
            elseif mod(i, 2) == 0 && mod(j, 2) == 1
                temp(i, j) = img(i, j, 2);
            elseif mod(i, 2) == 1 && mod(j, 2) == 0
                temp(i, j) = img(i, j, 2);
            elseif mod(i, 2) == 1 && mod(j, 2) == 1
                temp(i, j) = img(i, j, 1);
            end
        end
    end
end

img = temp;

f=[-1/4 1/2 1/2 1/2 -1/4];

G_h = conv2(img,f);
G_v = conv2(img,f');

G_hat_h = zeros(row,col);
G_hat_v = zeros(row,col);

for i=1:2:row
   G_hat_h(i,1:2:col) = G_h(i,1:2:col) - img(i,1:2:col); 
   G_hat_h(i,2:2:col) = img(i,2:2:col) - G_h(i,2:2:col);
   G_hat_v(i,1:2:col) = G_v(i,1:2:col) - img(i,1:2:col); 
   G_hat_v(i,2:2:col) = img(i,2:2:col) - G_v(i,2:2:col);
end

for i=2:2:row
   G_hat_h(i,2:2:col) = G_h(i,2:2:col) - img(i,2:2:col); 
   G_hat_h(i,1:2:col) = img(i,1:2:col) - G_h(i,1:2:col);
   G_hat_v(i,2:2:col) = G_v(i,2:2:col) - img(i,2:2:col); 
   G_hat_v(i,1:2:col) = img(i,1:2:col) - G_v(i,1:2:col);
end

h = [4 9 15 23 26 23 15 9 4]/128;

G_hat_h1 = convolution(G_hat_h,h);
G_hat_v1 = convolution(G_hat_v,h');

M = 4;

G_n = img; 

for i = 5:2:row-4
    for j = 5:2:col-4   
        
        th = G_hat_h(i,j-M:j+M);
        tv = G_hat_v(i-M:i+M,j);
        ath = G_hat_h1(i,j-M:j+M);
        atv = G_hat_v1(i-M:i+M,j);
    
        mh = ath(M+1);
        ph = cov(ath);
        Rh = mean((ath-th).^2)+0.1;
        x_h = mh + ph/(ph+Rh) * (th(M+1)-mh);
        X_H = ph - ph/(ph+Rh) * ph+0;
        
        mv = atv(M+1);
        pv = cov(atv);
        Rv = mean((atv-tv).^2)+0.1;
        x_v = mv + pv/(ph+Rv) * (tv(M+1)-mv);
        X_V = pv - pv/(pv+Rv) * pv+0.1;
        
        val = (X_V*x_h+X_H*x_v)/(X_H+X_V);
        G_n(i,j) = img(i,j) + val;
        
    end
end

for i = 6:2:row-4
    for j = 6:2:col-4   
        
        th = G_hat_h(i,j-M:j+M);
        tv = G_hat_v(i-M:i+M,j);
        ath = G_hat_h1(i,j-M:j+M);
        atv = G_hat_v1(i-M:i+M,j);
    
        mh = ath(M+1);
        ph = cov(ath);
        Rh = mean((ath-th).^2)+0.1;
        x_h = mh + ph/(ph+Rh) * (th(M+1)-mh);
        X_H = ph - ph/(ph+Rh) * ph+0.1;
        
        mv = atv(M+1);
        pv = cov(atv);
        Rv = mean((atv-tv).^2)+0.1;
        x_v = mv + pv/(ph+Rv) * (tv(M+1)-mv);
        X_V = pv - pv/(pv+Rv) * pv+0.1;
        
        val = (X_V*x_h+X_H*x_v)/(X_H+X_V);
        G_n(i,j) = img(i,j) + val;
        
    end
end
        
R_n = img;
B_n = img;

for i=6:2:row-4
   for j=6:2:col-4
      R_n(i,j)= G_n(i,j)-(G_n(i-1,j-1)-R_n(i-1,j-1)+G_n(i-1,j+1)-R_n(i-1,j+1)+G_n(i+1,j-1)-R_n(i+1,j-1)+G_n(i+1,j+1)-R_n(i+1,j+1))/4;
      B_n(i+1,j-1)=G_n(i+1,j-1)-(G_n(i,j-2)-B_n(i,j-2)+G_n(i,j)-B_n(i,j)+G_n(i+2,j-2)-B_n(i+2,j-2)+G_n(i+2,j)-B_n(i+2,j))/4;
  end
end

for i=6:2:row-4
   for j=6:2:col-4
      R_n(i,j-1)=G_n(i,j-1)-(G_n(i-1,j-1)-R_n(i-1,j-1)+G_n(i,j-2)-R_n(i,j-2)+G_n(i,j)-R_n(i,j)+G_n(i+1,j-1)-R_n(i+1,j-1))/4;
      B_n(i,j-1)=G_n(i,j-1)-(G_n(i-1,j-1)-B_n(i-1,j-1)+G_n(i,j-2)-B_n(i,j-2)+G_n(i,j)-B_n(i,j)+G_n(i+1,j-1)-B_n(i+1,j-1))/4;
      R_n(i+1,j)=G_n(i+1,j)-(G_n(i,j)-R_n(i,j)+G_n(i+1,j-1)-R_n(i+1,j-1)+G_n(i+1,j+1)-R_n(i+1,j+1)+G_n(i+2,j)-R_n(i+2,j))/4;
      B_n(i+1,j)=G_n(i+1,j)-(G_n(i,j)-B_n(i,j)+G_n(i+1,j-1)-B_n(i+1,j-1)+G_n(i+1,j+1)-B_n(i+1,j+1)+G_n(i+2,j)-B_n(i+2,j))/4;
   end
end

temp = zeros(row, col, ch);
temp(:,:,1) = R_n; 
temp(:,:,2) = G_n; 
temp(:,:,3) = B_n; 

out = temp;

for i = 1:5
  for j = 1:col-2
      if mod(i, 2) == 1 && mod(j, 2) == 0
          out(i,j+1,2) = (temp(i,j,2) + temp(i,j+2,2))/2;
      elseif mod(i, 2) == 0 && mod(j, 2) == 1
          out(i,j+1,2) = (temp(i,j,2) + temp(i,j+2,2))/2;
      elseif (mod(i, 2) == 1 && mod(j, 2) == 1) 
          out(i,j+1,1) = (temp(i,j,1) + temp(i,j+2,1))/2;
      elseif (mod(i, 2) == 0 && mod(j, 2) == 0) 
          out(i,j+1,3) = (temp(i,j,3) + temp(i,j+2,3))/2;
      end
  end
end
for i = row-4:row
  for j = 1:col-2
      if mod(i, 2) == 1 && mod(j, 2) == 0
          out(i,j+1,2) = (temp(i,j,2) + temp(i,j+2,2))/2;
      elseif mod(i, 2) == 0 && mod(j, 2) == 1
          out(i,j+1,2) = (temp(i,j,2) + temp(i,j+2,2))/2;
      elseif mod(i, 2) == 1 && mod(j, 2) == 1
          out(i,j+1,1) = (temp(i,j,1) + temp(i,j+2,1))/2;
      elseif mod(i, 2) == 0 && mod(j, 2) == 0
          out(i,j+1,3) = (temp(i,j,3) + temp(i,j+2,3))/2;
      end
  end
end

for i = 1:row
  for j = 1:4
      if mod(i, 2) == 1 && mod(j, 2) == 0
          out(i,j+1,2) = (temp(i,j,2) + temp(i,j+2,2))/2;
      elseif mod(i, 2) == 0 && mod(j, 2) == 1
          out(i,j+1,2) = (temp(i,j,2) + temp(i,j+2,2))/2;
      end
  end
end
for i = 1:row
  for j = col-5:col-2
      if mod(i, 2) == 1 && mod(j, 2) == 0
          out(i,j+1,2) = (temp(i,j,2) + temp(i,j+2,2))/2;
      elseif mod(i, 2) == 0 && mod(j, 2) == 1
          out(i,j+1,2) = (temp(i,j,2) + temp(i,j+2,2))/2;
      end
  end
end
for i = 3:2:row-1
    for j = 1:col
        if j == 1
            out(i,j,2) = (temp(i-1,j,2) + temp(i+1,j,2))/2;
         elseif j == col
            out(i-1,j,2) = (temp(i-2,j,2) + temp(i,j,2))/2;
        end
    end
end

for i = 1:row-2
    for j = 1:5
        if mod(i, 2) == 1 && mod(j, 2) == 1
            out(i+1,j,1) = (temp(i,j,1) + temp(i+2,j,1))/2;
        end
    end
end
for i = 1:row-2
    for j = col-4:col-1
        if mod(i, 2) == 1 && mod(j, 2) == 1
            out(i+1,j,1) = (temp(i,j,1) + temp(i+2,j,1))/2;
        end
    end
end
for i = 7:row-4
    for j = 1:5
        if mod(i, 2) == 1 && mod(j, 2) == 1
            out(i,j+1,1) = (temp(i,j,1) + temp(i,j+2,1))/2;
        end
    end
end
for i = 7:row-4
    for j = col-5:col-2
        if mod(i, 2) == 1 && mod(j, 2) == 1
            out(i,j+1,1) = (temp(i,j,1) + temp(i,j+2,1))/2;
        end
    end
end
for i = 2:2:row
    for j = 2:2:col-2
        out(i,j,1) = (out(i,j+1,1) + out(i,j-1,1))/2; 
    end
end
for i = 2:2:4
    for j = 7:col-6
        out(i,j,1) = (out(i-1,j,1) + out(i+1,j,1))/2; 
    end
end
for i = row-4:2:row-1
    for j = 7:col-6
        out(i,j,1) = (out(i-1,j,1) + out(i+1,j,1))/2; 
    end
end
for j = 1:col
    out(row,j,1) = out(row-1,j,1);
end
for i = 1:row
    out(i,col,1) = out(i,col-1,1);
end

for i = 1:row-2
    for j = 1:5
        if mod(i, 2) == 0 && mod(j, 2) == 0
            out(i+1,j,3) = (temp(i,j,3) + temp(i+2,j,3))/2;
        end
    end
end
for i = 1:row-2
    for j = col-4:col
        if mod(i, 2) == 0 && mod(j, 2) == 0
            out(i+1,j,3) = (temp(i,j,3) + temp(i+2,j,3))/2;
        end
    end
end
for i = 6:row-4
    for j = 1:5
        if mod(i, 2) == 0 && mod(j, 2) == 0
            out(i,j+1,3) = (temp(i,j,3) + temp(i,j+2,3))/2;
        end
    end
end
for i = 6:row-4
    for j = col-5:col-2
        if mod(i, 2) == 0 && mod(j, 2) == 0
            out(i,j+1,3) = (temp(i,j,3) + temp(i,j+2,3))/2;
        end
    end
end
for i = 3:2:row
    for j = 3:2:col-1 %%
        out(i,j,3) = (out(i,j+1,3) + out(i,j-1,3))/2; 
    end
end
for i = 3:2:5
    for j = 6:col-5
        out(i,j,3) = (out(i-1,j,3) + out(i+1,j,3))/2; 
    end
end
for i = row-3:2:row
    for j = 6:col-6
        out(i,j,3) = (out(i-1,j,3) + out(i+1,j,3))/2; 
    end
end
for j = 1:col
    out(1,j,3) = out(2,j,3);
end
for i = 1:row
    out(i,1,3) = out(i,2,3);
end

out = im2uint8(out);
