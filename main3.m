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


%% [S, sfc, G] = AACquantizer(frameF, frameType, SMR)

X = frameF;
if isequal(frameType, 'ESH')
    B219 = B219_all.B219b;
    [k,N] = size(X);
else
    B219 = B219_all.B219a;
    X = frameF;
    [k,N] = size(X);
end
b = length(SMR);
w_low = B219(:,2);
w_high = B219(:,3);
%% Calculation of T
P = zeros(b,N);
for j=1:N
    for i=1:b
        P(i,j) = sum(X(w_low(i)+1:w_high(i)+1,j).^2);
    end
end
T = P./SMR;
%% Step 1: Calculation of a,S and X_hat
MQ = 8191;
a = zeros(b,N);
for i=1:b
    a(i,1:N) = 16/3 * log2(max(X(:,1:N)).^(3/4)/MQ);
end
[S,Pe,flag] = innerQuant(a,X,w_low,w_high);

while any(any(Pe<T)) && flag
    add = Pe<T;
    a = a + add;
    [S,Pe,flag] = innerQuant(a,X,w_low,w_high);
end
G(1,1:N) = a(1,1:N);
sfc(1,:) = G;
sfc(2:b,:) = diff(a);
S = reshape(S, [1024,1]);