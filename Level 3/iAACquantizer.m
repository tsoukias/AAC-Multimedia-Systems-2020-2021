function frameF = iAACquantizer(S, sfc, G, frameType)
%The function applies the inverse procedure of AACquantizer() function
%Inputs:
%S -> result of the quantizer 
%sfc -> scale factors of the frame after DPCM
%G -> gain factor of the frame 
%frameType-> can be {'OLS', 'LSS', 'ESH', 'LPS'} 
%Output: 
%frameF -> Approximation of the frameF before the AACQuantizer 
B219_all = load('TableB219.mat');
if isequal(frameType, 'ESH')
    B219 = B219_all.B219b;
    S = reshape(S,[128 8]);
    N = 8;
else
    B219 = B219_all.B219a;
    N = 1;
end
w_low = B219(:,2);
w_high = B219(:,3);
b = length(sfc);
a = zeros(size(sfc));
a(1,:) = G;
for i = 2:b
    a(i,:) = a(i-1,:)+sfc(i,:);
end
frameF = zeros(size(S));
for n=1:N
    for i=1:b
        frameF(w_low(i)+1:w_high(i)+1,n) = sign(S(w_low(i)+1:w_high(i)+1,n)) .* abs(S(w_low(i)+1:w_high(i)+1,n)).^(4/3) * 2^(1/4*a(i,n));
    end
end
end