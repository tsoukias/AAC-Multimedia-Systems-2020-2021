function [AACSeq1] = AACoder1(fNameIn)
%% Preprocessing of the wav file
[y, Fs] = audioread(fNameIn);
%sound(y,Fs);

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

% I consider the 0-th frame to be 'OLS'
% Let's consider winType = 'SIN'
prevFrameType = 'OLS';
winType = 'SIN';
for i=1:K
    frameT(:,:) = frame_W(i,:,:);
    %If-statement because we can't compute the last's frame type 
    %so we consider it an OLS
    if i~=K 
        nextFrameT(:,:) = frame_W(i+1,:,:);
        prevFrameType = SSC(frameT, nextFrameT, prevFrameType);
    else
        prevFrameType = 'OLS';
    end
    AACSeq1(i).frameType = prevFrameType;
    AACSeq1(i).winType = winType;
    frameF = filterbank(frameT, prevFrameType, winType);
    
    if isequal(prevFrameType,'ESH')
        for n=1:8
            temp_l(1:128,n) = frameF((n-1)*128+1:(n-1)*128+128,1);
            temp_r(1:128,n) = frameF((n-1)*128+1:(n-1)*128+128,2);
        end
        AACSeq1(i).chl.frameF(1:128,1:8) = temp_l(:,:);
        AACSeq1(i).chr.frameF(1:128,1:8) = temp_r(:,:);
    else
        AACSeq1(i).chl.frameF=frameF(:,1);
        AACSeq1(i).chr.frameF=frameF(:,2);
    end
end
end

