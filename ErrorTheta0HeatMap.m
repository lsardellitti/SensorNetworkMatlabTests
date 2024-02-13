setupValsOverride = true; %#ok<NASGU>
theta = 0;
N0 = 1;
numXVals = 1000;
xSearchOffset = 5;

% Values to test over
PwVals = linspace(0.001,3,50);
PsVals = linspace(0.001,3,50);

errorVals = zeros(length(PsVals),length(PwVals));

for PwIndex = 1:length(PwVals)
for PsIndex = 1:length(PsVals)
    % Comment out whichever parameter is being modified here in BaseSetup
    Ps = PsVals(PsIndex);
    Pw = PwVals(PwIndex);

    BaseSetup;

    x = calculateXvals(points, P0, P1, pc0, pc1, N0, knownFade, -Ps-Pw-xSearchOffset, Ps+Pw+xSearchOffset, numXVals);
    
    [errorVal, ~] = calculateErrorFromDR(x, points, P0, P1, pc0, pc1, noistdv);
    
    errorVals(PsIndex,PwIndex) = errorVal;
end
end

% Error heat map P1 P2
figure
hold on
levels = 1000;
fontSize = 12;
lineSize = 1;

set(gca,'ColorScale','log')
contourf(PwVals, PsVals, errorVals, levels, 'LineColor', 'none','HandleVisibility','off')
cBar = colorbar;
cBar.TickLabelInterpreter = 'latex';
cBar.Ticks = [0.02, 0.03, 0.05, 0.1, 0.2, 0.3];
cBar.TickLabels = {'$$2\times10^{-2}$$', '$$3\times10^{-2}$$', '$$5\times10^{-2}$$', '$$10^{-1}$$', '$$2\times10^{-1}$$', '$$3\times10^{-1}$$'};
title(cBar, '$$P_e(P_1,P_2)$$', 'Interpreter', 'latex','FontSize',fontSize)

if caseType == 3
    PsTildeVals = (N0*P0*P1./(2*PwVals))*log(((1-Ew-Es)^2-PRatio2*(1-Ew)*(1-Es)*Ew*Es)/((Es-Ew)^2-PRatio2*(1-Ew)*(1-Es)*Ew*Es));
    plot(PwVals, PsTildeVals, 'r', 'LineWidth', lineSize)
%     plot(PwVals, PwVals.^2 + PsTildeVals.^2, 'k', 'LineWidth', lineSize)
    legend('$$\tilde{P}_2(P_1)$$', 'Interpreter', 'latex','FontSize',fontSize)
    xlim([0 max(PwVals)])
    ylim([0 max(PsVals)])
    
    % Colour line for power usage
%     figure
%     z = zeros(size(PwVals));
%     col = PwVals.^2 + PsTildeVals.^2;
%     surface([PwVals;PwVals],[PsTildeVals;PsTildeVals],[z;z],[col;col],'facecol','no','edgecol','interp','linew',lineSize);
%     xlim([0 max(PwVals)])
%     ylim([0 max(PsVals)])
end

xlabel('$$P_1$$', 'Interpreter', 'latex','FontSize',fontSize) 
ylabel('$$P_2$$', 'Interpreter', 'latex','FontSize',fontSize) 

% Always set this back to false after using
setupValsOverride = false;