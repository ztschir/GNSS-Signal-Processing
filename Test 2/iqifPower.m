clear all; clc;
%----- Setup
Tfull = 0.5;         % Time interval of data to load
fsampIQ = 5.0e6;     % IQ sampling frequency (Hz)
N = floor(fsampIQ*Tfull);
nfft = 2^9;          % Size of FFT used in power spectrum estimation
%----- Load data
fid = fopen('/home/zach/SchoolWork/ASE 389P-7/niData01head.bin','r','l');
Y = fread(fid, [2,N], 'int16')';
IQ = Y;
Y = Y(:,1) + j*Y(:,2);
fclose(fid);


% [Syy,fVec] = pwelch(Y,hann(nfft),[],nfft,fsampIQ);
% 
% figure(1);
% yLow = -120;
% yHigh = -20;
% T = nfft/fsampIQ;
% delf = 1/T;
% fcenter = (nfft/2)*delf;
% fVec = fVec - fcenter;
% Syy = [Syy(nfft/2 + 1 : end); Syy(1:nfft/2)];
% area(fVec/1e6,10*log10(Syy),-70);
% ylim([yLow,yHigh]);
% grid on;
% shg;
% xlabel('Frequency (MHz)');
% ylabel('Power density (dB/Hz)');
% %figset;
% title('Power density of original signal');
% shg;

xVec = iq2if(IQ(:,1),IQ(:,2),Tfull,2.5e6);

[Syy,fVec] = pwelch(xVec,hann(nfft),[],nfft,fsampIQ);

figure(2);
yLow = -120;
yHigh = -15;
T = nfft/fsampIQ;
delf = 1/T;
fcenter = (nfft/2)*delf;
fVec = fVec - fcenter;
Syy = [Syy(nfft/2 + 1 : end); Syy(1:nfft/2)];
area(fVec/1e6,10*log10(Syy),-70);
ylim([yLow,yHigh]);
grid on;
shg;
xlabel('Frequency (MHz)');
ylabel('Power density (dB/Hz)');
title('Power density of converted IQ signal');
shg;

[IVec QVec] = if2iq(xVec,Tfull,2.5e6);

[Syy,fVec] = pwelch(IVec + j*QVec, hann(nfft), [], nfft, fsampIQ);

figure(3);
yLow = -120;
yHigh = -15;
T = nfft/fsampIQ;
delf = 1/T;
fcenter = (nfft/2)*delf;
fVec = fVec - fcenter;
Syy = [Syy(nfft/2 + 1 : end); Syy(1:nfft/2)];
area(fVec/1e6,10*log10(Syy),-70);
ylim([yLow,yHigh]);
grid on;
shg;
xlabel('Frequency (MHz)');
ylabel('Power density (dB/Hz)');
title('Power density of reconverted from IF signal');
shg;