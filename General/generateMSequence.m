function [mSeq] = generateMSequence(n,ciVec,aOVec)


m = (2.^n) - 1;
mSeq = 2*ones(m,1);
LFSR = aOVec;
flagArr = zeros(n);

if(n ~= length(aOVec))
    error('not a correct vector length');
end
for k = 1:length(ciVec)
    for l = 1:n
        if (ciVec(k) == l)
           flagArr(l) = 1; 
        end
    end
end
for i = 1:m
    mSeq(i) = LFSR(n);
    tempInt = mSeq(i);
    for j = n:-1:1
        if(flagArr(j) == 1 && j~= n)
            tempInt = xor(tempInt,LFSR(j));
        end
    end
    LFSR = circshift(LFSR,1);
    LFSR(1) = tempInt;
    
    if((LFSR == aOVec) & (i ~= 1) & (i ~= m))
        error('not a M-Sequence')
    end
end


