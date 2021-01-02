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
B219_all = load('TableB219.mat');


%% Preparation of input data
index = 27;
frameT(:,1) = frame_W(index,:,1);
frameType = AACSeq2(index).frameType;
frameTprev1(:,1) = frame_W(index-1,:,1);
frameTprev2(:,1) = frame_W(index-2,:,1);
frameF = AACSeq2(index).chl.frameF;
%% Process for Long Frame
SMR = psycho(frameT, frameType, frameTprev1, frameTprev2);

[S, sfc, G] = AACquantizer(frameF, frameType, SMR);
% frameF = iAACquantizer(S, sfc, G, frameType)

B219_all = load('TableB219.mat');
if isequal(frameType, 'ESH')
    B219 = B219_all.B219b;
    S = reshape(S,[128 8]);
    N = 8;
else
    B219 = B219_all.B219a;
    X = frameF;
    N = 1;
end
b = length(SMR);
w_low = B219(:,2);
w_high = B219(:,3);
b = length(sfc);
a = zeros(size(sfc));
a(1,:) = sfc(1,:);
for i = 2:b
    a(i,:) = a(i-1,:)+sfc(i,:);
end

for n=1:N
    for i=1:b
        X_hat(w_low(i)+1:w_high(i)+1,n) = sign(S(w_low(i)+1:w_high(i)+1,n)) .* abs(S(w_low(i)+1:w_high(i)+1,n)).^(4/3) * 2^(1/4*a(i,n));
    end
end
