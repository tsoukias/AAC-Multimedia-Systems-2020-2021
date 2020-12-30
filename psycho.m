function SMR = psycho2(frameT, frameType, frameTprev1, frameTprev2)
B219 = load('TableB219.mat');
B219a = B219.B219a;
B219b = B219.B219b; 

if isequal(frameType, 'ESH')
    %% Step 2: Calculation of complex magnitudes and phases
    [r,f] = SHORT_FFT(frameT);
    [r_prev,f_prev] = SHORT_FFT(frameTprev1);
    r1(:,1)=r_prev(:,8);
    r2(:,1:2)=r_prev(:,7:8);
    f1(:,1)=f_prev(:,8);
    f2(:,1:2)=f_prev(:,7:8);
    for i=1:7
        r1(:,i+1) = r(:,i);
        f1(:,i+1) = f(:,i);
    end
    for i=1:6
        r2(:,i+2) = r(:,i);
        f2(:,i+2) = f(:,i);
    end
    w_low = B219b(:,2);
    w_high = B219b(:,3);
    qthr(:,1) = B219b(:,6);    
    b = length(B219b);
else
    %% Step 2: Calculation of complex magnitudes and phases
    [r,f] = LONG_FFT(frameT);
    [r1,f1] = LONG_FFT(frameTprev1);
    [r2,f2] = LONG_FFT(frameTprev2);
    
    b = length(B219a);
    w_low = B219a(:,2);
    w_high = B219a(:,3);
    qthr(:,1) = B219a(:,6);
end

%% Step 3: Calculations of predictions for r and f
r_pred = 2*r1 - r2;
f_pred = 2*f1 - f2;
%% Step 4: Calculation of predictability matrix c
c = sqrt( (r.*cos(f) - r_pred.*cos(f_pred) ).^2 +( r.*sin(f) - r_pred.*sin(f_pred) ).^2 ) ./ ( r + abs(r_pred) );
%% Step 5: Calculation of eb and eb
N = size(r,2);
eb = zeros(b,N);
c1 = zeros(b,N);
for n = 1:N
    for i = 1:b
        eb(i,n) = sum( r(w_low(i)+1:w_high(i)+1,n).^2);
        c1(i,n) = sum( c(w_low(i)+1:w_high(i)+1,n).*r(w_low(i)+1:w_high(i)+1,n).^2);
     end
end
%% Step 6: Calculation of ecb and ct
ecb = zeros(b,N);
ct = zeros(b,N);
bval = B219a(:,5);
bb=b;
for n = 1:N
    for j=1:b
        for i=1:bb
            ecb(j,n) = ecb(j,n) + eb(i,n) * spreadingfun(i,j,bval);
            ct(j,n) = ct(j,n) + c1(i,n) * spreadingfun(i,j,bval);
        end
    end
end
%% Calculation of cb and en
cb(1:b,1:N) = ct(1:b,1:N)./ecb(1:b,1:N);
en = zeros(b,1);
norm_factor = zeros(b,N); 
for n=1:N
    for j=1:b
        for i=1:bb
            norm_factor(j,n) = norm_factor(j,n) + spreadingfun(i,j,bval);
        end
        en(j,n) = ecb(j,n)./norm_factor(j,n);
     end
end
%% Step 7: Calculation of tb
tb(1:b,1:N) = -0.299 - 0.43.*log(cb(1:b,1:N));
%% Step 8: Calculation of SNR
NMT = 6;
TMN = 18;
SNR(1:b,1:N) = tb(1:b,1:N)*TMN + (1-tb(1:b,1:N))*NMT;
%% Step 8: Calculation of bc
bc(1:b,1:N) = 10.^(-SNR(1:b,1:N)/10);
%% Step 9: Calculation of nb
nb(1:b,1:N) = en(1:b,1:N).*bc(1:b,1:N);
%% Step 9: Calculation of npart
qthr_hat = zeros(b,N);
for n=1:N
    qthr_hat(1:b,n) = eps()*128*10.^(qthr(1:b,1)/10);
end
npart(1:b,1:N) = max(nb(1:b,1:N),qthr_hat(1:b,1:N));
%% Step 10: Calculation of SMR
SMR(1:b,1:N) = eb(1:b,1:N)./npart(1:b,1:N);
end

