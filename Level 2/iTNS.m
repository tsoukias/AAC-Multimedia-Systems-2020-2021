function [frameFout] = iTNS(frameFin,frameType,TNScoeffs)
%The function applies the inverse procedure of TNS function by appling the
%inverse filter.
%Inputs:
%frameFin -> MDCT coefficients of the respective frame
%frameType -> can be {'OLS','LSS','ESH','LPS'}
%TNScoeffs -> coefficients of the FIR filter
%Outputs:
%frameFout -> can either be 1024x1 or 128x8 for Long or Short Frame
%accordingly
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

