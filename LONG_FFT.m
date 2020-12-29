function [r,f] = LONG_FFT(frameT)
%Input: 
%frameT[2048,1] is a long frame 
%
%Outputs:
%r[1024,1] contains the complex magnitude of the first 1024 frequencies
%of the FFT transformation of the long frame
%
%f[1024,1] contains the phase angle of the first 128 frequencies
%of the FFT transformation of the long frame
S = frameT;
N = length(S);
hann_win(1:N,1) = 0.5 - 0.5*(cos(pi/(N)*((1:N)+0.5)));
Sw = S.*hann_win;
Sw_fft = fft(Sw);
r(1:1024,1) = abs(Sw_fft(1:1024));
f(1:1024,1) = angle(Sw_fft(1:1024));
end

