function [zvec,ivec] = ccorr(xvec,yvec)
%
% CCORR  Circular correlation (FFT-based) 
% [zvec,ivec] = ccorr(xvec,yvec)
%
% NOTE: xvec and yvec can be complex vectors, in which case ccorr 
%       performs complex conjugate circular correlation. 
%
% Inputs
%
% xvec            N-by-1 vector to be circularly correlated.
%
% yvec            N-by-1 vector to be circularly correlated.
%
% OUTPUTS
%
% zvec            N-by-1 vector result of circular correlation.
%
% ivec            N-by-1 vector of correlation offsets.
%


%----- Ensure that xvec and yvec are of equal size
xvec = xvec(:);
yvec = yvec(:);
N = size(xvec,1);
if ((size(yvec,1) ~= N))
  error('xvec and yvec must be vectors of the same size');
end

%----- Pre-shift yvec
Nf = floor(N/2) + 1;
Nc = ceil(N/2) - 1;
yvectemp = zeros(N,1);
yvectemp(1:Nc) = yvec(Nf+1:N);
yvectemp(Nc+1:N) = yvec(1:Nf);
yvec = yvectemp;
clear yvectemp;

%----- Circular correlate
X = fft(xvec);
Xc = conj(X);
clear X;
Y = fft(yvec);
Z = Xc.*Y;
clear Xc Y
zvec = real(ifft(Z));

%----- Generate index vector
if(mod(N,2)~=0)
  ivec = [-Nf+1:Nc]'; 
else
  ivec = [-Nf + 2:Nc+1]';
end