setupValsOverride = true; %#ok<NASGU>
N0 = 1;
P = [1.0000    1.1116    0.9134    0.7321    0.6318];
MultiUserSetup;
% P = calcOptimalPUniform(N0, N, pBar, P(1));
PVar = 1;
numXVals = 1000;
xSearchOffset = 10;

% Values range to test over
testVals = linspace(0,2,500);

errorVals = zeros(length(testVals),1);
PTildeVals = zeros(length(testVals),1);
t1Vals = zeros(length(testVals),1);
t2Vals = zeros(length(testVals),1);

for testIndex = 1:length(testVals)
    for pInd = PVar
        P(pInd) = testVals(testIndex);
    end
    
    MultiUserSetup;

    x = calculateXvalsMulti(points, P0, P1, pc0, pc1, N0, points(1)-xSearchOffset, points(2^N)+xSearchOffset, numXVals);
    
    % One Decision Boundary
    xErrVals = zeros(length(x), 1);
    for xIndex = 1:length(x)
        xErrVals(xIndex) = calculateErrorFromDRMulti(x(xIndex), points, P0, P1, pc0, pc1, noistdv);
    end
	errorVal = min(xErrVals);
    
    if isempty(x)
        errorVal = min(P0,P1);
    end
    
    % MAP detection Boundaries
%     errorVal = calculateErrorFromDRMulti(x, points, P0, P1, pc0, pc1, noistdv);

    errorVals(testIndex) = errorVal;

end

figure
hold on
plot(testVals, errorVals)
% xlabel('P2') 
ylabel('Error Probability')

setupValsOverride = false;