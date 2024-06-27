setupValsOverride = true; %#ok<NASGU>

if ~exist('runningComparison','var') == 1 || runningComparison == false
    N0 = 1;
	Pmax = [1 5 5 5 5 5 5 5];
    P = [1 0.1 0.1 0.1 0.1];
end

startIndex = 2;

numXVals = 5000;
xSearchOffset = 200;

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

if exist('runningComparison','var') == 1 && runningComparison == true
    setupValsOverride = false;
    return
end

figure
plot(errorVals)
ylabel('Error Probability')
xlabel('Step Number')
set(gca, 'YScale', 'log')

figure
plot(PVals)
ylim([0.4,1.05])
ylabel('Power Allocation')
xlabel('Iteration Number')
legendEntries = cell(length(P),1);
for i=1:length(P)
    legendEntries{i} = ['P_' num2str(i)];
end
legend(legendEntries)

setupValsOverride = false;