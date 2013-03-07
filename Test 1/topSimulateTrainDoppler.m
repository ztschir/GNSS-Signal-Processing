% topSimulateTrainDoppler.m 

 
clear; clc; clf; 
%----- Setup 

load -mat trainData.mat


%[fApparentVec,tVec] = simulateTrainDoppler(440, 20, 0, 0, 40, 80, 0.01, 1000, 343);


fh = 440; 
vTrain = 20; 
t0 = 0; 
x0 = 0; 
delt = 0.01; 
N = 1000; 
vs = 343; 
xObs = 0;
dObs = 45;
precision = 0.1;
fDVec = zeros(N);
 

count = 1;
while ((fApparentVec(count) - fh) > precision)
    count = count + 1;
    xObs = count * delt * vTrain;
end
average = double(N);
while (average > .65) 
    summary = 0;
    for k = 1:N
        summary = summary + int32(abs(fApparentVec(k)-fDVec(k)));
    end
    summary = double(summary);
    average = summary/N;
    [fDVec,tVec] = simulateTrainDoppler(fh, vTrain, t0, x0, xObs, dObs, delt, N, vs); 
    dObs = (round((dObs + precision)*10)/10);
end

plot(tVec,fApparentVec);
hold on;
plot(tVec,fDVec);
disp(xObs);
disp(dObs);