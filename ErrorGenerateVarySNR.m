dataDir = 'ErrorVarySNRMultiRuns';
thetaVals = linspace(0,pi/2,100);

trialsPerRun = 100000;
numRuns = 10;

% signal powers (expressed as square root of mean power)
Pw = sqrt(1);
Ps = sqrt(2);
Ew = 0.01;
Es = 0.02;

% SNR values (in dB)
SNRVals = [-10, -6, -3, 0, 3, 6, 10, 13, 16, 20];

for SNRindex = 1:length(SNRVals)

SNR = SNRVals(SNRindex);
N0 = Pw*Ps/(10^(SNR/10));

dataFolder = strcat(dataDir,sprintf('/Pw%0.2fPs%0.2fEw%0.2fEs%0.2f',Pw^2,Ps^2,Ew,Es));
if not(isfolder(dataFolder))
    mkdir(dataFolder)
end

totalErrorProbs = [];

fileName = strcat(dataFolder,sprintf('/N0%09.5f.mat',N0));

if isfile(fileName)
    % prevData has the data thetaVals, trialsPerRun, totalErrorProbs
    prevData = load(fileName);

    % Validate that theta vals match, can make better handling for errors
    if ~isequal(thetaVals, prevData.thetaVals) || (trialsPerRun ~= prevData.trialsPerRun)
        error("Theta or numTrials vals do not match!");
    end

    totalErrorProbs = prevData.totalErrorProbs;
end

errorProbs = zeros(1,length(thetaVals));

for run = 1:numRuns

for thetaIndex = 1:length(thetaVals)
    theta = thetaVals(thetaIndex);
    ConstellationSetup;

    noise = mvnrnd([0,0],eye(2)*(N0/2),trialsPerRun);
    source = rand(trialsPerRun,1)<P1;
    weakChannel = rand(trialsPerRun,1)<Ew;
    strongChannel = rand(trialsPerRun,1)<Es;
    weakSignal = xor(source,weakChannel);
    strongSignal = xor(source,strongChannel);
    sendPoints = points(weakSignal + 2*strongSignal + 1,:); % this depends heavily on the order of points array
    recvPoints = sendPoints + noise;
    errors = 0;
    
    % Using original decoding expression
    for i = 1:trialsPerRun
        distances = zeros(length(points),1);
        for k = 1:length(points)
           distances(k) = norm([recvPoints(i,1),recvPoints(i,2)] - points(k,:))^2; 
        end
        weight0 = P0*(sum(pc0.*(exp(-distances/N0))));
        weight1 = P1*(sum(pc1.*(exp(-distances/N0))));
        [~, decoded] = max([weight0, weight1]);
        
        if (decoded-1) ~= source(i)
            errors = errors + 1;
        end
    end
    
    errorProbs(thetaIndex) = errors / trialsPerRun;
end

totalErrorProbs = [totalErrorProbs ; errorProbs];

end % num run loop

save(fileName, 'thetaVals', 'trialsPerRun', 'totalErrorProbs');

end % SNR loop