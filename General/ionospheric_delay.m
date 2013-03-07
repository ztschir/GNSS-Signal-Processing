function ionospheric_delay(L1file1, L2file1, L1file2, L2file2)
L1text1 = fopen(L1file1);
L2text1 = fopen(L2file1);
L1text2 = fopen(L1file2);
L2text2 = fopen(L2file2);

L1_1 = textscan(L1text1, '%*f32 %*f %*d %*d %*f32 %f %*d %f %*d %d %*f %*d %d8 %*d');
L2_1 = textscan(L2text1, '%*f32 %*f %*d %*d %*f32 %f %*d %f %*d %d %*f %*d %d8 %*d');
L1_2 = textscan(L1text2, '%*f32 %*f %*d %*d %*f32 %f %*d %f %*d %d %*f %*d %d8 %*d');
L2_2 = textscan(L2text2, '%*f32 %*f %*d %*d %*f32 %f %*d %f %*d %d %*f %*d %d8 %*d');

time1 = L1_1{3} - L1_1{3}(1);
time2 = L1_2{3} - L1_2{3}(1);
freqDiffL1 = 2.54572778; % unitless
freqDiffL2 = 1.54572778;
L1freq = 1575.42; % in MHz
L2freq = 1227.6;
errorCycle = 0.01; % in meters
L1wav = 0.19; % wavelength in meters
L2wav = 0.24; 

psudorangeL1_1 = L1_1{1};
psudorangeL2_1 = L2_1{1};
psudorangeL1_2 = L1_2{1};
psudorangeL2_2 = L2_2{1};

carrierPhaseL1_1 = L1_1{2};
carrierPhaseL2_1 = L2_1{2};
carrierPhaseL1_2 = L1_2{2};
carrierPhaseL2_2 = L2_2{2};

codeMesurements1 = freqDiffL2*(psudorangeL2_1-psudorangeL1_1);
codeMesurements2 = freqDiffL2*(psudorangeL2_2-psudorangeL1_2);

%pIF = (freqDiffL1*L1{6})-(freqDiffL2*L2{6});
%NL1 = ((L1wav*L1{7})-pIF+codeMesurements-errorCycle)/L1wav
%NL2 = ((L2wav*L2{7})-pIF+(((L1freq.^2)/(L2freq.^2))*codeMesurements)-errorCycle)/L2wav
NL1_1 = round(carrierPhaseL1_1);
NL2_1 = round(carrierPhaseL2_1);
NL1_2 = round(carrierPhaseL1_2);
NL2_2 = round(carrierPhaseL2_2);

carrierPhaseMesurements1 = freqDiffL2*((L1wav*(carrierPhaseL1_1-NL1_1))-(L2wav*(carrierPhaseL2_1-NL2_1)));
carrierPhaseMesurements2 = freqDiffL2*((L1wav*(carrierPhaseL1_2-NL1_2))-(L2wav*(carrierPhaseL2_2-NL2_2)));

TEC1 = (codeMesurements1*(L1freq^2))/40.3;
TEC2 = (codeMesurements2*(L1freq^2))/40.3;

figure(1);
plot(time1, codeMesurements1);
hold on;
carrier = plot(time1, carrierPhaseMesurements1);
set(carrier, 'Color', 'Red');

figure(2);
plot(time2, codeMesurements2);
hold on;
carrier = plot(time2, carrierPhaseMesurements2);
set(carrier, 'Color', 'Red');

figure(3);
plot(time1, TEC1);
hold on;
carrier = plot(time2, TEC2);
set(carrier, 'Color', 'Red');

fclose('all');