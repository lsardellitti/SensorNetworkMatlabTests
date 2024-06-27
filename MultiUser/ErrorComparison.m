runningComparison = true; %#ok<NASGU>
if exist('runningOnCAC','var') ~= 1
    runningOnCAC = false;
end

Pmax = [1 1 1 1 1 1];
Pstart = [1 0.1 0.1 0.1 0.1 0.1];
testVals = linspace(-10,20,5);
errorProbs = zeros(1,length(testVals));
powerUsage = zeros(2,length(testVals));

if ~runningOnCAC
    figure
    hold on
end

P = Pmax;
ErrorTestingMulti;

if ~runningOnCAC
    plot(testVals, errorProbs)
else
    orthoError = errorProbs;
end

P = Pmax;
useMAP = false;
ErrorCalcMultiUser;

if ~runningOnCAC
    plot(testVals, errorVals)
else
    maxMacError = errorVals;
end

P = Pmax;
useMAP = true;
ErrorCalcMultiUser;

if ~runningOnCAC
    plot(testVals, errorVals)
else
    maxMacMapError = errorVals;
end

P = Pmax;
useMAP = false;
PairwiseOptimization;

if ~runningOnCAC
    plot(testVals, errorVals)
else
    pairwiseError = errorVals;
end

P = Pmax;
useMAP = true;
PairwiseOptimization;

if ~runningOnCAC
    plot(testVals, errorVals)
else
    pairwiseMapError = errorVals;
end

for testIndex = 1:length(testVals)
    N0 = prod(Pmax)^(2/length(Pmax)) / 10^(testVals(testIndex)/10);
    P = Pstart;
    IncrementalOptimalPowerApproximation;
    errorProbs(testIndex) = errorVals(end);
    powerUsage(1,testIndex) = sum(P.^2)/sum(Pmax.^2);
end

if ~runningOnCAC 
    plot(testVals, errorProbs);
else
    algoError = errorProbs;
end

for testIndex = 1:length(testVals)
    N0 = prod(Pmax)^(2/length(Pmax)) / 10^(testVals(testIndex)/10);
    P = Pmax;
    IncrementalOptimalPowerApproximation;
    errorProbs(testIndex) = errorVals(end);
    powerUsage(2,testIndex) = sum(P.^2)/sum(Pmax.^2);
end

if runningOnCAC
    % save data
    algoMaxError = errorProbs;
    fileName = sprintf('CACData/ErrCompP%0.2fE%sPMax%s.mat',P1,join(string(E)),join(string(Pmax)));
    save(fileName, 'testVals', 'powerUsage', 'orthoError', 'maxMacError', 'maxMacMapError', 'pairwiseError', 'pairwiseMapError','algoError', 'algoMaxError');
else
    plot(testVals, errorProbs);
    ylabel('Error Probability')
    xlabel('SNR (dB)')
    legend({'Ortho','MAC full','MAC full MAP','Pairwise MAC','Pairwise MAC MAP','MAC algo','MAC algo max'})

    figure
    plot(testVals, powerUsage);
    ylabel('Power Usage Ratio')
    xlabel('SNR (dB)')
    legend({'MAC algo','MAC algo max'})
end

runningComparison = false;