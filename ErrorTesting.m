% Note: to vary theta in BaseSetup, comment out its defnition.
testVals = linspace(-5,10,50);
errorProbs = zeros(1,length(testVals));

for testIndex = 1:length(testVals)
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

    % simplified decoding for no fading P0=0.5
    % For more precision use original expression
%     for i = 1:trials
%         A = dot([recvPoints(i,1),recvPoints(i,2)]-centerPoint, (abs(w0) + w1)/2)*2/N0;
%         B = dot([recvPoints(i,1),recvPoints(i,2)]-centerPoint, (abs(s0) + s1)/2)*2/N0;
%         decoded = sign(B)*(tanh(A)/tanh(B)) > sign(B)*((K0-K1)/(K1+K0));
%         if decoded ~= source(i)
%             errors = errors + 1;
%         end
%     end
    
    % map decoding with unknown fading P0=0.5, Aw=As=1
%     alph11 = -(norm(points(4,:))^2)/N0 - 1/(2*sigma^2);
%     alph01 = -(norm(points(3,:))^2)/N0 - 1/(2*sigma^2);
%     for i = 1:trials
%         beta11 = 2*(recvPoints(i,1)*points(4,1) + recvPoints(i,2)*points(4,2))/N0;
%         beta01 = 2*(recvPoints(i,1)*points(3,1) + recvPoints(i,2)*points(3,2))/N0;
%         
%         decoded = (1-Ew-Es)*beta11*exp(-(beta11^2)/(4*alph11))/(2*(-alph11)^(3/2)) > (Es-Ew)*beta01*exp(-(beta01^2)/(4*alph01))/(2*(-alph01)^(3/2));
%         if decoded ~= source(i)
%             errors = errors + 1;
%         end
%     end
    
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