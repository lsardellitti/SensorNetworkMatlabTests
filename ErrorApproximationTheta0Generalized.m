theta = 0;
numXVals = 5000;
xSearchOffset = 0;

% Max powers, expressed as square roots of mean power
PwMax = 1;
PsMax = 1;

% Square grid setup
% baseVals = linspace(0.001,3,100);
% 
% PwVals = ones(length(baseVals)^2,1);
% PsVals = ones(length(baseVals)^2,1);
% 
% for i = 1:length(baseVals)
%     for j = 1:length(baseVals)
%         PwVals((i-1)*length(baseVals) + j) = baseVals(i);
%         PsVals((i-1)*length(baseVals) + j) = baseVals(j);
%     end
% end

% Values range to test over
testVals = [linspace(0.001,2.5,1000) linspace(1.57,1.58,1000) linspace(1.58,2.5,1000)];

% Values for SNR testing
% testVals = logspace(-2,2,100);

% Bound for testing asymmetric constellation parameters
% testVals = linspace(0,1/sqrt(P1),1000);

% Setup for multiple tests (SNR vary tests)
numSetups = 1;
% First setup will always be Pw = PwMax, Ps = PsTilde
PwVals = [0, PwMax, PwMax, 0];
PsVals = [0, PsMax, 0, PsMax];

errorVals = zeros(length(testVals),numSetups);
xBarVals = zeros(length(testVals),3);
lowerBoundVals = zeros(length(testVals),1);

for setup = 1:numSetups
for testIndex = 1:length(testVals)
    % Comment out whichever parameter is being modified here in BaseSetup
    Ps = testVals(testIndex);
    
    % Power allocation setups
%     if setup == 1
%         Pw = PwMax;
%         Ps = 0; %#ok<NASGU> % Set for robustness
%         BaseSetup;
%         Ps = min(PsTilde,PsMax); % need to check for imaginary
%     else
%         Pw = PwVals(setup);
%         Ps = PsVals(setup);
%     end

    BaseSetup;

    x = calculateXvals(points, P0, P1, pc0, pc1, N0, knownFade, -Ps-Pw-xSearchOffset, Ps+Pw+xSearchOffset, numXVals);
    
    if isempty(x)
        xBarVals(testIndex,:) = [NaN NaN 0];
        errorVals(testIndex, setup) = min(P0,P1);
        lowerBoundVals(testIndex) = min(P0,P1);
        continue
    elseif length(x) == 1
        xBarVals(testIndex,:) = [NaN NaN x];
        p1g11 = normcdf((a11(1) - x(1))/noistdv);
        p1g01 = normcdf((a01(1) - x(1))/noistdv);
        p1g10 = normcdf((a10(1) - x(1))/noistdv);
        p1g00 = normcdf((a00(1) - x(1))/noistdv);
        
        LBp1g11 = p1g11;
        LBp1g01 = p1g01;
        LBp1g10 = p1g10;
        LBp1g00 = p1g00;
    elseif length(x) == 3
        xBarVals(testIndex, :) = x;
        p1g11 = normcdf((a11(1) - x(1))/noistdv) - normcdf((a11(1) - x(2))/noistdv) + normcdf((a11(1) - x(3))/noistdv);
        p1g01 = normcdf((a01(1) - x(1))/noistdv) - normcdf((a01(1) - x(2))/noistdv) + normcdf((a01(1) - x(3))/noistdv);
        p1g10 = normcdf((a10(1) - x(1))/noistdv) - normcdf((a10(1) - x(2))/noistdv) + normcdf((a10(1) - x(3))/noistdv);
        p1g00 = normcdf((a00(1) - x(1))/noistdv) - normcdf((a00(1) - x(2))/noistdv) + normcdf((a00(1) - x(3))/noistdv);
        
        LBp1g11 = normcdf((a11(1) - x(3))/noistdv);
        LBp1g01 = normcdf((a01(1) - x(3))/noistdv);
        LBp1g10 = normcdf((a10(1) - x(1))/noistdv);
        LBp1g00 = normcdf((a00(1) - x(1))/noistdv);
    else 
        % This would be bad
        error('Unexpected number of x vals found')
    end
    
    p0g11 = 1 - p1g11;
    p0g01 = 1 - p1g01;
    p0g10 = 1 - p1g10;
    p0g00 = 1 - p1g00;
    
    LBp0g11 = 1 - LBp1g11;
    LBp0g01 = 1 - LBp1g01;
    LBp0g10 = 1 - LBp1g10;
    LBp0g00 = 1 - LBp1g00;

    e0 = p11g0*p1g11 + p01g0*p1g01 + p10g0*p1g10 + p00g0*p1g00;
    e1 = p11g1*p0g11 + p01g1*p0g01 + p10g1*p0g10 + p00g1*p0g00;
    
    LBe0 = p11g0*LBp1g11 + p01g0*LBp1g01 + p10g0*LBp1g10 + p00g0*LBp1g00;
    LBe1 = p11g1*LBp0g11 + p01g1*LBp0g01 + p10g1*LBp0g10 + p00g1*LBp0g00;
    
    errorVals(testIndex, setup) = P0*e0 + P1*e1;
    lowerBoundVals(testIndex) = P0*LBe0 + P1*LBe1;
end
end %setup loop

% X Value Bounds Graph
lineSize = 1;
figure
hold on
plot(testVals,xBarVals(:,1), 'Color', "#9421a3", 'LineWidth', lineSize);
plot(testVals,xBarVals(:,2), 'Color', "#e09119", 'LineWidth', lineSize);
plot(testVals,xBarVals(:,3), 'Color', "#2ea332", 'LineWidth', lineSize);
plot(testVals,Aw*testVals - APsMinusXStar, 'b', 'LineWidth', lineSize);
plot(testVals,BPsPlusXStar + Bw*testVals, 'Color', "#D95319", 'LineWidth', lineSize);

xlabel('$$P_2$$', 'Interpreter', 'latex') 
ylabel('$$x$$', 'Interpreter', 'latex') 
legendText = {'$$x_1$$','$$x_2$$','$$x_3$$','$$\alpha P_2 - K_{\alpha}(P_1)$$','$$-\beta P_2 + K_{\beta}(P_1)$$'};
legend(legendText, 'NumColumns', 1, 'Interpreter', 'latex')
% title('Case III Solutions to $$w(x) = 0$$', 'Interpreter', 'latex')
xaxisproperties = get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex';
yaxisproperties = get(gca, 'YAxis');
yaxisproperties.TickLabelInterpreter = 'latex';

xticks([0, 0.5, PsTilde, 1, 1.5, 2, 2.5])
xticklabels({'0', '0.5', '$$\tilde{P}_2(P_1)$$', '1', '1.5', '2', '2.5'})
yticks([-1, 0, Aw*PsTilde - APsMinusXStar, 1, 2, 3])
yticklabels({'-1', '0', '$$\tilde{x}$$', '1', '2', '3'})
plot([0 PsTilde], [Aw*PsTilde - APsMinusXStar Aw*PsTilde - APsMinusXStar], 'k--','HandleVisibility','off')
plot([PsTilde PsTilde], [-1 Aw*PsTilde - APsMinusXStar], 'k--','HandleVisibility','off')

% Error heat map P1 P2
% figure
% hold on
% levels = 1000;
% fontSize = 12;
% lineSize = 1;
% 
% errorMatrix = reshape(errorVals, length(baseVals), length(baseVals));
% set(gca,'ColorScale','log')
% contourf(baseVals, baseVals, errorMatrix, levels, 'LineColor', 'none','HandleVisibility','off')
% cBar = colorbar;
% cBar.TickLabelInterpreter = 'latex';
% cBar.Ticks = [0.02, 0.03, 0.05, 0.1, 0.2, 0.3];
% cBar.TickLabels = {'$$2\times10^{-2}$$', '$$3\times10^{-2}$$', '$$5\times10^{-2}$$', '$$10^{-1}$$', '$$2\times10^{-1}$$', '$$3\times10^{-1}$$'};
% title(cBar, '$$P_e(P_1,P_2)$$', 'Interpreter', 'latex','FontSize',fontSize)
% 
% PsTildeVals = (N0*P0*P1./(2*baseVals))*log(((1-Ew-Es)^2-PRatio2*(1-Ew)*(1-Es)*Ew*Es)/((Es-Ew)^2-PRatio2*(1-Ew)*(1-Es)*Ew*Es));
% plot(baseVals, PsTildeVals, 'r', 'LineWidth', lineSize)
% legend('$$\tilde{P}_2(P_1)$$', 'Interpreter', 'latex','FontSize',fontSize)
% xlim([0 3])
% ylim([0 3])
% xlabel('$$P_1$$', 'Interpreter', 'latex','FontSize',fontSize) 
% ylabel('$$P_2$$', 'Interpreter', 'latex','FontSize',fontSize) 

% plot(testVals,errorVals);
% xlabel('P2') 
% ylabel('Error Probability')

% Error Prob SNR Comparisons
% figure
% hold on
% plot(10*log10(PwMax.*PsMax./testVals),errorVals);
% set(gca, 'YScale', 'log')
% xlabel('SNR (dB)') 
% ylabel('Error Probability')
% legendText = {'$$P_1 = P_1^{max}, P_2 = \tilde{P}_2(P_1)$$','$$P_1 = P_1^{max}, P_2 = P_2^{max}$$','$$P_1 = P_1^{max}, P_2 =0$$','$$P_1 = 0, P_2 = P_2^{max}$$'};
% legend(legendText, 'Interpreter', 'latex','FontSize',10)

% [~, idx] = min(errorVals);
% testVals(idx)
% xBarVals(idx)

function [xVals] = calculateXvals(points, P0, P1, pc0, pc1, N0, knownFade, xMin, xMax, numVals)
    xTests = linspace(xMin,xMax,numVals);
    prevI = -1;
    xVals = [];
    for xIndex = 1:length(xTests)
        x = xTests(xIndex);
        condProbVals = zeros(length(points),1);
        for k = 1:length(points)
           distance = (x - knownFade*points(k,1))^2;
           condProbVals(k) = exp(-distance/N0);
        end
        weight0 = P0*(sum(pc0.*condProbVals));
        weight1 = P1*(sum(pc1.*condProbVals));
        
        if weight0 == weight1
           continue
        end
        
        [~, I] = max([weight0, weight1]);
        if I ~= prevI
            if prevI ~= -1
                xVal = (xTests(xIndex) + xTests(xIndex-1))/2;
                xVals = [xVals xVal]; %#ok<*AGROW>
            end
            prevI = I;
        end
    end
end
