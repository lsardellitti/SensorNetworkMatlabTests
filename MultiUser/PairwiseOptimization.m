if ~exist('runningComparison','var') == 1 || runningComparison == false
    Pmax = [1 2 2 2];
    testVals = linspace(0,4,50);
    useMAP = false;
    
    numXVals = 500;
    xSearchOffset = 10; 
end

errorVals = zeros(length(testVals),1);

PRatio = ((P0-P1)^2)/(P0*P1);

for testIndex = 1:length(testVals)
    N0 = prod(Pmax)^(2/length(P)) / 10^(testVals(testIndex)/10);
    
    P = Pmax;
    for i = 2:length(P)
        P(i) = (N0*P0*P1/(2*P(1)))*log(((1-E(1)-E(i))^2-PRatio*(1-E(1))*(1-E(i))*E(1)*E(i))/((E(i)-E(1))^2-PRatio*(1-E(1))*(1-E(i))*E(1)*E(i)));
        if ~isreal(P(i)) || P(i) > Pmax(i)
            P(i) = Pmax(i);
        end
    end
    
    MultiUserSetup;

    x = calculateXvalsMulti(points, P0, P1, pc0, pc1, N0, points(1)-xSearchOffset, points(2^N)+xSearchOffset, numXVals);
    
    if ~useMAP
        xErrVals = zeros(length(x), 1);
        for xIndex = 1:length(x)
            xErrVals(xIndex) = calculateErrorFromDRMulti(x(xIndex), points, P0, P1, pc0, pc1, noistdv);
        end
        errorVal = min(xErrVals);

        if isempty(x)
            errorVal = min(P0,P1);
        end
    else
        errorVal = calculateErrorFromDRMulti(x, points, P0, P1, pc0, pc1, noistdv);
    end

    errorVals(testIndex) = errorVal;

end