function [SNR, bitrate, compression] = demoAAC3(fNameIn, fNameOut, frameAACoded)
tic;
%AACSeq3 = AACoder3(fNameIn, frameAACoded);
toc;
y2 = iAACoder3(frameAACoded, fNameOut);
y1 = audioread(fNameIn);
signal_left = y1(:,1);
signal_right = y1(:,2);
noise_left = y1(:,1)-y2(:,1);
noise_right = y1(:,2)-y2(:,2);
fprintf('SNR for channel 0: %.2fdB\n', snr(signal_left,noise_left));
fprintf('SNR for channel 1: %.2fdB\n', snr(signal_right,noise_right));
SNR = [snr(signal_left,noise_left) snr(signal_right,noise_right)];
info = audioinfo(fNameIn);
bitrate_bef = (info.NumChannels * info.SampleRate * info.BitsPerSample)/1000000;
load('AACSeq3.mat');
%{
for i=1:length(AACSeq3)
    AACSeqF(i).chl.sfc = AACSeq3(i).chl.sfc;
    AACSeqF(i).chr.sfc = AACSeq3(i).chr.sfc;
    AACSeqF(i).chl.stream = AACSeq3(i).chl.stream;
    AACSeqF(i).chr.stream = AACSeq3(i).chr.stream;
end
S = whos('AACSeq3');
S.bytes;
%}
bitrate =1 ; compression =1;
end