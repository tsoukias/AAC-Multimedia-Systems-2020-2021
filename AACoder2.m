function [AACSeq2] = AACoder2(fNameIn)
AACSeq1 = AACoder1(fNameIn);
K = length(AACSeq1);
for i=1:K
    AACSeq2(i).frameType = AACSeq1(i).frameType;
    AACSeq2(i).winType = AACSeq1(i).winType;
    [AACSeq2(i).chl.frameF, AACSeq2(i).chl.TNScoeffs] = TNS(AACSeq1(i).chl.frameF, AACSeq2(i).frameType);
    [AACSeq2(i).chr.frameF, AACSeq2(i).chr.TNScoeffs] = TNS(AACSeq1(i).chr.frameF, AACSeq2(i).frameType);
end
end

