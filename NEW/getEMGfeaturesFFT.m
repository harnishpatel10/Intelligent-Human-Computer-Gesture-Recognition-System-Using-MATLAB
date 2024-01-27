
% INPUTS: filtEMG - EMG data (number_of_channels x number_of_samples)
%         fftLength - usually 256

function [EMG_FFT] = getEMGfeaturesFFT(filtEMG, fftLength)
    numEMGchannels = size(filtEMG,1);
    fftHalflength = floor(fftLength/2);
%     tic
    EMG_FFT = zeros(numEMGchannels * fftHalflength, 1);
    for i = 1:numEMGchannels % for each channel
        sample = filtEMG(i,:);        
         % Fast Fourier Transform (FFT)
        fftsample = fft(sample,fftLength);
%         plot(abs(fftsample(1:floor(fftLength/2))).^2); drawnow; % use to verify  
        EMG_FFT(((i-1)*fftHalflength + 1):i*fftHalflength) = abs(fftsample(1:fftHalflength))'; 
    end
%     toc
end