clc;
close all;
clear all;
fNameIn = 'LicorDeCalandraca.wav';
fNameOut = 'stef.wav';

[y1,Fs] = audioread(fNameIn);
y2 = iAACoder1(AACoder1(fNameIn),fNameOut);

signal_left = y1(:,1);
signal_right = y1(:,2);

noise_left = y1(:,1)-y2(:,1);
noise_right = y1(:,2)-y2(:,2);
%plot(noise_left);
snr(signal_left,noise_left)
snr(signal_right,noise_right)