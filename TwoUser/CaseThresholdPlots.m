P1 = 0.05;

EwVals = linspace(0.001,0.5,1000);
EsVals = linspace(0.001,0.5,1000);

caseVals = zeros(length(EsVals),length(EwVals))*nan;

for EwIndex = 1:length(EwVals)
for EsIndex = 1:length(EsVals)
    Es = EsVals(EsIndex);
    Ew = EwVals(EwIndex);
    
    if Es < Ew
        continue
    end
    
    case1Thresh = (Ew*Es)/(1 - Ew - Es + 2*Ew*Es);
    if Ew <= Es
        case2Thresh = (Ew - Ew*Es)/(Ew + Es - 2*Ew*Es);
    else
        case2Thresh = (Es - Ew*Es)/(Ew + Es - 2*Ew*Es);
    end
    if P1 <= case1Thresh
        caseType = 1;
    elseif P1 <= case2Thresh
        caseType = 2;
    else
        caseType = 3;
    end

    caseVals(EsIndex,EwIndex) = caseType;
end
end

case1ThreshVals = P1*(1-EwVals)./(EwVals+P1-2*P1*EwVals);
case2ThreshVals = (EwVals*(1-P1))./(EwVals+P1-2*P1*EwVals);

figure
hold on
levels = 3;
fontSize = 12;
lineSize = 1.5;

contourf(EwVals, EsVals, caseVals, levels, 'LineColor', 'none','HandleVisibility','off')
caxis([1 3])
colormap(parula(3));
cBar = colorbar;
cBar.Ticks = [1.33,2,2.66];
cBar.TickLabels = {'1', '2', '3'};
title(cBar, 'Case', 'Interpreter', 'latex', 'FontSize',fontSize)

xlabel('$$\epsilon_1$$', 'Interpreter', 'latex','FontSize',fontSize) 
ylabel('$$\epsilon_2$$', 'Interpreter', 'latex','FontSize',fontSize) 
% title(sprintf('$$p_1 = %0.2f$$',P1), 'Interpreter', 'latex')

% annotation('textbox', 'String', '$$\frac{\epsilon_1\epsilon_2}{1-\epsilon_1-\epsilon_2+2\epsilon_1\epsilon_2} = p_1$$', 'Interpreter', 'latex', 'EdgeColor', 'none', 'FontSize',fontSize)
% annotation('textbox', 'String', '$$\frac{\epsilon_1-\epsilon_1\epsilon_2}{\epsilon_1+\epsilon_2-2\epsilon_1\epsilon_2} = p_1$$', 'Interpreter', 'latex', 'EdgeColor', 'none', 'FontSize',fontSize)

plot(EwVals, case1ThreshVals./(case1ThreshVals>=EwVals), 'Color', "#ff1100", 'LineWidth', lineSize)
plot(EwVals, case2ThreshVals, '--', 'Color', "#000000", 'LineWidth', lineSize)

legendText = {'$$p_1 = \frac{\epsilon_1\epsilon_2}{1-\epsilon_1-\epsilon_2+2\epsilon_1\epsilon_2}$$','$$p_1 = \frac{\epsilon_1-\epsilon_1\epsilon_2}{\epsilon_1+\epsilon_2-2\epsilon_1\epsilon_2}$$'};
legend(legendText, 'NumColumns', 1, 'Interpreter', 'latex', 'FontSize', fontSize)

xaxisproperties = get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex';
yaxisproperties = get(gca, 'YAxis');
yaxisproperties.TickLabelInterpreter = 'latex';

xlim([0 0.5])
ylim([0 0.5])
