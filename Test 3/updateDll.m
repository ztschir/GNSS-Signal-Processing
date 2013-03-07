% updateDll ----- Perform a single update step of a carrier-aided first-order
%                 code tracking loop.
%
%
% INPUTS
%
% s ------------- A structure with the following fields:
%
%    BLtarget --- Target bandwidth of the closed-loop code tracking loop, in
%                 Hz.
%
%    IsqQsqAvg -- The average value of |Stildek|^2 = Ipk^2 + Qpk^2; also
%                 equal to (Nk*Abark/2)^2 + 2*sigmaIQ^2.
%
%    sigmaIQ ---- The standard deviation of the noise in the prompt in-phase
%                 and quadrature subaccumulations Ipk and Qpk.
%
%    Ipk -------- The subaccumulation of the in-phase, prompt register at
%                 sample time tk.
%
%    Qpk -------- The subaccumulation of the quadrature, prompt register at
%                 sample time tk.
%
%    Iek -------- The subaccumulation of the in-phase, early register at
%                 sample time tk.
%
%    Qek -------- The subaccumulation of the quadrature, early register at
%                 sample time tk.
%
%    Ilk -------- The subaccumulation of the in-phase, late register at sample
%                 time tk.
%
%    Qlk -------- The subaccumulation of the quadrature, late register at
%                 sample time tk.
%
%    vpk -------- The aiding signal from the phase tracking loop, in seconds
%                 per second. This is equal to the Doppler frequency shift
%                 that will be used to drive the receiver’s carrier-tracking
%                 numerically controlled oscillator during the time interval
%                 from tk to tkp1, divided by the carrier frequency. Thus,
%                 vpk = fDk/fc.
%
%    Tc --------- Chip interval, in seconds.
%
% OUTPUTS
%
%    vTotalk ----- The code tracking loop’s estimate of the code phase rate at
%                  sample time tk, in sec/sec. vTotalk is equal to the code
%                  tracking loop’s correction term vk plus the carrier aiding
%                  term vpk.
%
%+------------------------------------------------------------------------------+
% References:
%
%
%+==============================================================================+
function [vTotalk] = updateDll(s)

C = (s.Tc/2) / (s.IsqQsqAvg - 2*s.sigmaIQ^2);
ek = C*(((s.Iek - s.Ilk)*s.Ipk) + ((s.Qek - s.Qlk)*s.Qpk));

vk = 4*s.BLtarget*ek;  % first order loop conversion from BN.
vTotalk = vk + s.vpk; 