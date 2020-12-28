function [frameFout,TNScoeffs] = TNS(frameFin,frameType)
%Inputs:
%frameFin ->    can either be 1024x1 or 128x8 for Long or Short Frame
%               accordingly
%
%frameType ->   can be {'OLS','LSS','ESH','LPS'}

%Outputs:
%frameFout ->   FIR filtered frameFin according to Temporal Noise Shaping
%               can either be 1024x1 or 128x8 for Long or Short Frame
%               accordingly
%                         
%TNSCoeffs ->   Coefficients of the FIR filter. Compulsory for iTNS.
%
%IMPORTANT: FOR THE OPERATION OF THE FUNCTION TableB219.mat MUST BE USED.
%THESE CAN BE FOUND ON w2203tfa.pdf
%Function [a_quantized] = myquantizer(a) IS USED FOR QUANTIZATION OF THE
%COEFFICIENTS. 

X = frameFin;
%% Auxilary Variables
B219 = load('TableB219.mat');
B219a = B219.B219a;
B219b = B219.B219b;
Nb_l = length(B219a);
w_l = B219a(:,2:3);
P_l = zeros(Nb_l,1);
Nb_s = length(B219b);
w_s = B219b(:,2:3);
P_s = zeros(Nb_s,1);
%% Step 1
P = zeros(69,1);
if isequal(frameType,'ESH')
    Sw = zeros(128,8);
    for i=1:8
        for j=1:Nb_s
            P_s(j,i) = sum(X(w_s(j,1)+1:w_s(j,2),i).^2);
        end
        for j=1:Nb_s
            Sw(w_s(j,1)+1:w_s(j,2)+1,i) = sqrt(P_s(j,i));
        end
        for k=127:-1:1
            Sw(k,i) = (Sw(k,i)+Sw(k+1,i))/2;
        end
        for k=2:128
            Sw(k,i) = (Sw(k,i)+Sw(k-1,i))/2;
        end
    end
    Xw = X./Sw;
else %% LONG FRAME
    for j=1:Nb_l
        P_l(j) = sum(X(w_l(j,1)+1:w_l(j,2)).^2);
    end

    for j=1:Nb_l
        Sw(w_l(j,1)+1:w_l(j,2)+1,1) = sqrt(P_l(j));
    end

    for k=1023:-1:1
        Sw(k) = (Sw(k)+Sw(k+1))/2;
    end
    for k=2:1024
        Sw(k) = (Sw(k)+Sw(k-1))/2;
    end
    Xw = X./Sw;
end

%% Step 2-3 Calculating the filter's coefficients 
if isequal(frameType,'ESH')
    TNScoeffs = zeros(4,8);
    frameFout = zeros(128,8);
    for i=1:8
        temp_a = lpc(Xw(:,i),4);
        a = temp_a(2:end);
        TNScoeffs(:,i) = myquantizer(a);
        aug_coeffs = [1;TNScoeffs(:,1)];
        frameFout(:,i) = filter(aug_coeffs,1,X(:,i));
    end
else
    temp_a = lpc(Xw,4);
    a = temp_a(2:end);
    TNScoeffs = myquantizer(a);
    aug_coeffs = [1;TNScoeffs];
    frameFout = filter(aug_coeffs,1,X);
end


end

