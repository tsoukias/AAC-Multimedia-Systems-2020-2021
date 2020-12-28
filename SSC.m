function frameType = SSC(frameT, nextFrameT, prevFrameType)
    %% First check if prevFrameType is either LSS or LPS
    if(isequal(prevFrameType,'LSS'))
        frameType = 'ESH';
        return;
    elseif (isequal(prevFrameType,'LPS'))
        frameType = 'OLS';
        return;
    end
    %% Create Filter
    b = [0.7548, -0.7548];
    a = [1, -0.5095];
    nextFrameT = filter(b,a,nextFrameT);
    %plot(nextFrameT);
    %% Calculate Energy and attack values for both channels of frame i+1
    blocks = reshape(nextFrameT(577:1600,:), [128,8,2]);
    s = reshape(sum(blocks.^2),[8,2]);
    ds = zeros(size(s));
    for i=2:8
        for k=1:2
            ds(i,k) = s(i,k) / (sum(s(1:i-1,k))/(i-1));
        end
    end
    %% Find if any of the channels is ESH
    
    
    isESH = any(s>1e-3 & ds>10);
    %% Determine the type of each channel for the i-th frame
    
    type = {0,0};
    for index=1:2
        if (isequal(prevFrameType,'OLS'))
            if(isESH(1,index))
              type(1,index) = {'LSS'};
            else
              type(1,index) = {'OLS'};
            end
        elseif (isequal(prevFrameType,'ESH'))
            if(isESH(1,index))
                type(1,index) = {'ESH'};
            else
                type(1,index) = {'LPS'};
            end
        end
    end
    
    %% Determine the type of the i-th frame from the type of each channel
    if isequal(type{1,1}, type{1,2})
        if isequal(type{1,1},'LPS')
            frameType = 'LPS';
        elseif isequal(type{1,1},'ESH')
            frameType = 'ESH';
        elseif isequal(type{1,1},'LSS')
            frameType = 'LSS';
        elseif isequal(type{1,1},'OLS')
            frameType = 'OLS';
        end
    else
        if (isequal(type{1,1},'OLS') || isequal(type{1,1},'LSS'))
            frameType = 'LSS';
        else
            frameType = 'ESH';
        end
    end     
    
end

