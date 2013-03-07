function [fDVec, tVec] = simulateTrainDoppler(fh, vTrain, t0, x0, xObs, ...
                                              dObs, delt, N, vs)
  
% m/s vs     = Speed of sound
% Hz  fh     = Freq of transmitted sound
% m/s vTrain = Velocity of Train
% s   t0     = Starting train time
% m   x0     = Starting train position
% m   x0bs   = Observer x position
% m   d0bs   = Observer distance away from track
% s   delt   = Mesurement interval
%     N      = Number of Mesurements

 fDVec = zeros(1,N);            
 tVec = t0:delt:(N-1)*delt; 
 trainPos = (vTrain * tVec) + x0;
 
 for i = 1:N
     fDVec(i) = fh * ( 1 - ( ( ( (trainPos(i) - xObs)*vTrain ) / ...
         sqrt( (dObs.^2) + (xObs - trainPos(i)).^2 ) ) / vs ) );
 
 end
 return