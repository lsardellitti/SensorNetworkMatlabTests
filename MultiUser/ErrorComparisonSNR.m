runningComparison = true; %#ok<NASGU>

Pmax = ones(1,5);
Pstart = [1 0.1*ones(1,4)];
testVals = linspace(-10,20,5);
trials = 10000;

numXVals = 500;
xSearchOffset = 50;

errorProbs = zeros(1,length(testVals));
powerUsage = zeros(2,length(testVals));

figure
hold on

P = Pmax;
ErrorTestingMulti;

plot(testVals, errorProbs)

P = Pmax;
useMAP = false;
ErrorCalcMultiUser;

plot(testVals, errorVals)

P = Pmax;
useMAP = true;
ErrorCalcMultiUser;

plot(testVals, errorVals)

P = Pmax;
useMAP = false;
PairwiseOptimization;

plot(testVals, errorVals)

P = Pmax;
useMAP = true;
PairwiseOptimization;

plot(testVals, errorVals)

for testIndex = 1:length(testVals)
    N0 = prod(Pmax)^(2/length(Pmax)) / 10^(testVals(testIndex)/10);
    P = Pstart;
    IncrementalOptimalPowerAlgorithm;
    errorProbs(testIndex) = errorVals(end);
    powerUsage(1,testIndex) = sum(P.^2)/sum(Pmax.^2);
end

plot(testVals, errorProbs);

for testIndex = 1:length(testVals)
    N0 = prod(Pmax)^(2/length(Pmax)) / 10^(testVals(testIndex)/10);
    P = Pmax;
    IncrementalOptimalPowerAlgorithm;
    errorProbs(testIndex) = errorVals(end);
    powerUsage(2,testIndex) = sum(P.^2)/sum(Pmax.^2);
end

plot(testVals, errorProbs);
ylabel('Error Probability')
xlabel('SNR (dB)')
legend({'Ortho','MAC full','MAC full MAP','Pairwise MAC','Pairwise MAC MAP','MAC algo','MAC algo max'})

figure
plot(testVals, powerUsage);
ylabel('Power Usage Ratio')
xlabel('SNR (dB)')
legend({'MAC algo','MAC algo max'})

runningComparison = false;