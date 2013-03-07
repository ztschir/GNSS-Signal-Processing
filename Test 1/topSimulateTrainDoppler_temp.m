% topSimulateTrainDoppler.m 
% 
% Top-level script for train Doppler simulation 
 
 
clear; clc; clf; 
%----- Setup 
fh = 440; 
vTrain = 20; 
t0 = 0; 
x0 = 0; 
delt = 0.01; 
N = 1000; 
vs = 343; 
xObs = 0; %140
dObs = 46;  %24
 


%----- Read in Humphreys Wav
%[humpWav, Fs] = wavread('humphreysTrainout.wav');
% z = hilbert(humpWav);
% frq = (angle(z(2:length(humpWav)).*conj(z(1:length(humpWav)-1)))/2/pi)*Fs;
% reducedFrq = zeros(N);

% frqLen = length(frq);

% for i = frqLen/N:frqLen/N:frqLen
%     reducedFrq(int16((N/frqLen)*i)) = frq(round(i));
% end

load -mat trainData.mat;
fDVec = zeros(N);
count = 1;
while ((fApparentVec(count) - fh) > .1)
    xObs = count * delt * vTrain;
    count = count + 1;
end


average = length(fApparentVec);
index = 0;
while (average ~= 1) 
    summary = 0;
    for k = 1:count
        summary = summary + int32(fApparentVec(k)-fDVec(k));
    end
        average = summary/length(fApparentVec)
    [fDVec,tVec] = simulateTrainDoppler(fh, vTrain, t0, x0, xObs, dObs, delt, N, vs); 
    dObs = (round((dObs + .1)*10)/10);
end
plot(tVec,fApparentVec);
hold on;
plot(tVec,fDVec);
disp(xObs);
disp(dObs);

%----- Plot 
% plot(tVec,fDVec); 
% xlabel('Time (seconds)'); 
% ylabel('Apparent horn frequency (Hz)'); 
% grid on; 
% shg; 
%  
% %----- Generate a sound vector 
% T = delt*N;                    % simulation time (sec) 
% fs = 22050;                    % sample frequency (Hz) 
% deltSamp = 1/fs;               % sampling interval (sec) 
% Ns = floor(T/deltSamp);        % number of samples 
% tsamphist = [0:Ns-1]'*deltSamp; 
% Phihist = zeros(Ns,1); 
% fApparentVecInterp = interp1(tVec,fApparentVec,tsamphist,'spline'); 
% for ii=2:Ns 
%   fii = fApparentVecInterp(ii); 
%   Phihist(ii) = Phihist(ii-1) + 2*pi*fii*deltSamp; 
% end 
% soundVec = sin(Phihist); 
%  
% %----- Play the sound vector 
% sound(soundVec, fs);     
%  
% %----- Write to audio file 
% wavwrite(soundVec,fs,32,'trainout.wav');
