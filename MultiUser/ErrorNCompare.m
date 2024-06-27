runningComparison = true; %#ok<NASGU>
if exist('runningOnCAC','var') ~= 1
    runningOnCAC = false;
end

NVals = 3:1:10;
EVals = [0.05 0.05 0.1 0.1 0.2 0.2 0.2 0.3 0.3 0.3];
PVal = 1;
SNRVal = 10;

orthoError = zeros(1,length(NVals));
maxMacError = zeros(1,length(NVals));
maxMacMapError = zeros(1,length(NVals));
pairwiseError = zeros(1,length(NVals));
algoError = zeros(1,length(NVals));

for nIndex = 1:length(NVals)
    N = NVals(nIndex);
    E = EVals(1:N);

    Pmax = PVal*ones(1,N);
    Pstart = [1 0.1*ones(1,N-1)];
    testVals = SNRVal;

    P = Pmax;
    ErrorTestingMulti;
    orthoError(nIndex) = errorProbs;

    P = Pmax;
    useMAP = false;
    ErrorCalcMultiUser;
    maxMacError(nIndex) = errorVals;

    P = Pmax;
    useMAP = true;
    ErrorCalcMultiUser;
    maxMacMapError(nIndex) = errorVals;

    P = Pmax;
    useMAP = false;
    PairwiseOptimization;
    pairwiseError(nIndex) = errorVals;

    N0 = prod(Pmax)^(2/length(Pmax)) / 10^(testVals(testIndex)/10);
    P = Pstart;
    IncrementalOptimalPowerApproximation;
    algoError(nIndex) = errorVals(end);
end

if runningOnCAC
    % save data
    fileName = sprintf('../CACData/ErrNCompP%0.2fE%sPMax%s.mat',P1,join(string(EVals)),join(string(PVal)));
    save(fileName, 'SNRVal', 'NVals', 'orthoError', 'maxMacError', 'maxMacMapError', 'pairwiseError', 'algoError');
else
    figure
    hold on
    plot(NVals, orthoError);
    plot(NVals, maxMacError);
    plot(NVals, maxMacMapError);
    plot(NVals, pairwiseError);
    plot(NVals, algoError);
    set(gca, 'YScale', 'log')
    ylabel('Error Probability')
    xlabel('Number of Sensors')
    legend({'Ortho','MAC full','MAC full MAP','Pairwise MAC','MAC algo'})
end

runningComparison = false;