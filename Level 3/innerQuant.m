function [S,Pe] = innerQuant(a,X,w_low,w_high)
%Inputs:
%a -> 69x1 or 42x8 contains the scalefactor gains
%X -> 1024x1 or 128x8 contains the MDCT coefficients 
%w_low -> is taken from the B219 matrix for 48kHz
%w_high -> is taken from the B219 matrix for 48kHz
%Outputs: 
%S -> 1024x1 quantization matrix
%Pe -> 1024x1 error power 
MagicNumber = 0.4054;
[k,N] = size(X);
b = length(a);
S = zeros(k,N);
X_hat = zeros(k,N);
Pe = zeros(b,N);
for n=1:N
    for i=1:b
        S(w_low(i)+1:w_high(i)+1,n) = sign(X(w_low(i)+1:w_high(i)+1,n)).*round((abs(X(w_low(i)+1:w_high(i)+1,n))*2^(-1/4*a(i,n))).^(3/4) + MagicNumber);
        X_hat(w_low(i)+1:w_high(i)+1,n) = sign(S(w_low(i)+1:w_high(i)+1,n)) .* abs(S(w_low(i)+1:w_high(i)+1,n)).^(4/3) * 2^(1/4*a(i,n));
        Pe(i,n) = sum((X(w_low(i)+1:w_high(i)+1,n)-X_hat(w_low(i)+1:w_high(i)+1,n)).^2);
    end
end
end

