function [x] = iAACoder2(AACSeq2,fNameOut)
K = length(AACSeq2);
for(i=1:K)
    AACSeq2(i).chl.frameF = iTNS(AACSeq2(i).chl.frameF,AACSeq2(i).frameType,AACSeq2(i).chl.TNScoeffs);
    AACSeq2(i).chr.frameF = iTNS(AACSeq2(i).chr.frameF,AACSeq2(i).frameType,AACSeq2(i).chr.TNScoeffs);
end
song = iAACoder1(AACSeq2,fNameOut);
audiowrite(fNameOut,song,48000);
if nargout==1
    x=song;
end
end

