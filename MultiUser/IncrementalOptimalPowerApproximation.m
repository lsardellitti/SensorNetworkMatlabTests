setupValsOverride = true; %#ok<NASGU>
N0 = 1;
Pmax = [1 5 5];
P = [1 5 5];
startIndex = 2;

numXVals = 5000;
xSearchOffset = 20;

numIters = 50;
convThresh = 10^-9;

errorVals = [];
PVals = zeros(numIters,length(P))/0;
prevError = 1;

for iter = 1:numIters
for pIndex = startIndex:length(P)
    [~, PMin, errorMin] = calculateOptimalPVal(P, Pmax(pIndex), N0, xSearchOffset, numXVals, pIndex);
    
    P(pIndex) = PMin;
    errorVals = [errorVals, errorMin]; %#ok<AGROW>
end
PVals(iter,:) = P;
if exp(prevError - errorVals(end)) - 1 < convThresh
   break 
end
prevError = errorVals(end);
end

figure
plot(errorVals)
ylabel('Error Probability')
xlabel('Step Number')

figure
plot(PVals)
ylabel('P_i')
xlabel('Iteration Number')
legendEntries = cell(length(P),1);
for i=1:length(P)
    legendEntries{i} = ['P_' num2str(i)];
end
legend(legendEntries)

setupValsOverride = false;