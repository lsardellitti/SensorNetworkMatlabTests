setupValsOverride = true; %#ok<NASGU>
N0 = 1;
P = [1 0.7 0.5 0.1];
testVals = linspace(-5,10,25);
errorProbs = zeros(1,length(testVals));

for testIndex = 1:length(testVals)
%     P(1) = testVals(testIndex);
    N0 = prod(P)^(2/n) / 10^(testVals(testIndex)/10);
    
    MultiUserSetup;

    trials = 100000;
    % Single channel
%     noise = mvnrnd(0,N0/2,trials);
    % Orthogonal channels
    noise = mvnrnd(zeros(1,N),eye(N)*(N0/2),trials);
    points = A(binWords+1).*P;

    source = rand(trials,1)<P1;
    channels = rand(trials,n)<E;
    signals = xor(source,channels);
    powers = 2.^(N-1:-1:0);
    sendPoints = points(sum(powers.*signals,2) + 1,:);
    recvPoints = sendPoints + noise;
    errors = 0;

    % map decoding from original expression (for no fading)
    for i = 1:trials
        distances = zeros(length(points),1);
        for k = 1:length(points)
           distances(k) = norm(recvPoints(i,:) - points(k,:))^2; 
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