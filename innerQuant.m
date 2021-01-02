function [S,Pe,flag] = innerQuant(a,X,w_low,w_high)
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

flag=1;
for i=1:N
    for j=1:b-1
        if abs(a(j,i)-a(j+1,i))>59
            flag = 0;
        end
    end
end
end

