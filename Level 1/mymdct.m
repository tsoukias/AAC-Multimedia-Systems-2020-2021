function y = mymdct(x)
[N , M] = size(x);
n0 = (N/2 + 1)/2;
y = zeros(N/2,M);
for k=1:N/2
    for n=1:N
        y(k,1) = y(k,1) + 2 * x(n,1) * cos(2*pi/N* ((n-1)+n0)*((k-1)+1/2));
    end
end
end
