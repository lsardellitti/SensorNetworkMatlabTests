dataDir = 'ErrorProbSimulatedData';
theta = 0;
BaseSetup;

% data has thetaVals, errorCount, trialCount, errorProbs
data = load(strcat(dataDir,sprintf('/N0%0.2fPw%0.2fPs%0.2fEw%0.2fEs%0.2f.mat',N0,Pw^2,Ps^2,Ew,Es)));

figure
plot(data.thetaVals, data.errorProbs);