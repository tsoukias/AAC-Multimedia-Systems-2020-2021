function [S,Pe,flag] = innerQuant(a,X,w_low,w_high)
MagicNumber = 0.4054;
[k,N] = size(X);
b = length(a);
S = zeros(k,N);
X_hat = zeros(k,N);
for j=1:b
    for i=1:N
        S(:,i) = sign(X(:,i)) .* round(abs(X(:,i))*2^(-1/4*a(j,i))^(3/4)+MagicNumber);
        X_hat(:,i) = sign(S(:,i)) .* abs(S(:,i)).^(3/4) * 2^(1/4*a(j,i));
    end
end

Pe = zeros(b,N);
for j=1:N
    for i=1:b
        Pe(i,j) = sum((X(w_low(i)+1:w_high(i)+1,j)-X_hat(w_low(i)+1:w_high(i)+1,j)).^2);
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

