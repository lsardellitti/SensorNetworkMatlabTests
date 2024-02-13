setupValsOverride = true; %#ok<NASGU>
N0 = 1;
P = [1, 1, 1, 1];
MultiUserSetup;
% P = calcOptimalPUniform(N0, N, pBar, P(1));
PVar = 4;
numXVals = 1000;
xSearchOffset = 10;

% Values range to test over
testVals = linspace(0.001,5,1000);

errorVals = zeros(length(testVals),1);

for testIndex = 1:length(testVals)
    P(PVar) = testVals(testIndex);

    MultiUserSetup;

    x = calculateXvalsMulti(points, P0, P1, pc0, pc1, N0, points(1)-xSearchOffset, points(2^N)+xSearchOffset, numXVals);
    
    errorVal = calculateErrorFromDRMulti(x, points, P0, P1, pc0, pc1, noistdv);
    
    errorVals(testIndex) = errorVal;
end

figure
hold on
plot(testVals, errorVals)
% xlabel('P2') 
ylabel('Error Probability')

setupValsOverride = false;