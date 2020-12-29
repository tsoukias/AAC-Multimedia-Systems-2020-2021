function [r,f] = SHORT_FFT(frameT)
%Input: 
%frameT[2048,1] is an ESH frame 
%
%Outputs:
%r[128,8] contains the complex magnitude of the first 128 frequencies
%of the FFT transformation for each one of the 8 subframes of the ESH frame
%
%f[128,8] contains the phase angle of the first 128 frequencies
%of the FFT transformation for each one of the 8 subframes of the ESH frame

frameT_center(1:1152,:) = frameT(449:1600,:);
S = zeros(256,8);
for i=0:7
    S(:,i+1) = frameT_center(i*128+1:i*128+256,:);
end
N = length(S);
hann_win(1:N,1) = 0.5 - 0.5*(cos(pi/N*((0:N-1)+0.5)));
Sw(:,1:8) = S(:,1:8).*hann_win;
Sw_fft(:,1:8) = fft(Sw(:,1:8));
r(1:128,1:8) = abs(Sw_fft(1:128,1:8));
f(1:128,1:8) = angle(Sw_fft(1:128,1:8));
end

