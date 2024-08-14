runningComparison = true; %#ok<NASGU>

NVals = 3:1:20;
EVals = 0.1*ones(1,20);
PVal = 1;
SNRVal = 0;

numXVals = 500;
xSearchOffset = 50;
trials = 10000;

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

runningComparison = false;