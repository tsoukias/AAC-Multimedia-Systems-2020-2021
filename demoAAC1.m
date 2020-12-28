function [SNR] = demoAAC1(fNameIn,fNameOut)
% Function for demonstation of the AAC encoding-decoding process
% Inputs:
% fNameIn -> name of the input audiofile 
% fNameOut -> name of the output audiofile

% Output:
% SNR -> 2x1 matrix with the SNR values channels 0 and 1 accordingly
[y1] = audioread(fNameIn);
AACSeq1 = AACoder1(fNameIn);



y2 = iAACoder1(AACSeq1,fNameOut);


signal_left = y1(:,1);
signal_right = y1(:,2);
noise_left = y1(:,1)-y2(:,1);
noise_right = y1(:,2)-y2(:,2);
fprintf('SNR for channel 0: %.2fdB\n', snr(signal_left,noise_left));
fprintf('SNR for channel 1: %.2fdB\n', snr(signal_right,noise_right));
SNR = [snr(signal_left,noise_left) snr(signal_right,noise_right)];
end

