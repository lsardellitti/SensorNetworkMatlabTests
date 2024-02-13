setupValsOverride = true; %#ok<NASGU>
N0 = 1;
P = [1, 1, 1, 1];
MultiUserSetup;
% P = calcOptimalPUniform(N0, N, pBar, P(1));
PVar = 4;
PRel = 1;
numXVals = 1000;
xSearchOffset = 10;

% Values range to test over
testVals = linspace(0.001,5,1000);

xVals = zeros(length(testVals),2^length(P)-1);

for testIndex = 1:length(testVals)
    P(PVar) = testVals(testIndex);

    MultiUserSetup;

    x = calculateXvalsMulti(points, P0, P1, pc0, pc1, N0, points(1)-xSearchOffset, points(2^N)+xSearchOffset, numXVals);
    xRow = zeros(2^N-1,1)/0;
    
    if ~isempty(x)
        xRow(2^N-length(x):2^N-1) = x;
    end
    
    xVals(testIndex,:) = xRow;
end

figure
hold on
plot(testVals, xVals)
plot(testVals, calculateLineBound(testVals, PVar, PRel, A, N0, N, pBar, P, points))

setupValsOverride = false;