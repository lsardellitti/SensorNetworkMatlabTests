theta = 0;
numXVals = 1000;
xSearchOffset = 10;

% Values range to test over
testVals = linspace(0.001,2.5,1000);

errorVals = zeros(length(testVals),1);
lowerBoundVals = zeros(length(testVals),1);

for testIndex = 1:length(testVals)
    % Comment out whichever parameter is being modified here in BaseSetup
    Ps = testVals(testIndex);

    BaseSetup;

    x = calculateXvals(points, P0, P1, pc0, pc1, N0, knownFade, -Ps-Pw-xSearchOffset, Ps+Pw+xSearchOffset, numXVals);
    
    [errorVal, lowerBoundVal] = calculateErrorFromDR(x, points, P0, P1, pc0, pc1, noistdv);
    
    errorVals(testIndex) = errorVal;
    lowerBoundVals(testIndex) = lowerBoundVal;
end

figure
hold on
plot(testVals, errorVals)
plot(testVals, lowerBoundVals)
xlabel('P2') 
ylabel('Error Probability')

% [~, idx] = min(errorVals);
% testVals(idx)
% xBarVals(idx)
