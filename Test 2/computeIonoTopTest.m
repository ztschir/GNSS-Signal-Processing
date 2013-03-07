clear all;

ionoData = [1.1176e-008, 7.4506e-009, -5.9605e-008, -5.9605e-008; 90112, 0, -196610, -65536];
fc = 1575.42e6;
rAntRx = [-742005.851560607, -5462223.38476596, 3198008.7346792];
rSvTx = [20847329.7083373, -15185642.4780402, 6205281.68907901];
tGPS = [1575, 518201.501];
model = 'broadcast';
ionoDelay1 = computeIonosphericDelay(ionoData, fc, rAntRx, rSvTx, tGPS, model)


% Answer  = ionoDelay1 =  1.9906e-08 [Sec]