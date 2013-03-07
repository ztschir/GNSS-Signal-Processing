function [Tcoh] = est_Tcoh(stdev,M,type,thresh)

% Purpose: Estimate the coherence time for Gaussian white phase noise,
% frequency noise, or frequency rate noise. Assume that the sampling
% interval is 1ms.
%
% Inputs:
% stdev ----- The standard deviation of the white noise to produce in time
%             units of samples. 
%
% M --------- The number of noise realizations to use.
%
% type ------ The type of noise to be produced. Must be either 'phase',
%             'freq', or 'freq rate'.
%
% thresh ---- The threshold value to use for calculation of coherence time.
%
% Outputs:
% Tcoh ------ The computed coherence time.
%
%

if(~strcmp(type,'phase') && ~strcmp(type,'freq') && ~strcmp(type,'freq rate'))
    error(['Unrecognized type of noise: ' type])
end

if(nargin < 4 || isempty(thresh)),thresh = .5;end

% use a monte-carlo approach to determine the coherence time
N = 100000;
dN = 100000;
T = .001;
Ccoh = 100*ones(N,M);
while(1)
    for(j = 1:M)
        % produce the phase information from the Gaussian white noise of the
        % passed type (use Euler's method for all integrations).
        if(strcmp(type,'phase'))
            
            % compute white phase noise
            del_theta = randn(N,1)*stdev;
            
        elseif(strcmp(type,'freq'))
            
            % compute the phase for white frequency noise
            freq = randn(N-1,1)*stdev;
            del_theta = [0;cumsum(freq)];
            
        elseif(strcmp(type,'freq rate'))
            
            % compute the phase for white frequency rate noise
            freq_rate = randn(N-2,1)*stdev;
            freq = [0;cumsum(freq_rate)];
            del_theta = [0;cumsum(freq)];
        end
        
        % compute the coherence
        Ccoh(:,j) = computeCoherence(del_theta,N,1);
    end
    
    % increase the number of elements in Ccoh if all realizations do not
    % have a minimum Ccoh below the threshold value yet. Else break the
    % loop.
    min_under_thresh = unique(Ccoh(end,:).^2 > thresh);
    if(length(min_under_thresh) ~= 1 || min_under_thresh ~= 0)
        N = N+dN;
        Ccoh = [Ccoh;zeros(dN,M)];
    else
        break
    end
end

% take the mean of the calculated Ccoh(N)^2 values across all realizations.
mean_Ccoh = mean(Ccoh.^2,2);
N_thresh = find(mean_Ccoh < thresh,1);
Tcoh = T*N_thresh;


