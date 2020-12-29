function [x] = spreadingfun(i,j,bval)
if i>=j
    tmpx = 3*(bval(j)-bval(i));
else
    tmpx = 3/2*(bval(j)-bval(i));
end
tmpz = 8*min((tmpx-0.5)^2 - 2*(tmpx-0.5),0);
tmpy = 15.811389 + 7.5*(tmpx+0.474)-17.5*sqrt(1 + (tmpx+0.474)^2);
if tmpy<-100
    x=0;
else
    x=10^(1/10*(tmpz+tmpy));
end

end

