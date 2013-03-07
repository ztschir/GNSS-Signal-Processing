function [pZ_H0 pZ_H1 lambda0 Pd ZVec] = performAcqHypothesisCalcs(s)
%
% performAcqHypothesisCalcs --- Calculate the null-hypothesis and
% alternative hypothesis probability density functions and the decision
% threshold corresponding to GNSS signal acquisition with the given inputs.
%
% Z is the acquisition statistic
%
%            K  |  M           |2
% Z = (1/M)*sum | sum Stilde_k |
%           l=1 | k=1          |l
%
%                _                       _
%            K  |  / M    \2    / M    \2 |
%   = (1/M)*sum | | sum Ik | + | sum Qk | |
%           l=1 |_ \k=1   /     \k=1   / _|l
%
% where Stilde_k = rho_k*exp(j*Delta_phi_k) + n_k
%
% and Ik = rho*cos(j*Delta_phi_k) + n_Ik,
%     Qk = rho*sin(j*Delta_phi_k) + n_Qk
%
% and n_Ik ~ N(0,1) and n_Qk ~ N(0,1), with E[n_Ik n_Qi] = 1 for k = i and
% 0 for k ~= i. The amnplitude rho is related to familiar parameters N, A,
% and sigma_IQ by rho = (N*A)/(2*sigma_IQ), i.e., it is the magnitude of
% the I,Q vector normailized by sigma_IQ.
%
% Under H0, the statistic Z is distributed as a chi-squared distribution
% with 2*K degrees of freedom. Under H1, Z is distributed as a noncentral
% chi-squared distribution with lambda = K*M*rho^2 and 2*k degrees of
% freedom.
%
% The total number of cells in the search grid is assumed to be nCells =
% nCodeOffsets*nFreqOffsets, where nFreqOffsets = 2*fMax*Tcoh, with Tcoh
% the total coherent integration time Tcoh = M*Tsub.
%
% INPUTS
%
% s -------- A structure containing the following fields:
%
%         C_N0dBHz ------- Carrier-to-noise ratio in dB-Hz.
%
%         Tsub ----------- Subaccumulation interval, in seconds.
%
%         M -------------- The number of subaccumulations summed coherently
%                          to get accumulations.
%
%         K -------------- The number of accumulations summed noncoherently
%                          to get Z.
%
%         fMax ----------- Frequency search range delimiter. The total
%                          frequency search range is +/- fMax.
%
%         nCodeOffsets --- Number of statistically independent code offsets
%                          in the search range.
%
%         PfaAcq --------- The total acquisition false alarm probability.
%                          This is the probability that the statistic Z
%                          exceeds the threshold lambda in any one of the
%                          search cells under the hypothesis H0. One can
%                          derive the false alarm probability for each
%                          search cell from PfaAcq.
%
%         ZMax ----------- The maximum value of Z that will be considered.
%
%         delZ ----------- The discretization interval used for the
%                          independent variable Z. The full vector of Z
%                          values considered is thus ZVec = [0:delZ:ZMax].
%
% OUTPUTS
%
% pZ_H0 ---------- The probability density of Z under hypothesis H0.
%
% pZ_H1 ---------- The probability density of Z under hypothesis H1.
%
% lambda0 -------- The detection threshold.
%
% Pd ------------- The probability of detection.
%
% Zvec ----------- The vector of Z values considered
%
%
%+------------------------------------------------------------------------+
% References:
%
%
%+========================================================================+

% determine the Z vector
ZVec = (0:s.delZ:s.ZMax)';

% calculate the null hypothesis probability density function
pZ_H0 = chi2pdf(ZVec,2*s.K);

% calculate the alternate hypothesis probability density function
rho = sqrt(2*s.Tsub*10^(s.C_N0dBHz/10));
pZ_H1 = ncx2pdf(ZVec,2*s.K,s.K*s.M*rho^2);

% determine the threshold value that satisfies PfaAcq
lambda0 = chi2inv(1-s.PfaAcq,2*s.K);

% determine the probability of detection at this threshold
Pd = 1 - ncx2cdf(lambda0,2*s.K,s.K*s.M*rho^2);


