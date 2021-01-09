function [SNR, bitrate, compression] = demoAAC3(fNameIn, fNameOut, frameAACoded)
% Function for demonstation of the AAC encoding-decoding process with TNS
% Inputs:
% fNameIn -> name of the input audiofile 
% fNameOut -> name of the output audiofile
% frameAACoded -> '*.mat' file of the AACSeq3 struct
% Output:
% SNR -> 2x1 matrix with the SNR values channels 0 and 1 accordingly
% bitrate -> 2x1 matrix with the bitrate before and after compression in
% bits/s
% compression -> contains the compression ratio
AACSeq3 = AACoder3(fNameIn, frameAACoded);
[y1, Fs] = audioread(fNameIn);
N = length(y1);
duration = N/Fs;
y = iAACoder3(AACSeq3, fNameOut);
y2(1:length(y1),:)= y(1:length(y1),:);
%y2 = y2./max(abs(y2));
% Calculation of SNRs
signal_left = y1(:,1);
signal_right = y1(:,2);
noise_left = y1(:,1)-y2(:,1);
noise_right = y1(:,2)-y2(:,2);

SNR = [snr(signal_left,noise_left) snr(signal_right,noise_right)];
% Calculation of bitrates
info_uncomp = dir(fNameIn);
size_uncomp = info_uncomp.bytes*8;
bitrate_uncomp = size_uncomp/duration;

%% Ignoring all the unnecessary objects
for i=1:length(AACSeq3)
    AACSeqCount(i).frameType = AACSeq3(i).frameType;
    AACSeqCount(i).winType = AACSeq3(i).winType;
    AACSeqCount(i).chl.stream = AACSeq3(i).chl.stream;
    AACSeqCount(i).chl.G = AACSeq3(i).chl.G;
    AACSeqCount(i).chl.TNScoeffs = AACSeq3(i).chl.TNScoeffs;
    AACSeqCount(i).chl.sfc = AACSeq3(i).chl.sfc;
    AACSeqCount(i).chl.codebook = AACSeq3(i).chl.codebook;
    AACSeqCount(i).chr.stream = AACSeq3(i).chr.stream;
    AACSeqCount(i).chr.G = AACSeq3(i).chr.G;
    AACSeqCount(i).chr.TNScoeffs = AACSeq3(i).chr.TNScoeffs;
    AACSeqCount(i).chr.sfc = AACSeq3(i).chr.sfc;
    AACSeqCount(i).chr.codebook = AACSeq3(i).chr.codebook;
end
save('countme.mat', 'AACSeqCount');
info_comp = dir('countme.mat');
size_comp = info_comp.bytes*8;
bitrate_comp = size_comp/duration;

bitrate = [bitrate_uncomp bitrate_comp] ; 
compression = bitrate_uncomp/bitrate_comp ;

fprintf('SNR for channel 0: %.2fdB\n', snr(signal_left,noise_left));
fprintf('SNR for channel 1: %.2fdB\n', snr(signal_right,noise_right));
fprintf('Bitrate of uncompressed audio: %.1f Kbits/s\n', bitrate_uncomp/1000);
fprintf('Bitrate of compressed audio: %.1f Kbits/s\n', bitrate_comp/1000);
fprintf('Compression ratio: %.3f\n', compression);
end