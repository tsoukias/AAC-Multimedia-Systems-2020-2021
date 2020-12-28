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
%% Process for Long Frame
% Step1
x = spreadingfun(i,j,bval);
% Step 2: Multiplication with Hann Window
index = 10;
S = reshape(frame_W(index,:,1),[2048,1]);
N = length(S);
Sw = S.*hann(N);
%plot(S);
%figure();
%plot(Sw);
Sw_fft = fft(Sw);
r(1:1024,1) = abs(Sw(1:1024));
r2(1:2048,1) = abs(Sw(1:2048));
f(1:1024,1) = angle(Sw(1:1024));

