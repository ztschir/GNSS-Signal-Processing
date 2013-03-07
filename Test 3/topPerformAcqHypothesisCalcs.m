% topPerformAcqHypothesisCalcs
% Top-level script for performing acquisition calculations

%----- Setup
clear; clc;                
s.PfaAcq = 0.001;   
s.Tsub = 0.001;               
s.fMax = 25;        
s.nCodeOffsets = 10; 
s.ZMax = 800;
s.delZ = 0.1;



%----- Execute
C_NOdBHzVec = 20:5:50;
i = 1;
K = zeros(1,length(C_NOdBHzVec));
for(j = C_NOdBHzVec)
    Pd = 0;
    s.M = 1;
    s.K = 1;
    s.C_N0dBHz = j;
    while(Pd <= 0.95)
        [pZ_H0,pZ_H1,lambda0,Pd,ZVec] = performAcqHypothesisCalcs(s);
        if(j < 37)
            s.K = s.K + 100;
        else
            s.K = s.K + 1;
        end
    end
    
    K(i) = s.K;
    i = i + 1;
end

i = 1;
M = zeros(1,length(C_NOdBHzVec));
for(k = C_NOdBHzVec)
    Pd = 0;
    s.M = 1;
    s.K = 1;
    s.C_N0dBHz = k;
    while(Pd <= 0.95)
        [pZ_H0,pZ_H1,lambda0,Pd,ZVec] = performAcqHypothesisCalcs(s);
        if (k < 30)
            s.M = s.M + 50;
        else
            s.M = s.M + 1;
        end
    end
    M(i) = s.M;
    i = i + 1;
end
p = plot(C_NOdBHzVec, K, C_NOdBHzVec, M);
xlabel('C/No');
ylabel('Subaccumulations/Accumulations');
legend('Non-Coherent', 'Coherent');





%----- Visualize the results
% figure(2);
% [pmax,iimax] = max(pZ_H1);
% Zmax = ZVec(iimax);
% clf;
% ash = area(ZVec,pZ_H0);
% set(get(ash,'children'), 'facecolor', 'g', 'linewidth', 2, 'facealpha', 0.5);
% hold on;
% ash = area(ZVec,pZ_H1);
% set(get(ash,'children'), 'facecolor', 'b', 'linewidth', 2, 'facealpha', 0.5);
% linemax = 1/5*max([pZ_H0;pZ_H1]);
% line([lambda0,lambda0],[0,linemax], 'linewidth', 2, 'color', 'r');
% xlim([0 Zmax*2]);
% ylabel('Probability density');
% xlabel('Z');
% fs = 12;
% title('GNSS Acquisition Hypothesis Testing Problem');
% disp(['Probability of acquisition false alarm (PfaAcq): ' ...
%       num2str(s.PfaAcq)]);
% disp(['Probability of detection (Pd): ' num2str(Pd)]);
% text(lambda0,linemax*1.1, ['\lambda_0 = ' num2str(lambda0) ], ...
%      'fontsize',fs);
% shg