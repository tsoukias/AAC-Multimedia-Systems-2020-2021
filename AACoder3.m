function AACSeq3 = AACoder3(fNameIn, fnameAACoded)
%% Load of B219 matrixes
AACSeq2 = AACoder2(fNameIn);
B219_all = load('TableB219.mat');
%% Reading the audiofile
[y, Fs] = audioread(fNameIn);
y = y./max(abs(y));
%% Create frames
zero_padding = zeros(1024,2);
N = length(y);
y1 = zeros(1024-mod(N,1024),2);
y = [y;y1];
y = [zero_padding;y;zero_padding];
K = length(y)/1024-1;
frame_W = zeros(K,2048,2);
for i=1:K
    frame_W(i,1:2048,:) = y(i*1024-1023:i*1024+1024,:);
end

%% Calculation of SMR for every frame 
% For the calculation of the SMR, 2 previous frames are needed 
% so we give 'OLS' zero-padded frames
for index=1:length(AACSeq2)
    if index<=2
        frameT(:,1) = frame_W(index,:,1);
        frameType = AACSeq2(index).frameType;
        frameTprev1(:,1) = frame_W(1,:,1);
        frameTprev2(:,1) = frame_W(1,:,1);
        SMR(index).left = psycho(frameT, frameType, frameTprev1, frameTprev2); 
        frameT(:,1) = frame_W(index,:,2);
        frameType = AACSeq2(index).frameType;
        frameTprev1(:,1) = frame_W(1,:,2);
        frameTprev2(:,1) = frame_W(1,:,2);
        SMR(index).right = psycho(frameT, frameType, frameTprev1, frameTprev2); 
    else
        frameT(:,1) = frame_W(index,:,1);
        frameType = AACSeq2(index).frameType;
        frameTprev1(:,1) = frame_W(index-1,:,1);
        frameTprev2(:,1) = frame_W(index-2,:,1);
        SMR(index).left = psycho(frameT, frameType, frameTprev1, frameTprev2);
        frameT(:,1) = frame_W(index,:,2);
        frameType = AACSeq2(index).frameType;
        frameTprev1(:,1) = frame_W(index-1,:,2);
        frameTprev2(:,1) = frame_W(index-2,:,2);
        SMR(index).right = psycho(frameT, frameType, frameTprev1, frameTprev2);
    end
end
huffLUT = loadLUT();
for i=1:length(AACSeq2)
    AACSeq3(i).frameType = AACSeq2(i).frameType;
    AACSeq3(i).winType = AACSeq2(i).winType;
    AACSeq3(i).chl = AACSeq2(i).chl;
    AACSeq3(i).chr = AACSeq2(i).chr;
    [Sl, sfcl, AACSeq3(i).chl.G] = AACquantizer(AACSeq2(i).chl.frameF, AACSeq3(i).frameType, SMR(i).left);
    [Sr, sfcr, AACSeq3(i).chr.G] = AACquantizer(AACSeq2(i).chr.frameF, AACSeq3(i).frameType, SMR(i).right);
    AACSeq3(i).chl.sfc = encodeHuff(sfcl(:), huffLUT, 12);
    AACSeq3(i).chr.sfc = encodeHuff(sfcr(:), huffLUT, 12);
    [AACSeq3(i).chl.stream, AACSeq3(i).chl.codebook] = encodeHuff(Sl, huffLUT);
    [AACSeq3(i).chr.stream, AACSeq3(i).chr.codebook] = encodeHuff(Sr, huffLUT);
    
end
save(fnameAACoded, 'AACSeq3');
end