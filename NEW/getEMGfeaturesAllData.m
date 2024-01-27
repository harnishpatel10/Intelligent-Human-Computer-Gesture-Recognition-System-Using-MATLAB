
% INPUTS: filtEMG - EMG data (number_of_channels x number_of_samples)
%         windowsize - length of raw emg sample windows
%         stepsize - # of samples shifted per window (overlap = window-step)
% 
% OUTPUT: EMGobj - object holding EMG features per channel 
%         EMGobj.TD - per-channel TD5 features(number_of_channels*5 x " ")
%         EMGobj.FFT - per-channel FFTs (number_of_channels*fftLength x " ")
%         EMGobj.AR - per-channel auto-regressive (number_of_channels*ARdegree x " ")

function EMGobj = getEMGfeaturesAllData(filtEMG, windowsize, stepsize)
%     windowsize = 150; % ms window % p. 647 "EMG pattern rec for control of powered upper-limb prostheses: state of the art..."
%     stepsize = 25; % sample overlap of raw emg
    dataLength = size(filtEMG,2);
    fftLength = 256;
    ARdegree = 6;
    j = 0;  
    vec = windowsize:stepsize:dataLength;
    for i = vec
        j = j+1;
        sampleEMG = filtEMG(:,i-windowsize+1:i);
        EMGtemp = getEMGfeaturesTD(sampleEMG);
        EMGobj.MAV(:,j) = EMGtemp.MAV;
        EMGobj.TD(:,j) = [EMGtemp.MAV; EMGtemp.WL; EMGtemp.VAR; EMGtemp.SSC; EMGtemp.ZC]; 
     
         %%% Unmask below as needed to get other feature sets
%         EMGobj.FFT(:,j) = getEMGfeaturesFFT(sampleEMG, fftLength); 
%         EMGobj.AR(:,j) = getEMGfeaturesAR(sampleEMG, ARdegree);
    end
    
    %% Normalize - called Min-max feature scaling (must use trainmins and maxes for incoming test data)
%     TrainMin.TD = min(EMGobj.TD,[],2);
%     EMGobj.TD = bsxfun(@minus,EMGobj.TD,TrainMin.TD);
%     TrainMax.TD = max(EMGobj.TD,[],2);
%     EMGobj.TD = bsxfun(@rdivide,EMGobj.TD,TrainMax.TD);
%     
%     TrainMin.FFT = min(EMGobj.FFT,[],2);
%     EMGobj.FFT = bsxfun(@minus,EMGobj.FFT,TrainMin.FFT);
%     TrainMax.FFT = max(EMGobj.FFT,[],2);
%     EMGobj.FFT = bsxfun(@rdivide,EMGobj.FFT,TrainMax.FFT);
%     
%     TrainMin.AR = min(EMGobj.AR,[],2);
%     EMGobj.AR = bsxfun(@minus,EMGobj.AR,TrainMin.AR);
%     TrainMax.AR = max(EMGobj.AR,[],2);
%     EMGobj.AR = bsxfun(@rdivide,EMGobj.AR,TrainMax.AR);
end