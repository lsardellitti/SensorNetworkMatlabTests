theta = 0;
numXVals = 1000;
xSearchOffset = 5;

% Values to test over
testPwVals = linspace(0.001,3,50);
testPsVals = linspace(0.001,3,50);

testLength = length(testPwVals)*length(testPsVals);

PwVals = ones(testLength,1);
PsVals = ones(testLength,1);

for i = 1:length(testPwVals)
    for j = 1:length(testPsVals)
        PwVals((i-1)*length(testPsVals) + j) = testPwVals(i);
        PsVals((i-1)*length(testPsVals) + j) = testPsVals(j);
    end
end

errorVals = zeros(testLength,1);

for testIndex = 1:testLength
    % Comment out whichever parameter is being modified here in BaseSetup
    Ps = PsVals(testIndex);
    Pw = PwVals(testIndex);

    BaseSetup;

    x = calculateXvals(points, P0, P1, pc0, pc1, N0, knownFade, -Ps-Pw-xSearchOffset, Ps+Pw+xSearchOffset, numXVals);
    
    [errorVal, ~] = calculateErrorFromDR(x, points, P0, P1, pc0, pc1, noistdv);
    
    errorVals(testIndex) = errorVal;
end

% Error heat map P1 P2
figure
hold on
levels = 1000;
fontSize = 12;
lineSize = 1;

errorMatrix = reshape(errorVals, length(testPsVals), length(testPwVals));
set(gca,'ColorScale','log')
contourf(testPwVals, testPsVals, errorMatrix, levels, 'LineColor', 'none','HandleVisibility','off')
cBar = colorbar;
cBar.TickLabelInterpreter = 'latex';
cBar.Ticks = [0.02, 0.03, 0.05, 0.1, 0.2, 0.3];
cBar.TickLabels = {'$$2\times10^{-2}$$', '$$3\times10^{-2}$$', '$$5\times10^{-2}$$', '$$10^{-1}$$', '$$2\times10^{-1}$$', '$$3\times10^{-1}$$'};
title(cBar, '$$P_e(P_1,P_2)$$', 'Interpreter', 'latex','FontSize',fontSize)

if caseType == 3
    PsTildeVals = (N0*P0*P1./(2*testPwVals))*log(((1-Ew-Es)^2-PRatio2*(1-Ew)*(1-Es)*Ew*Es)/((Es-Ew)^2-PRatio2*(1-Ew)*(1-Es)*Ew*Es));
    plot(testPwVals, PsTildeVals, 'r', 'LineWidth', lineSize)
    legend('$$\tilde{P}_2(P_1)$$', 'Interpreter', 'latex','FontSize',fontSize)
    xlim([0 max(testPwVals)])
    ylim([0 max(testPsVals)])
end

xlabel('$$P_1$$', 'Interpreter', 'latex','FontSize',fontSize) 
ylabel('$$P_2$$', 'Interpreter', 'latex','FontSize',fontSize) 
