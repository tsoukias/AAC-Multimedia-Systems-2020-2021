function [kbdWin] = KBD(N,b)
    % KDB Window Generator
    w1 = kaiser(N/2+1,b);
    d = sum(w1(1:N/2+1));
    kbdWin = zeros(N, 2);
    for n = 1:N/2
        kbdWin(n, :) = sqrt(sum(w1(1:n))/d);
    end
    kbdWin(N/2+1:N, :)= kbdWin(N/2:-1:1,:);
end

