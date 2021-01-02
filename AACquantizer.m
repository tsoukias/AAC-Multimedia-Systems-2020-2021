function [S, sfc, G] = AACquantizer(frameF, frameType, SMR)
X = frameF;
B219_all = load('TableB219.mat');
if isequal(frameType, 'ESH')
    B219 = B219_all.B219b;
    [k,N] = size(X);
else
    B219 = B219_all.B219a;
    X = frameF;
    [k,N] = size(X);
end
b = length(SMR);
w_low = B219(:,2);
w_high = B219(:,3);
%% Calculation of T
P = zeros(b,N);
for j=1:N
    for i=1:b
        P(i,j) = sum(X(w_low(i)+1:w_high(i)+1,j).^2);
    end
end
T = P./SMR;
%% Step 1: Calculation of a,S and X_hat
MQ = 8191;
a = zeros(b,N);
for i=1:b
    a(i,1:N) = 16/3 * log2(max(X(:,1:N)).^(3/4)/MQ);
end

%[S,Pe,flag] = innerQuant(a,X,w_low,w_high);


[S,Pe,flag] = innerQuant(a,X,w_low,w_high);


while any(any(Pe<T)) && flag
    add = Pe<T;
    a = a + add;
    [S,Pe,flag] = innerQuant(a,X,w_low,w_high);
end
G(1,1:N) = a(1,1:N);
sfc(1,:) = G;
sfc(2:b,:) = diff(a);
S = reshape(S, [1024,1]);
end
