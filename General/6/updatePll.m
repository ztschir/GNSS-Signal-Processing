function [xkp1 vk] = updatePll(s)
%
% updatePll ----- Perform a single update step of a phase tracking loop
%                 with an arctangent phase detector.
%
% INPUTS
%
% s ------------- A structure with the following fields:
%
%    Ipk -------- The accumulation of the in-phase, prompt register at
%                 sample time tk.
%
%    Qpk -------- The accumulation of the quadrature, prompt register at
%                 sample time tk.
%
%    xk --------- The phase tracking loop filter's state at time tk. The
%                 dimension of xk is N-1, where N is the order of the
%                 tracking loop's closed-loop transfer function.
%
%    Tsub ------- Subaccumulation interval, in seconds. This is also the
%                 loop update (discretization) interval.
%
%  Ad,Bd,Cd,Dd -- The loop filter's state-space model.
%
% OUTPUTS
%
%     xkp1 ------ The loop filter's state at time tkp1. The dimension of
%                 xtkp1 is N-1, where N is the order of the loop's
%                 closed-loop transfer function.
%
%     vk -------- The doppler frequency shift that will be used to drive
%                 the reciever's carrier-tracking numerically controlled
%                 oscillator during the time interval from tk to tkp1, in
%                 rad/sec.
%
%+------------------------------------------------------------------------+
% References:
%
%
%+========================================================================+

% apply arctangent phase detector
phase = atan(s.Qpk/s.Ipk);

% pass through the discrete loop filter
xkp1 = s.Ad*s.xk + s.Bd*phase;
vk = s.Cd*s.xk + s.Dd*phase;


