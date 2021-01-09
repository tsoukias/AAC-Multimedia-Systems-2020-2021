function [a_quantized] = myquantizer(a)
%4-bit Uniform Symmetrical Quantizer
%with 0.1 step 
%Input: 
%a -> 4x1 vector
%Output: 
%a_quantized -> 4x1 quantized vector

quantizer = [-0.7:0.1:0.7];
dist=zeros(4,15);
a_quantized = zeros(4,1);
for i=1:4
    for j=1:15
        dist(i,j) = abs(quantizer(j)-a(i));
    end
    temp = dist(i,:);
    [minimum, I] = min(temp);
    a_quantized(i) = quantizer(I);
end
end

