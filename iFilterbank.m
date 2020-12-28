function [frameT] = iFilterbank(frameF, frameType, winType)
switch frameType
    case 'OLS'
        w = zeros(2048,2);
        switch winType
            case 'SIN'
                w(1:2048,:) = SIN_W(2048,'all');
            case 'KBD'
                w = KBD(2048,6*pi);
        end
        frameTemp = imdct(frameF);
        frameT = frameTemp.*w;
    case 'LSS'
        w = zeros(2048,2);
        switch winType
            case 'SIN'
                w(1:1024,:) = SIN_W(2048,'left');
                w(1025:1472,:) = 1;
                w(1473:1600,:) = SIN_W(256,'right');
                w(1601:2048,:) = 0;
                frameTemp = imdct(frameF);
                frameT = frameTemp.*w;
            case 'KBD'
                w = zeros(2048,1);
                temp_w = KBD(2048,6*pi);
                w(1:1024,1) = temp_w(1:1024);
                w(1025:1472,1) = 1;
                temp_sw = KBD(256,4*pi);
                w(1473:1600,1) = temp_sw(129:256);
                w(1601:2048,1) = 0;
                frameTemp = imdct(frameF);
                frameT = frameTemp.*w;
        end
        case 'LPS'
            w = zeros(2048,2);
            switch winType
                case 'SIN'
                    w(1:448,:) = 0;
                    w(449:576,:) = SIN_W(256,'left');
                    w(577:1024,:) = 1;
                    w(1025:2048,:) = SIN_W(2048,'right');
                    frameTemp = imdct(frameF);
                    frameT = frameTemp.*w;
                case 'KBD'
                    w(1:448,:) = 0;
                    temp_sw = KBD(256,4*pi);
                    w(449:576,:) = temp_sw(1:128,:);
                    w(577:1024,:) = 1;
                    temp_w = KBD(2048,6*pi);
                    w(1025:2048,:) = temp_w(1025:2048,:);
                    frameTemp = imdct(frameF);
                    frameT = frameTemp.*w;
            end
    case 'ESH'
        frameT = zeros(2048,2);
        subframeT = zeros(8,256,2);
        for i = 0:7
            subframeT(i+1,:,1) = imdct(frameF(i*128+1:i*128+128,1));
            subframeT(i+1,:,2) = imdct(frameF(i*128+1:i*128+128,2));
         end
        switch winType
            case 'SIN'
                w(1:256,:) = SIN_W(256,'all');
                for i = 0:7
                   frameT(449+i*128:448+i*128+256,:) = frameT(449+i*128:448+i*128+256,:)+ reshape(subframeT(i+1,1:256,:),[256,2]) .* w; 
                end
                
            case 'KBD'
                w(1:256,:) = KBD(256,4*pi);
                for i = 0:7
                   frameT(449+i*128:448+i*128+256,:) = frameT(449+i*128:448+i*128+256,:)+ reshape(subframeT(i+1,1:256,:),[256,2]) .* w; 
                end
        end
end
end


