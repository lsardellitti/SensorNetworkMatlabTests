theta = 0;
numXVals = 1000;
xSearchOffset = 15;

% Max powers, expressed as square roots of mean power
PwMax = 1;
PsMax = 1;

% SNR Values for testing
testVals = linspace(-15,10,100);

% Setup for multiple tests
numSetups = 4;
% First setup will always be Pw = PwMax, Ps = PsTilde
PwVals = [0, PwMax, PwMax, 0];
PsVals = [0, PsMax, 0, PsMax];

errorVals = zeros(length(testVals),numSetups);

for setup = 1:numSetups
for testIndex = 1:length(testVals)
    N0 = PsMax*PwMax / 10^(testVals(testIndex)/10);
    
    % Power allocation setups
    if setup == 1
        Pw = PwMax;
        Ps = 0; %#ok<NASGU>
        BaseSetup;
        if caseType == 3
            Ps = min(PsTilde,PsMax); % need to check for imaginary
        else
            Ps = PsMax;
        end
    else
        Pw = PwVals(setup);
        Ps = PsVals(setup);
    end

    BaseSetup;

    x = calculateXvals(points, P0, P1, pc0, pc1, N0, knownFade, -Ps-Pw-xSearchOffset, Ps+Pw+xSearchOffset, numXVals);
    
    [errorVal, ~] = calculateErrorFromDR(x, points, P0, P1, pc0, pc1, noistdv);
    
    errorVals(testIndex, setup) = errorVal;
end
end

% Error Prob SNR Comparisons
figure
hold on
styles = repmat("-",numSetups,1);
styles(2) = '--';
for i= 1:numSetups
    plot(testVals,errorVals(:,i),'LineStyle',styles(i));
end
set(gca, 'YScale', 'log')
xlabel('SNR (dB)') 
ylabel('Error Probability')
legendText = {'$$P_1 = P_1^{max}, P_2 = P_2^*(P_1^{max})$$','$$P_1 = P_1^{max}, P_2 = P_2^{max}$$','$$P_1 = P_1^{max}, P_2 =0$$','$$P_1 = 0, P_2 = P_2^{max}$$'};
legend(legendText, 'Interpreter', 'latex','FontSize',10)
title(sprintf('$$p_1 = %0.2f, \\epsilon_1 = %0.2f, \\epsilon_2 = %0.2f, P_1^{max} = %0.2f, P_2^{max} = %0.2f, Case %0.0f$$',P1,Ew,Es,PwMax,PsMax,caseType), 'Interpreter', 'latex')