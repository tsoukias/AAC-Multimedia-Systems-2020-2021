function SMR = psycho(frameT, frameType, frameTprev1, frameTprev2)
%Calculates the SMR of a given frame
%Inputs:
%frameT -> given frame for processing
%frameType -> {OLS, LSS, ESH, LPS} 
%frameTprev1 -> n-1 frame used for calculations of r_pred and f_pred
%frameTprev2 -> n-2 frame used for calculations of r_pred and f_pred for
%long frames only
%
%Output: 
%SMR -> SMR of the given frame 
%42x8 for short frame, 69x1 for long frame

B219_all = load('TableB219.mat');
if isequal(frameType, 'ESH')
    %% Step 2: Calculation of complex magnitudes and phases
    [r,f] = SHORT_FFT(frameT);
    [r_prev,f_prev] = SHORT_FFT(frameTprev1);
    r1 = [r_prev(:,8) r(:,1:7)];
    r2 = [r_prev(:,7:8) r(:,1:6)];
    f1 = [f_prev(:,8) f(:,1:7)];
    f2 = [f_prev(:,7:8) f(:,1:6)];
    B219 = B219_all.B219b;
else
    %% Step 2: Calculation of complex magnitudes and phases
    [r,f] = LONG_FFT(frameT);
    [r1,f1] = LONG_FFT(frameTprev1);
    [r2,f2] = LONG_FFT(frameTprev2);
    B219 = B219_all.B219a;
end
b = length(B219);
w_low = B219(:,2);
w_high = B219(:,3);
qthr(:,1) = B219(:,6);
bval = B219(:,5);
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
for i = 1:b
    for j=1:N
        if tb(i,j)<0
            tb(i,j) =0.00001;
        end
    end
end
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
