setupValsOverride = true; %#ok<NASGU>
N0 = 1;
Pmax = [1 0.5 2 2 2];
P = [1 0 0 0 0];
startIndex = 2;

numXVals = 5000;
xSearchOffset = 10;

numIters = 100;

errorVals = [];

for iter = 1:numIters
for pIndex = startIndex:length(P)
    [~, PMin, errorMin] = calculateOptimalPVal(P, N0, xSearchOffset, numXVals, pIndex);
    
    P(pIndex) = PMin;
    
    if P(pIndex) > Pmax(pIndex)
        P(pIndex) = Pmax(pIndex);
    else
        errorVals = [errorVals, errorMin]; %#ok<AGROW>
    end

    P
end
end

figure
plot(errorVals)

setupValsOverride = false;