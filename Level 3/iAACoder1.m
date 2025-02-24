function [x] = iAACoder1(AACSeq1,fNameOut)
%Makes the decoding of Step 1
%Input:
%AACSeq1 -> struct as defined in the mm-hw-2021.pdf file
%fNameOut -> '*.wav' name file of the decoded wav audio with Fs = 48kHz
%Output:
%x -> is the decoded signal 

Fs = 48000;
K = length(AACSeq1);
frameT = zeros(K,2048,2);
reconstructed_x = zeros(K*1024+2048,2);
for i=1:K
    if isequal(AACSeq1(i).frameType, 'ESH')
        for n = 0:7
            frameF(n*128+1:n*128+128,1) = AACSeq1(i).chl.frameF(:,n+1);
            frameF(n*128+1:n*128+128,2) = AACSeq1(i).chr.frameF(:,n+1);
        end
    else
        frameF(:,1) = AACSeq1(i).chl.frameF;
        frameF(:,2) = AACSeq1(i).chr.frameF;
    end

    frameT(i,:,:) = iFilterbank(frameF, AACSeq1(i).frameType, AACSeq1(i).winType);
    temp_val(1:2048,1:2) = frameT(i,:,:);
    reconstructed_x((i-1)*1024+1:(i-1)*1024+2048,:) = reconstructed_x((i-1)*1024+1:(i-1)*1024+2048,:)+  temp_val(:,:);
    
end

y(:,:) = reconstructed_x(1025:end,:);
%y = y./max(abs(y));
y(y>1)=1;
y(y<-1)=-1;
if nargout
    x=y;
end
audiowrite(fNameOut,y,Fs);
end

