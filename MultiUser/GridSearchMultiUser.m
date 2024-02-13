setupValsOverride = true; %#ok<NASGU>
N0 = 1;
P = [1, 1];
MultiUserSetup;
numXVals = 5000;
xSearchOffset = 5;
dataDir = 'GridSearchData';

% Values range to test over
testVals = linspace(0.001,5,50);
PVals = cell(1, N);
[PVals{:}] = ndgrid(testVals);

errorVals = zeros(ones(N,1)'*length(testVals));

for testIndex = 1:length(testVals)^N
    for i = 1:N
        P(i) = PVals{i}(testIndex);
    end

    MultiUserSetup;

    x = calculateXvalsMulti(points, P0, P1, pc0, pc1, N0, points(1)-xSearchOffset, points(2^N)+xSearchOffset, numXVals);
    
    errorVal = calculateErrorFromDRMulti(x, points, P0, P1, pc0, pc1, noistdv);
    
    errorVals(testIndex) = errorVal;
end

[minError, minIndex] = min(errorVals, [], 'all', 'linear');
for i = 1:N
    P(i) = PVals{i}(minIndex);
end

fileName = sprintf('/N0-%0.2fP1-%0.2f',N0, P1);
for i = 1:N
    fileName = strcat(fileName, sprintf('E%d-%0.2f',i, E(i)));
end
fileName = strcat(fileName, '.mat');
save(strcat(dataDir, fileName), 'errorVals', 'PVals');

setupValsOverride = false;