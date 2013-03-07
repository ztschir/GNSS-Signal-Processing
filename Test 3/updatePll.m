% updatePll ----- Perform a single update step of a phase tracking loop
% with an arctangent phase detector.
%
%
% INPUTS
%
% s ------------- A structure with the following fields:
%
%    Ipk -------- The accumulation of the in-phase, prompt register at sample
%                 time tk.
%
%    Qpk -------- The accumulation of the quadrature, prompt register at sample
%                 time tk.
%
%    xk --------- The phase tracking loop filter’s state at time tk. The
%                 dimension of xk is N-1, where N is the order of the loop’s
%                 closed-loop transfer function.
%
% Ad,Bd,Cd,Dd -- The loop filter’s state-space model.
%
% OUTPUTS
%
%
%    xkp1 ------- The loop filter’s state at time tkp1. The dimension
%                  of xkp1 is N-1, where N is the order of the loop’s
%                  closed-loop transfer function.
%
%    vk --------- The Doppler frequency shift that will be used to drive the
%                  receiver’s carrier-tracking numerically controlled
%                  oscillator during the time interval from tk to tkp1, in
%                  rad/sec.
%
%+------------------------------------------------------------------------------+
% References:
%
%
%+==============================================================================+
function [xkp1,vk] = updatePll(s)

ek = atan(s.Qpk/s.Ipk);     % Arctangent phase detector
%ek = s.Ipk*s.Qpk;          % Conventional Costas phase detector
%ek = atan2(s.Qpk,s.Ipk);   % Decision-directed Arctangent phase detector

xkp1 = s.Ad*s.xk + s.Bd*ek;
vk = s.Cd*s.xk + s.Dd*ek;

