function [w] = SIN_W(N,part)
%Inputs:
%N -> size of the window to be created
%part -> can be {left,right,all}
%Output:
%w -> window
w_temp = zeros(N,2);
for n = 1:N
    w_temp(n,:) = sin(pi/N*((n-1)+1/2));
end
if isequal(part,'left')
    w(1:N/2,:) = w_temp(1:N/2,:);
elseif isequal(part,'right')
    w(1:N/2,:) = w_temp(N/2+1:N,:);
elseif isequal(part, 'all')
    w = w_temp;
end
end

