setupValsOverride = true; %#ok<NASGU>
N0 = 1;
Pmax = [1 10 10 10 10];
startIndex = 1;

numXVals = 5000;
xSearchOffset = 10;

numRuns = 10;
numIters = 50;
convThresh = 10^-9;
minP = 0.1;

startPVals = zeros(numRuns,length(Pmax));
endPVals = zeros(numRuns,length(Pmax));
endErrorVals = zeros(numRuns,1);

for run = 1:numRuns
    errorVals = [];
    prevError = 1;
    P = (Pmax-minP).*rand(1,length(Pmax))+minP;
    startPVals(run,:) = P;
    for iter = 1:numIters
        for pIndex = startIndex:length(Pmax)
            [~, PMin, errorMin] = calculateOptimalPVal(P, Pmax(pIndex), N0, xSearchOffset, numXVals, pIndex);

            P(pIndex) = PMin;
            errorVals = [errorVals, errorMin]; %#ok<AGROW>
        end
        if exp(prevError - errorVals(end)) - 1 < convThresh
           break 
        end
        prevError = errorVals(end);
    end
    endErrorVals(run) = errorVals(end);
    endPVals(run,:) = P;
end

[~, powerOrder] = sort(endErrorVals);

figure
plot(endErrorVals(powerOrder))
ylabel('Error Probability')
xlabel('Run Number')

figure
plot(endPVals(powerOrder,:))
ylabel('P_i')
xlabel('Run Number')
legendEntries = cell(length(Pmax),1);
for i=1:length(Pmax)
    legendEntries{i} = ['P_' num2str(i)];
end
legend(legendEntries)

setupValsOverride = false;