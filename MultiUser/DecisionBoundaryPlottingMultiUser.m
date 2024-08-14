setupValsOverride = true; %#ok<NASGU>
N0 = 1;
P = [1 1];
MultiUserSetup;
% P = calcOptimalPUniform(N0, N, pBar, P(1));
PVar = 2;
PRel = 1;

repVec1 = [ones(2^(length(P)-PVar),1); zeros(2^(length(P)-PVar),1)];
repVec2 = [zeros(2^(length(P)-PVar),1); ones(2^(length(P)-PVar),1)];
repNum = PVar-1; % number of constant sensors
multNum = 1; % number of overlap in repVec

numXVals = 5000;
xSearchOffset = 10;

% Values range to test over
testVals = linspace(0.001,1,100);

xVals = zeros(length(testVals),2^length(P)-1);

for testIndex = 1:length(testVals)
    for pInd = PVar
        P(pInd) = testVals(testIndex);
    end

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
% plot(testVals, calculateLineBound(testVals, PVar, PRel, A, N0, N, pBar, P, points))

P(PVar) = 0.0;
MultiUserSetup;
t1Vals = zeros(numXVals, 1);
t2Vals = zeros(numXVals, 1);
xTVals = linspace(points(1)-xSearchOffset, points(2^N)+xSearchOffset, numXVals);

for xTestIndex = 1:numXVals
    xTest = xTVals(xTestIndex);
    t1Vals(xTestIndex) = calculateErrorFromDRMulti(xTest, points, P0, P1, pc0, pc1, noistdv, repmat(repVec1, 2^repNum, 1));
    t2Vals(xTestIndex) = calculateErrorFromDRMulti(xTest, points, P0, P1, pc0, pc1, noistdv, repmat(repVec2, 2^repNum, 1));
end

[~, x1minIndex] = min(t1Vals);
[~, x2minIndex] = min(t2Vals);
x1Min = xTVals(x1minIndex);
x2Min = xTVals(x2minIndex);

% [xMin, ~, ~] = calculateOptimalPVal(P, N0, xSearchOffset, numXVals, PVar);
% x1Min = xMin(1);
% x2Min = xMin(2);

plot(testVals, multNum*A(1)*testVals + x1Min);
plot(testVals, multNum*A(2)*testVals + x2Min);

figure;
hold on;
plot(xTVals, t1Vals);
plot(xTVals, t2Vals);

setupValsOverride = false;