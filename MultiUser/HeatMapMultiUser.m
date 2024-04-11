setupValsOverride = true; %#ok<NASGU>
N0 = 1;
P = [1, 1, 1, 1];
MultiUserSetup;
PVar = [3,4];
numXVals = 100;
xSearchOffset = 10;

% Values range to test over
testVals = linspace(0.001,5,100);

errorVals = zeros(length(testVals),length(testVals));

for P1Index = 1:length(testVals)
for P2Index = 1:length(testVals)
    
    P(PVar(1)) = testVals(P1Index);
    P(PVar(2)) = testVals(P2Index);
    
    MultiUserSetup;

    x = calculateXvalsMulti(points, P0, P1, pc0, pc1, N0, points(1)-xSearchOffset, points(2^N)+xSearchOffset, numXVals);
    
    errorVal = calculateErrorFromDRMulti(x, points, P0, P1, pc0, pc1, noistdv);
    
    errorVals(P2Index,P1Index) = errorVal;
end
end

% Error heat map P1 P2
figure
hold on
levels = 1000;
fontSize = 12;

set(gca,'ColorScale','log')
contourf(testVals, testVals, errorVals, levels, 'LineColor', 'none','HandleVisibility','off')
colorbar;

% Always set this back to false after using
setupValsOverride = false;