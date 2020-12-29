clc;
close all;
clear all;
%% Preprocessing of the wav file
fNameIn = 'LicorDeCalandraca.wav';
[y, Fs] = audioread(fNameIn);
%sound(y,Fs);
%% Framing
%% Preprocessing of the wav file
[y, Fs] = audioread(fNameIn);
%sound(y,Fs);

%% Create frames
zero_padding = zeros(1024,2);
N = length(y);
y1 = zeros(1024-mod(N,1024),2);
y = [y;y1];
y = [zero_padding;y;zero_padding];


K = length(y)/1024-1;
frame_W = zeros(K,2048,2);
for i=1:K
    frame_W(i,1:2048,:) = y(i*1024-1023:i*1024+1024,:);
end

%% Load of B219 matrixes
AACSeq2 = AACoder2(fNameIn);
B219 = load('TableB219.mat');
B219a = B219.B219a;
B219b = B219.B219b; 
bval = B219a(:,5);
i=2;
j=0;
% Preparation of function's input data
index = 60;
frameT(:,1) = frame_W(index,:,1);
frameType = AACSeq2(index).frameType;
frameTprev1(:,1) = frame_W(index-1,:,1);
frameTprev2(:,1) = frame_W(index-2,:,1);

%% Process for Long Frame
% Step1




if isequal(frameType, 'ESH')
    %Step 2: Calculation of complex magnitudes and phases
    [r,f] = SHORT_FFT(frameT);
    [r_prev,f_prev] = SHORT_FFT(frameTprev1);
    r1 = r_prev(:,8);
    f1 = f_prev(:,8);
    r2 = r_prev(:,7);
    f2 = f_prev(:,7);
    %Step 3: Calculations of predictions for r and f
    r_pred = 2*r1 - r2;
    f_pred = 2*f1 - f2;
    %Step 4: Calculation of predictability matrix c
    c = sqrt( (r.*cos(f) - r_pred.*cos(f_pred) ).^2 +( r.*sin(f) - r_pred.*sin(f_pred) ).^2 ) ./ ( r + abs(r_pred) );
    %Step 5: Calculation of eb and eb
    b = length(B219b);
    w_low = B219b(:,2);
    w_high = B219b(:,3);
    eb = zeros(b,8);
    c1 = zeros(b,8);
    for n = 1:8
        for i = 1:b
            eb(i,n) = sum( r(w_low(i)+1:w_high(i)+1,n).^2);
            c1(i,n) = sum( c(w_low(i)+1:w_high(i)+1,n).*r(w_low(i)+1:w_high(i)+1,n).^2);
        end
    end
    % Step 6: Calculation of ecb and ct
    ecb = zeros(b,8);
    ct = zeros(b,8);
    bval = B219a(:,5);
    bb=b;
    for n = 1:8
        for j=1:b
            for i=1:bb
                ecb(j,n) = ecb(j,n) + eb(i,n) * spreadingfun(i,j,bval);
                ct(j,n) = ct(j,n) + c1(i,n) * spreadingfun(i,j,bval);
            end
        end
    end
    %Calculation of cb and en
    for n = 1:8
        cb(1:b,n) = ct(1:b,n)./ecb(1:b,n);
    end
    en = zeros(b,8);
    norm_factor = zeros(b,8);
    for n = 1:8
        for j=1:b
            for i=1:bb
                norm_factor(i,n) = norm_factor(i,n) + spreadingfun(i,j,bval);
            end
            en(j,n) = ecb(j,n)./norm_factor(j,n);
        end
    end
    
else
    %Step 2: Calculation of complex magnitudes and phases
    [r,f] = LONG_FFT(frameT);
    [r1,f1] = LONG_FFT(frameTprev1);
    [r2,f2] = LONG_FFT(frameTprev2);
    %Step 3: Calculations of predictions for r and f
    r_pred = 2*r1 - r2;
    f_pred = 2*f1 - f2;
    %Step 4: Calculation of predictability matrix c
    c = sqrt( (r.*cos(f) - r_pred.*cos(f_pred) ).^2 +( r.*sin(f) - r_pred.*sin(f_pred) ).^2 ) ./ ( r + abs(r_pred) );
    %Step 5: Calculation of eb and eb
    b = length(B219a);
    w_low = B219a(:,2);
    w_high = B219a(:,3);
    eb = zeros(b,1);
    c1 = zeros(b,1);
    for i = 1:b
        eb(i,1) = sum( r(w_low(i)+1:w_high(i)+1).^2);
        c1(i,1) = sum( c(w_low(i)+1:w_high(i)+1).*r(w_low(i)+1:w_high(i)+1).^2);
    end
    %Step 6: Calculation of ecb and ct
    ecb = zeros(b,1);
    ct = zeros(b,1);
    bval = B219a(:,5);
    bb=b;
    for j=1:b
        for i=1:bb
            ecb(j,1) = ecb(j,1) + eb(i,1) * spreadingfun(i,j,bval);
            ct(j,1) = ct(j,1) + c1(i,1) * spreadingfun(i,j,bval);
        end
    end
    %Calculation of cb and en
    cb(1:b,1) = ct(1:b)./ecb(1:b);
    en = zeros(b,1);
    norm_factor = zeros(b,1);      
    for j=1:b
        for i=1:bb
             norm_factor(j,1) = norm_factor(j,1) + spreadingfun(i,j,bval);
        end
        en(j,1) = ecb(j,1)./norm_factor(j,1);
    end
    %Step 7: Calculation of tb
    
    tb(1:b) = -0.299 - 0.43.*log(cb(1:b));
end

