function [goldCodes] = generateGoldCode(n,ciVec1,ciVec2)



aOVec = zeros(n,1);

for m = 1:n
    if (m == n)
        aOVec(m) = 1;
    end
end

mSeq1 = generateMSequence(n,ciVec1,aOVec);
mSeq2 = generateMSequence(n,ciVec2,aOVec);


arrLen = length(mSeq1);
goldCodes = zeros(arrLen+2,arrLen);
goldCodes(1,:) = mSeq1;
goldCodes(2,:) = mSeq2;

for j = 3:arrLen+2
    for i = 1:arrLen
        goldCodes(j,i) = xor(mSeq1(i),mSeq2(i));
    end
    mSeq1 = circshift(mSeq1,1);
%    if ((goldCodes(1,:) == goldCodes(j,:) | goldCodes(2,:) == goldCodes(j,:)... 
%        | goldCodes(3,:) == goldCodes(j,:)) & j ~= 3)
%        error('Not a Gold Code')
%    end
end

% zautoCcorrAvg = zeros(arrLen,1);
% iautoCcorrAvg = zeros(arrLen,1);
% zcrossCcorrAvg = zeros(arrLen,1);
% icrossCcorrAvg = zeros(arrLen,1);
% 
% for k = 1:arrLen+2
%     for l = 1:arrLen+2
%         [zcross, icross] = ccorr(goldCodes(k,:), goldCodes(l,:));
%         zcrossCcorrAvg = zcrossCcorrAvg + zcross; 
%         icrossCcorrAvg = icrossCcorrAvg + icross;  
%     end
%     [zauto, iauto] = ccorr(goldCodes(k,:), goldCodes(k,:));
%     zautoCcorrAvg = zautoCcorrAvg + zauto; 
%     iautoCcorrAvg = iautoCcorrAvg + iauto;
% end

p = plot(ccorr(goldCodes(5,:),goldCodes(5,:)));
set(p,'Color','red','LineWidth',1);
hold on;
plot(ccorr(goldCodes(5,:),goldCodes(30,:)));
hold off;



% for k = 1:arrLen+2
%     for l = 1:arrLen+2
%         if(goldCodes(k,:) == goldCodes(l,:) & k ~= l)
%             error('Not a Gold Code');
%         end
%     end
% end
