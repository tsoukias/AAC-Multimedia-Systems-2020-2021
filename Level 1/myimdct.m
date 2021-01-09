function y = myimdct(x)
N = 2*length(x);
n0 = (N/2 + 1)/2;
y = zeros(N,1);
for n=1:N
    for k=1:N/2
        y(n,1) = y(n,1) + 2/N * x(k,1) * cos(2*pi/N* ((n-1)+n0)*((k-1)+1/2));
    end
end

end
