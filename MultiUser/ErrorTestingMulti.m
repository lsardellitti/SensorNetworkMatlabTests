if ~exist('runningComparison','var') == 1 || runningComparison == false
    P = [1 1 1 1 1];
    testVals = linspace(-10,15,50);
    trials = 50000;
end

errorProbs = zeros(1,length(testVals));

for testIndex = 1:length(testVals)
    N0 = prod(P)^(2/length(P)) / 10^(testVals(testIndex)/10);
    
    MultiUserSetup;

    % Single channel
    noise = mvnrnd(0,N0/2,trials);
    % Orthogonal channels
%     noise = mvnrnd(zeros(1,N),eye(N)*(N0/2),trials);
%     points = A(binWords+1).*P;
    % end of Orthogonal Channels
    
    source = rand(trials,1)<P1;
    channels = rand(trials,n)<E;
    signals = xor(source,channels);
    powers = 2.^(N-1:-1:0);
    sendPoints = points(sum(powers.*signals,2) + 1,:);
    recvPoints = sendPoints + noise;
    errors = 0;
    
    % MAP Detection 
    for i = 1:trials
        distances = sum((recvPoints(i,:)-points).^2,2);
        weight0 = P0*(sum(pc0.*(exp(-distances/N0))));
        weight1 = P1*(sum(pc1.*(exp(-distances/N0))));
        [~, decoded] = max([weight0, weight1]);
        if (decoded-1) ~= source(i)
            errors = errors + 1;
        end
    end
    
    errorProbs(testIndex) = errors / trials;
end

if exist('runningComparison','var') == 1 && runningComparison == true
    setupValsOverride = false;
    return
end

figure
plot(testVals, errorProbs);