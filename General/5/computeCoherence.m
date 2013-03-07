function [Ccoh] = computeCoherence(DeltaThetaVec,N,csum)
%
% computeCoherence --- Compute the value of the discrete-time coherence
% function Ccoh(N).
%
%
% INPUTS
%
% DeltaThetaVec ----- Ns-by-1 vector representing a sampled carrier phase
%                     error time history.
%
% N ----------------- The number of samples that will be used to evaluate
%                     the coherence Ccoh(N).
%
% csum -------------- Perform cumulative sums instead of normal sums.
%                     Returns Ccoh as a function of N.
%
% OUTPUTS
%
% Ccoh -------------- The value of the discrete-time coherence function for
%                     the first N samples of DeltaThetaVec.
%
%+------------------------------------------------------------------------+
% References: Thompson, Moran, and Swenson , "Interferometry and Synthesis
% in Radio Astronomy," p. 277.
%
%
%+========================================================================+

if(nargin < 3 || isempty(csum)),csum = 0;end
if(nargin < 2 || isempty(N)),N = length(DeltaThetaVec);end

% compute the coherence
if(csum)
    Ccoh = abs(cumsum(exp(1i*DeltaThetaVec(1:N))))./(1:N)';
else
    Ccoh = norm(sum(exp(1i*DeltaThetaVec(1:N))))/N;
end


