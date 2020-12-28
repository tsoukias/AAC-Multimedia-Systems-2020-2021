function [frameFout] = iTNS(frameFin,frameType,TNScoeffs)
if isequal(frameType,'ESH')
    frameFout = zeros(128,8);
    for i=1:8
        aug_coeffs = [1;TNScoeffs(:,1)];
        frameFout(:,i) = filter(1,aug_coeffs,frameFin(:,i));
    end
else
    aug_coeffs = [1;TNScoeffs];
    frameFout = filter(1,aug_coeffs,frameFin);
end

end

