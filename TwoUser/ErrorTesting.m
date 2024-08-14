setupValsOverride = true; %#ok<NASGU>
testVals = linspace(0.01,3,100);
errorProbs = zeros(1,length(testVals));

for testIndex = 1:length(testVals)
    Pw = 1;
    Ps = testVals(testIndex);
    theta = 0;
    N0 = 1;

    BaseSetup;

    trials = 1000000;
    noise = mvnrnd([0,0],eye(2)*(N0/2),trials);
    if sigma > 0
        fading = raylrnd(sigma,trials,1);
    else 
        fading = knownFade*ones(trials,1);
    end
    source = rand(trials,1)<P1;
    weakChannel = rand(trials,1)<Ew;
    strongChannel = rand(trials,1)<Es;
    weakSignal = xor(source,weakChannel);
    strongSignal = xor(source,strongChannel);
    sendPoints = points(weakSignal + 2*strongSignal + 1,:); % this depends heavily on the order of points array
    recvPoints = fading.*sendPoints + noise;
    errors = 0;
    
    % map decoding from original expression (for no or known fading)
    for i = 1:trials
        distances = zeros(length(points),1);
        for k = 1:length(points)
           distances(k) = norm([recvPoints(i,1),recvPoints(i,2)] - fading(i)*points(k,:))^2; 
        end
        weight0 = P0*(sum(pc0.*(exp(-distances/N0))));
        weight1 = P1*(sum(pc1.*(exp(-distances/N0))));
        [~, decoded] = max([weight0, weight1]);
        
        if (decoded-1) ~= source(i)
            errors = errors + 1;
        end
    end
    
    errorProbs(testIndex) = errors / trials;
end

figure
plot(testVals, errorProbs);

setupValsOverride = false;