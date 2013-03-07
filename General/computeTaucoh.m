% compute TAUcoh

clc; clear all;


sigLen = 1000000;               % Length of signal to be generated
T = .001;                       % Sampling Interval
NcohMax = .5;                   % Value of N for which the quantity drops to
reals = 20;

phaseSigma = 0;                 % provided by the problem
freqSigma = 0.01;               % provided by the problem
freqRateSigma = 0.0001;         % provided by the problem

randomSig = randn(1,sigLen);

phaseDeltaT = zeros(1,sigLen);
freqDeltaT = zeros(1,sigLen);
freqRateDeltaT = zeros(1,sigLen);

phaseCcoh = zeros(reals,sigLen);
freqCcoh = zeros(reals,sigLen);
freqRateCcoh = zeros(reals,sigLen);

for(i = 1:reals)
    % Phase noise (First Der)
    if(phaseSigma ~= 0)
        phaseDeltaT = randomSig*phaseSigma;
        phaseCcoh(i,:) = computeCoherence(phaseDeltaT,sigLen);    
    end

    % Frequency noise (Second Der)
    if(freqSigma ~= 0)
        freq1 = randomSig*freqSigma;     
        freqDeltaT = cumsum(freq1);
        freqCcoh(i,:) = computeCoherence(freqDeltaT,sigLen);
    end

    % Frequency noise rate (Third Der)
    if(freqRateSigma ~= 0)
        freqRate = randomSig*freqRateSigma; 
        freq2 = cumsum(freqRate);
        freqRateDeltaT = cumsum(freq2);
        freqRateCcoh(i,:) = computeCoherence(freqRateDeltaT,sigLen);
    end
end

i = 1;
if(phaseSigma ~= 0)
    j = mean(phaseCcoh.^2);
    k = 0;
    while(k < NcohMax)
        k = j(i);
        i = i + 1;
    end
    TPhasecoh = T*i
end

i = 1;
if(freqSigma ~= 0)
    j = mean(freqCcoh.^2);
    k = 0;
    while(k < NcohMax)
        k = j(i);
        i = i + 1;
    end
    TFreqcoh = T*i
end

i = 1;
if(freqRateSigma ~= 0)
    j = mean(freqRateCcoh.^2);
    k = 0;
    while(k < NcohMax)
        k = j(i);
        i = i + 1;
    end
    TFreqRatecoh = T*i
end
