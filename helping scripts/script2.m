clc;
close all;
clear all;
%% Read wav file 
[y, Fs] = audioread('LicorDeCalandraca.wav');
%sound(y,Fs);

%% Create frames
y1 = zeros(ceil(length(y)/1024)*1024 - length(y),2);
y = [y;y1];
y1 = [zeros(1024,2)];
y = [y1;y];


left = 1;
for(i=1:length(y)/1024-1)
    right = left + 2047;
    frameT1(i,1:2048,:) = y(left:right,:);
    left = right - 1023;
end
frameT(:,:) = frameT1(2,:,:);

%frameF = filterbank(frameT, 'LSS', 'SIN');
%frameTest = iFilterbank(frameF, 'ESH', 'KBD');

%{
frameF = filterbank(frameT, 'OLS', 'SIN');
frameTest = iFilterbank(frameF, 'OLS', 'SIN');
frameF = filterbank(frameT, 'OLS', 'KBD');
frameTest = iFilterbank(frameF, 'OLS', 'KBD');
frameF = filterbank(frameT, 'LSS', 'SIN');
frameTest = iFilterbank(frameF, 'LSS', 'SIN');
frameF = filterbank(frameT, 'LSS', 'KBD');
frameTest = iFilterbank(frameF, 'LSS', 'KBD');
frameF = filterbank(frameT, 'LPS', 'SIN');
frameTest = iFilterbank(frameF, 'LPS', 'SIN');
frameF = filterbank(frameT, 'LPS', 'KBD');
frameTest = iFilterbank(frameF, 'LPS', 'KBD');
frameF = filterbank(frameT, 'ESH', 'SIN');
frameTest = iFilterbank(frameF, 'ESH', 'SIN');
frameF = filterbank(frameT, 'ESH', 'KBD');
frameTest = iFilterbank(frameF, 'ESH', 'KBD');
%}

frame1(:,:) = frameT1(1,:,:);
frame2(:,:) = frameT1(2,:,:);
frame3(:,:) = frameT1(3,:,:);
frameF1 = filterbank(frame1,'ESH','KBD');
frameF2 = filterbank(frame2, 'LPS','KBD');
frameF3 = filterbank(frame3, 'OLS', 'KBD');
frame1N = iFilterbank(frameF1, 'ESH', 'KBD');
frame2N = iFilterbank(frameF2, 'LPS', 'KBD');
frame3N = iFilterbank(frameF3, 'OLS', 'KBD');

frame2N(1:1024,:) = frame2N(1:1024,:) + frame1N(1025:2048,:);
frame2N(1025:2048,:) = frame2N(1025:2048,:) + frame3N(1:1024,:);
noise = frame2(:,2)-frame2N(:,2);
snr(frame2(:,2),noise)
%plot(frame2N(:,1));
%figure();
%plot(frame2(:,1));
