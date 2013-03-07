clear all;

ionoData = [4.6566e-9,1.4901e-8,-5.9605e-8,-5.9605e-8;79872,65536,-65536,-393220];
fc = 1575.42e6;
rAntRx = [1101972.5309609, -4583489.78279095, 4282244.3010423];
rSvTx = [24597807.6872883,-3065999.1384585, 9611346.77939927];
tGPS = [1490, 146238.774036515];
model = 'broadcast';
ionoDelay1 = computeIonosphericDelay(ionoData, fc, rAntRx, rSvTx, tGPS, model)

rSvTx = [2339172.27088689, -16191391.3551878, 21104185.0481546];
ionoDelay2 = computeIonosphericDelay(ionoData, fc, rAntRx, rSvTx, tGPS, model)