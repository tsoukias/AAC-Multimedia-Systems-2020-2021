clc;
close all;
clear all;

fNameIn = 'LicorDeCalandraca.wav';
frameAACoded = 'AACSeq3';
fNameOut = 'out.wav';
[SNR, bitrate, compression] = demoAAC3(fNameIn, fNameOut, frameAACoded);
