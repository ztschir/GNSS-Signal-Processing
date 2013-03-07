% computeS4AndTau0 -- Compute the scintillation index S4 and the decorrelation
% time tau0 corresponding to the input complex channel response function time
% history zkhist.
%
%
% INPUTS
%
% zkhist ----- Nt-by-1 vector containing the normalized complex scintillation
%              time history in the form of averages over Ts with sampling
%              interval Ts. zkhist(kp1) is the average over tk to tkp1.
%
% tkhist ----- Nt-by-1 vector of time points corresponding to zkhist.
%
%
% OUTPUTS
%
% S4 --------- Intensity scintillation index of the scintillation time history
%              in zkhist, equal to the mean-normalized standard deviation of
%              the intensity abs(zkhist).^2.
%
% tau0 ------- The decorrelation time of the scintillation time history in
%              zkhist, in seconds.
function [S4,tau0] = computeS4AndTau0(zkhist,tkhist)

intensity = abs(zkhist).^2;

timeAvgSqr = mean(intensity)^2;
sqrTimeAvg = mean(intensity.^2);

S4 = sqrt((sqrTimeAvg - timeAvgSqr) / timeAvgSqr);
tau0 = 0;
zkhistdoub = [zkhist' zkhist'];
zkhistdoub = abs(zkhistdoub);

k = sqrt(1-S4^2)/(1-sqrt(1-S4^2));
R0 = (norm(zkhist)^2)/(2*k);
beta = 1.2396464;
Rtau = R0*exp(-beta)*(cos(beta)+sin(beta));

ccorr(zkhist,zkhist)

% hist = zeros(1,length(zkhist));
% vect = 1:100:length(zkhist);
% for ( n = vect)
%     hist(1,n) = norm(xcorr(zkhistdoub(1:length(zkhist)), zkhistdoub(n:length(zkhist)+n)));
%     if (hist(1,n) >= Rtau)
%         fprintf('raise the flag');
%     end
% end
    

