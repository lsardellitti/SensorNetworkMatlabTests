setupValsOverride = true; %#ok<NASGU>
N0 = 1;

if ~exist('runningComparison','var') == 1 || runningComparison == false
    P = [1 1 1 1 1 1];
    testVals = linspace(-10,20,50);
    useMAP = false;
    
    numXVals = 500;
    xSearchOffset = 10;
end

MultiUserSetup;
% P = calcOptimalPUniform(N0, N, pBar, P(1));
PVar = 4;

errorVals = zeros(length(testVals),1);
PTildeVals = zeros(length(testVals),1);
t1Vals = zeros(length(testVals),1);
t2Vals = zeros(length(testVals),1);

for testIndex = 1:length(testVals)
%     for pInd = PVar
%         P(pInd) = testVals(testIndex);
%     end
    N0 = prod(P)^(2/n) / 10^(testVals(testIndex)/10);
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

if exist('runningComparison','var') == 1 && runningComparison == true
    setupValsOverride = false;
    return
end

figure
hold on
plot(testVals, errorVals)
% xlabel('P2') 
ylabel('Error Probability')

setupValsOverride = false;