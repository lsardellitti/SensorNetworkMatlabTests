setupValsOverride = true; %#ok<NASGU>
theta = 0;
N0 = 1;
Pw = 1;
numXVals = 1000;
xSearchOffset = 5;

% Values range to test over
testVals = linspace(0.001,3,1000);

xBarVals = zeros(length(testVals),3);

for testIndex = 1:length(testVals)
    % Comment out whichever parameter is being modified here in BaseSetup
    Ps = testVals(testIndex);

    BaseSetup;

    x = calculateXvals(points, P0, P1, pc0, pc1, N0, knownFade, -Ps-Pw-xSearchOffset, Ps+Pw+xSearchOffset, numXVals);
    
    if isempty(x)
        xBarVals(testIndex,:) = [NaN NaN 0];
    elseif length(x) == 1
        xBarVals(testIndex,:) = [NaN NaN x];
    elseif length(x) == 3
        xBarVals(testIndex, :) = x;
    else 
        error('Unexpected number of x vals found')
    end
end

% X Value Bounds Graph
lineSize = 1;
useManualTicks = false;

figure
hold on
plot(testVals,xBarVals(:,1), 'Color', "#9421a3", 'LineWidth', lineSize);
plot(testVals,xBarVals(:,2), 'Color', "#e09119", 'LineWidth', lineSize);
plot(testVals,xBarVals(:,3), 'Color', "#2ea332", 'LineWidth', lineSize);
if caseType ~= 1
    plot(testVals,Aw*testVals - APsMinusXStar, 'b', 'LineWidth', lineSize);
end
if caseType == 3
    plot(testVals,BPsPlusXStar + Bw*testVals, 'Color', "#D95319", 'LineWidth', lineSize);
end

xlabel('$$P_2$$', 'Interpreter', 'latex') 
ylabel('$$x$$', 'Interpreter', 'latex')

legendText = {'$$x_1$$','$$x_2$$','$$x_3$$'};
if caseType ~= 1
    legendText = [legendText '$$\alpha P_2 - K_{\alpha}(P_1)$$'];
end
if caseType == 3
    legendText = [legendText '$$-\beta P_2 + K_{\beta}(P_1)$$'];
end
legend(legendText, 'NumColumns', 1, 'Interpreter', 'latex')

xaxisproperties = get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex';
yaxisproperties = get(gca, 'YAxis');
yaxisproperties.TickLabelInterpreter = 'latex';

if useManualTicks && caseType == 3
    xticks([0, 0.5, PsTilde, 1, 1.5, 2, 2.5])
    xticklabels({'0', '0.5', '$$\tilde{P}_2(P_1)$$', '1', '1.5', '2', '2.5'})
    yticks([-1, 0, Aw*PsTilde - APsMinusXStar, 1, 2, 3])
    yticklabels({'-1', '0', '$$\tilde{x}$$', '1', '2', '3'})
    plot([0 PsTilde], [Aw*PsTilde - APsMinusXStar Aw*PsTilde - APsMinusXStar], 'k--','HandleVisibility','off')
    plot([PsTilde PsTilde], [-1 Aw*PsTilde - APsMinusXStar], 'k--','HandleVisibility','off')
end

% Always set this back to false after using
setupValsOverride = false;