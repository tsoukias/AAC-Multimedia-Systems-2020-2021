clc;
close all;
clear all;
%% Read wav file 
[y, Fs] = audioread('LicorDeCalandraca.wav');
sound(y,Fs);

%% Create frames
y1 = zeros(ceil(length(y)/1024)*1024 - length(y),2);
y = [y;y1];
y1 = [zeros(1024,2)];
y = [y1;y];


left = 1;
for(i=1:length(y)/1024-1)
    right = left + 2047;
    frameT1(i,1:2048,:) = y(left:right,:);
    left = right - 1023;
end
frameT(:,:) = frameT1(70,:,:);

%nextFrameT(:,:) = frameT1(71,:,:);
prevFrameType = 'OLS';
%SSC(frameT,nextFrameT,prevFrameType)


countESH = 0;
for(i=1:276)
    frameT(:,:) = frameT1(i,:,:);
    nextFrameT(:,:) = frameT1(i+1,:,:);
    prevFrameType = SSC(frameT,nextFrameT,prevFrameType);
    frameType{i,1} = prevFrameType;
    if isequal(prevFrameType,'ESH')
        countESH=countESH+1;
        i;
    end  
end


%plot(nextFrameT)