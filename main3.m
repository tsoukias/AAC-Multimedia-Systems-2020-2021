clc;
close all;
clear all;
%% Preprocessing of the wav file
fNameIn = 'LicorDeCalandraca.wav';
frameAACoded = 'AACSeq3';
fNameOut = 'stef3.wav';


[SNR, bitrate, compression] = demoAAC3(fNameIn, fNameOut, frameAACoded);
load('AACSeq3');