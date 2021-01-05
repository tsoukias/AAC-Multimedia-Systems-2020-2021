function x = iAACoder3(AACSeq3, fNameOut)
%Makes the decoding of Step 3
%Input:
%AACSeq3 -> struct as defined in the mm-hw-2021.pdf file
%fNameOut -> '*.wav' name file of the decoded wav audio with Fs = 48kHz
%Output:
%x -> is the decoded signal

%load(AACSeq3);
K = length(AACSeq3);

huffLUT = loadLUT();
for i=1:K
    Sl(:,1) = decodeHuff(AACSeq3(i).chl.stream, AACSeq3(i).chl.codebook, huffLUT);
    Sr(:,1) = decodeHuff(AACSeq3(i).chr.stream, AACSeq3(i).chr.codebook, huffLUT);
    if isequal(AACSeq3(i).frameType,'ESH')
        sfcl = reshape(decodeHuff(AACSeq3(i).chl.sfc, 12, huffLUT),[42 8]);
        sfcr = reshape(decodeHuff(AACSeq3(i).chr.sfc, 12, huffLUT),[42 8]);
    else
        sfcl = reshape(decodeHuff(AACSeq3(i).chl.sfc, 12, huffLUT),[69 1]);
        sfcr = reshape(decodeHuff(AACSeq3(i).chr.sfc, 12, huffLUT),[69 1]);
    end
    AACSeq3(i).chl.frameF = iAACquantizer(Sl, sfcl, AACSeq3(i).chl.G, AACSeq3(i).frameType);
    AACSeq3(i).chr.frameF = iAACquantizer(Sr, sfcr, AACSeq3(i).chr.G, AACSeq3(i).frameType);
end
song = iAACoder2(AACSeq3,fNameOut);
if nargout==1
    x=song;
end
end