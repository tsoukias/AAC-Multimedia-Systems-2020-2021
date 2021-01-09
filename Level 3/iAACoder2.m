function [x] = iAACoder2(AACSeq2,fNameOut)
%Makes the decoding of Step 2
%Input:
%AACSeq2 -> struct as defined in the mm-hw-2021.pdf file
%fNameOut -> '*.wav' name file of the decoded wav audio with Fs = 48kHz
%Output:
%x -> is the decoded signal 
K = length(AACSeq2);
for(i=1:K)
    AACSeq2(i).chl.frameF = iTNS(AACSeq2(i).chl.frameF,AACSeq2(i).frameType,AACSeq2(i).chl.TNScoeffs);
    AACSeq2(i).chr.frameF = iTNS(AACSeq2(i).chr.frameF,AACSeq2(i).frameType,AACSeq2(i).chr.TNScoeffs);
end
song = iAACoder1(AACSeq2,fNameOut);
if nargout==1
    x=song;
end
end

