dataDir = 'ErrorProbSimulatedData';
thetaVals = linspace(0,pi/2,100);
errorCount = zeros(1,length(thetaVals));
trialCount = zeros(1,length(thetaVals));
errorProbs = zeros(1,length(thetaVals));
trials = 100000;

theta = 0;
BaseSetup;
if isfile(strcat(dataDir,sprintf('/N0%0.2fPw%0.2fPs%0.2fEw%0.2fEs%0.2f.mat',N0,Pw^2,Ps^2,Ew,Es)))
    % prevData has the data thetaVals, errorCount, trialCount, errorProbs
    prevData = load(strcat(dataDir,sprintf('/N0%0.2fPw%0.2fPs%0.2fEw%0.2fEs%0.2f.mat',N0,Pw^2,Ps^2,Ew,Es)));

    % Validate that theta vals match, can make better handling for errors
    if ~isequal(thetaVals, prevData.thetaVals)
        error("Theta vals do not match!");
    end
    errorCount = prevData.errorCount;
    trialCount = prevData.trialCount;
end

for thetaIndex = 1:length(thetaVals)
    theta = thetaVals(thetaIndex);
    BaseSetup;

    noise = mvnrnd([0,0],eye(2)*(N0/2),trials);
    source = rand(trials,1)<P1;
    weakChannel = rand(trials,1)<Ew;
    strongChannel = rand(trials,1)<Es;
    weakSignal = xor(source,weakChannel);
    strongSignal = xor(source,strongChannel);
    sendPoints = points(weakSignal + 2*strongSignal + 1,:); % this depends heavily on the order of points array
    recvPoints = sendPoints + noise;
    errors = 0;

    % decoding for Aw=As=1, P0=0.5
    % should probably use original expression instead of simplified one
    for i = 1:trials
        A = dot([recvPoints(i,1),recvPoints(i,2)], w1)*2/N0;
        B = dot([recvPoints(i,1),recvPoints(i,2)], s1)*2/N0;
        decoded = sign(B)*(tanh(A)/tanh(B)) > sign(B)*((K0-K1)/(K1+K0));
        if decoded ~= source(i)
            errors = errors + 1;
        end
    end
    
    errorCount(thetaIndex) = errorCount(thetaIndex) + errors;
    trialCount(thetaIndex) = trialCount(thetaIndex) + trials;
    errorProbs(thetaIndex) = errorCount(thetaIndex) / trialCount(thetaIndex);
end

fprintf('total trials: %d\n', trialCount(1));
save(strcat(dataDir,sprintf('/N0%0.2fPw%0.2fPs%0.2fEw%0.2fEs%0.2f.mat',N0,Pw^2,Ps^2,Ew,Es)), ...
    'thetaVals', 'errorProbs', 'trialCount', 'errorCount');

figure
plot(thetaVals, errorProbs);