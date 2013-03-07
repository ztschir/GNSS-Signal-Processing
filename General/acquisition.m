clear all; clc;

%----- Setup

SubAcq = 50;
Tsub = 0.001;
Tfull = SubAcq*Tsub;         % Time interval of data to load

fsampIQ = 5.0e6;     % IQ sampling frequency (Hz)
N = floor(fsampIQ*Tsub);
delFmin = -5000;
delFstep = 250;
delFmax = 5000;
delFVec = delFmin:delFstep:delFmax;
%----- Load data
fid = fopen('/home/zach/SchoolWork/ASE 389P-7/niData02.bin','r','l');
Y = fread(fid, [2,N*SubAcq], 'int16')';
Y = Y(:,1) + 1i*Y(:,2);
fclose(fid);
PRNCodes = load('/home/zach/SchoolWork/ASE 389P-7/cacodes.bin');
acqCodes = zeros(32,N);


for (PRN = 1:32)
    acqCodes(PRN,:) = oversampleSpreadingCode(PRNCodes(PRN,:)',1.023e6/fsampIQ,N,1023)';
    lenCode = length(acqCodes(PRN,:));
    mag = zeros(length(delFVec),lenCode);
    for ( SubA = 1:SubAcq)
        magSub = zeros(length(delFVec),lenCode);
        fInd = 1;
        for (delF = delFVec)
             Sk = ccorr((Y((SubA-1)*lenCode+1:lenCode*SubA).*exp(-1i*2*pi*delF*(0:lenCode-1)'*(1/fsampIQ))),acqCodes(PRN,:)');
             center = ceil(lenCode/2);
             Sk = [Sk(center:end); Sk(1:center-1)];
             magSub(fInd,:) = (Sk .* conj(Sk))';
             fInd = fInd + 1;
        end
        mag = (mag + magSub)./2;
       
        
    end
    

   
    [carrierPeak, codePhaseInd] = max(max(mag));
    [carrierPeak, dopFreqInd] = max(max(mag'));
   
    dopFreq = delFVec(dopFreqInd);
    if(dopFreqInd > length(delFVec)/2)
        noiseFloor = mean(mean(mag(1:floor(length(delFVec)/2)-1,:)));
    else
        noiseFloor = mean(mean(mag(floor(length(delFVec)/2)+1:end,:)));
    end
    
    C_N = 10*log10((carrierPeak - noiseFloor)/(noiseFloor*Tsub));
    
    if(C_N >= 42)
        fprintf('PRN # %2.0f   C/No: %2.3f    Apperent Doppler: %5.0f Hz\n',PRN,C_N,dopFreq);
%         figure(PRN);
%         surf((1:lenCode),delFVec,mag);
%         shading interp;
    end
end
