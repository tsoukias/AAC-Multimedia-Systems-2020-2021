function frameF = filterbank(frameT, frameType, winType)
%Inputs:
%frameT -> frame to be converted with mdct transformation
%frameType -> can be {'OLS', 'LSS', 'ESH', 'LPS'} 
%winType -> can be {'SIN', 'KBD'}
%Output:
%frameF -> The frame is being converted and the mdct coefficent are
%extracted based on the frameType and the winType

%Also check SIN_W,KBD and mdct functions

switch frameType
    case 'OLS'
        w = zeros(2048,2);
        switch winType
            case 'SIN'
                w(1:2048,:) = SIN_W(2048,'all');
            case 'KBD'
                w = KBD(2048,6*pi);
        end
        frameF = mdct(w.*frameT);
    case 'LSS'
        w = zeros(2048,2);
        switch winType
            case 'SIN'
                w(1:1024,:) = SIN_W(2048,'left');
                w(1025:1472,:) = 1;
                w(1473:1600,:) = SIN_W(256,'right');
                w(1601:2048,:) = 0;
                frameF = mdct(w.*frameT);
            case 'KBD'
                w = zeros(2048,1);
                temp_w = KBD(2048,6*pi);
                w(1:1024,1) = temp_w(1:1024);
                w(1025:1472,1) = 1;
                temp_sw = KBD(256,4*pi);
                w(1473:1600,1) = temp_sw(129:256);
                w(1601:2048,1) = 0;
                frameF = mdct(w.*frameT);
        end
        case 'LPS'
            w = zeros(2048,2);
            switch winType
                case 'SIN'
                    w(1:448,:) = 0;
                    w(449:576,:) = SIN_W(256,'left');
                    w(577:1024,:) = 1;
                    w(1025:2048,:) = SIN_W(2048,'right');
                    frameF = mdct(w.*frameT);
                case 'KBD'
                    w(1:448,:) = 0;
                    temp_sw = KBD(256,4*pi);
                    w(449:576,:) = temp_sw(1:128,:);
                    w(577:1024,:) = 1;
                    temp_w = KBD(2048,6*pi);
                    w(1025:2048,:) = temp_w(1025:2048,:);
                    frameF = mdct(w.*frameT);
            end
    case 'ESH'
        frameF = zeros(1024,2);
        subframeT = zeros(128,2);
        switch winType
            %w = zeros(256,2);
            case 'SIN'
                w(1:256,:) = SIN_W(256,'all');
                frameT_center(1:1152,:) = frameT(449:1600,:);
                for i=0:7
                    subframeT(1:256,:) = frameT_center(i*128+1:i*128+256,:);
                    subframeT = subframeT.*w;
                    frameF(i*128+1:i*128+128,1) = mdct(subframeT(:,1)); 
                    frameF(i*128+1:i*128+128,2) = mdct(subframeT(:,2));
                end
                
            case 'KBD'
                w(1:256,:) = KBD(256,4*pi);
                frameT_center(1:1152,:) = frameT(449:1600,:);
                for i=0:7
                    subframeT(1:256,:) = frameT_center(i*128+1:i*128+256,:);
                    subframeT = subframeT.*w;
                    frameF(i*128+1:i*128+128,1) = mdct(subframeT(:,1)); 
                    frameF(i*128+1:i*128+128,2) = mdct(subframeT(:,2));
                end
        end
end
end


