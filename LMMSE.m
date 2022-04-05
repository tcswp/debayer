function output = LMMSE(A)
[N,M,ch]=size(A);
f=[-1/4 1/2 1/2 1/2 -1/4]; %second-order Laplacian interpolation filter
Ah=conv2(A,f); %this step we are getting the horizontal values of A after convolution 
Ah=Ah(:,3:2+M);
Av=conv2(A,f');%this step we are getting the vertical values of A after convolution 
Av=Av(3:2+N,:);
Dealtah=zeros(N,M);
Dealtav=Dealtah;%initializing Dealta for horizontal and Dealta for vertical
for i=1:2:N
    Dealtah(i,1:2:M)=A(i,1:2:M)-Ah(i,1:2:M);
    Dealtah(i,2:2:M)=Ah(i,2:2:M)-A(i,2:2:M);
    Dealtav(i,1:2:M)=A(i,1:2:M)-Av(i,1:2:M);
    Dealtav(i,2:2:M)=Av(i,2:2:M)-A(i,2:2:M);
end
for i=2:2:N
    Dealtah(i,2:2:M)=A(i,2:2:M)-Ah(i,2:2:M);
    Dealtah(i,1:2:M)=Ah(i,1:2:M)-A(i,1:2:M);
    Dealtav(i,2:2:M)=A(i,2:2:M)-Av(i,2:2:M);
    Dealtav(i,1:2:M)=Av(i,1:2:M)-A(i,1:2:M);
end
f=[1 1 1 1 1 1 1 1 1]; %some method to find optimal low-pass filter value
% that can remove the noise (called y_s^n is LMMSE descpition)
% yet to be imprementied 
ysh=conv2(Dealtah,f);
ysh=ysh(:,5:4+M);
ysv=conv2(Dealtav,f');
ysv=ysv(5:4+N,:);

%assume we are using L = 4
rAg=A;
for i=5:2:N-4 %we need four values for each dirction so here we start from 
    % five and ends at N-4 to prevent the index goes out of array
    for j=6:2:M-4
        hvalues=Dealtah(i,j-4:j+4);
        vvalues=Dealtav(i-4:i+4,j);
        ath=ysh(i,j-4:j+4);
        atv=ysv(i-4:i+4,j);      
        mh=ath(5);
        ph=cov(ath);
        Rh=mean((ath-hvalues).^2)+0.1;
        h=mh+ph/(ph+Rh)*(hvalues(5)-mh);
        mv=atv(5);
        pv=cov(atv);
        v=mv+pv/(pv+Rv)*(vvalues(5)-mv);
    end
end
% yet to imprement