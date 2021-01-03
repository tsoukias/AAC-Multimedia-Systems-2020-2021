clc;
close all;
clear all;
%% Preprocessing of the wav file
fNameIn = 'LicorDeCalandraca.wav';
fnameAACoded = 1;
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
frameF_copy = iAACquantizer(S, sfc, G, frameType);

tic;
AACSeq3 = AACoder3(fNameIn, fnameAACoded);
toc;

