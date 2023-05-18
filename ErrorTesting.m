% Note: to vary theta in BaseSetup, comment out its defnition.
thetaVals = linspace(0,pi/2,100);
errorProbs = zeros(1,length(thetaVals));
thetaDR = 0;

for thetaIndex = 1:length(thetaVals)
    theta = thetaVals(thetaIndex);
    BaseSetup;

    trials = 500000;
    noise = mvnrnd([0,0],eye(2)*(N0/2),trials);
    source = rand(trials,1)<P1;
    weakChannel = rand(trials,1)<Ew;
    strongChannel = rand(trials,1)<Es;
    weakSignal = xor(source,weakChannel);
    strongSignal = xor(source,strongChannel);
    sendPoints = points(weakSignal + 2*strongSignal + 1,:); % this depends heavily on the order of points array
    recvPoints = sendPoints + noise;
    errors = 0;

    % simplified decoding for P0=0.5
    % For more precision use original expression
    for i = 1:trials
        A = dot([recvPoints(i,1),recvPoints(i,2)]-centerPoint, (abs(w0) + w1)/2)*2/N0;
        B = dot([recvPoints(i,1),recvPoints(i,2)]-centerPoint, (abs(s0) + s1)/2)*2/N0;
        decoded = sign(B)*(tanh(A)/tanh(B)) > sign(B)*((K0-K1)/(K1+K0));
        if decoded ~= source(i)
            errors = errors + 1;
        end
    end
    
    % map decoding from original expression
%     for i = 1:trials
%         distances = zeros(length(points),1);
%         for k = 1:length(points)
%            distances(k) = norm([recvPoints(i,1),recvPoints(i,2)] - points(k,:))^2; 
%         end
%         weight0 = P0*(sum(pc0.*(exp(-distances/N0))));
%         weight1 = P1*(sum(pc1.*(exp(-distances/N0))));
%         [~, decoded] = max([weight0, weight1]);
%         
%         if (decoded-1) ~= source(i)
%             errors = errors + 1;
%         end
%     end
    
    errorProbs(thetaIndex) = errors / trials;
end

figure
plot(thetaVals, errorProbs);