theta = 0;
numXVals = 1000;
xSearchOffset = 10;

% Max powers, expressed as square roots of mean power
PwMax = 1;
PsMax = 1;

% Values for SNR testing
testVals = logspace(-2,2,100);

% Setup for multiple tests
numSetups = 4;
% First setup will always be Pw = PwMax, Ps = PsTilde
PwVals = [0, PwMax, PwMax, 0];
PsVals = [0, PsMax, 0, PsMax];

errorVals = zeros(length(testVals),numSetups);

for setup = 1:numSetups
for testIndex = 1:length(testVals)
    % Comment out whichever parameter is being modified here in BaseSetup
    N0 = testVals(testIndex);
    
    % Power allocation setups
    if setup == 1
        Pw = PwMax;
        Ps = 0; %#ok<NASGU> % Set for robustness
        BaseSetup;
        Ps = min(PsTilde,PsMax); % need to check for imaginary
    else
        Pw = PwVals(setup);
        Ps = PsVals(setup);
    end

    BaseSetup;

    x = calculateXvals(points, P0, P1, pc0, pc1, N0, knownFade, -Ps-Pw-xSearchOffset, Ps+Pw+xSearchOffset, numXVals);
    
    if isempty(x)
        errorVals(testIndex, setup) = min(P0,P1);
        continue
    elseif length(x) == 1
        p1g11 = normcdf((a11(1) - x(1))/noistdv);
        p1g01 = normcdf((a01(1) - x(1))/noistdv);
        p1g10 = normcdf((a10(1) - x(1))/noistdv);
        p1g00 = normcdf((a00(1) - x(1))/noistdv);
    elseif length(x) == 3
        p1g11 = normcdf((a11(1) - x(1))/noistdv) - normcdf((a11(1) - x(2))/noistdv) + normcdf((a11(1) - x(3))/noistdv);
        p1g01 = normcdf((a01(1) - x(1))/noistdv) - normcdf((a01(1) - x(2))/noistdv) + normcdf((a01(1) - x(3))/noistdv);
        p1g10 = normcdf((a10(1) - x(1))/noistdv) - normcdf((a10(1) - x(2))/noistdv) + normcdf((a10(1) - x(3))/noistdv);
        p1g00 = normcdf((a00(1) - x(1))/noistdv) - normcdf((a00(1) - x(2))/noistdv) + normcdf((a00(1) - x(3))/noistdv);
    else 
        % This would be bad
        error('Unexpected number of x vals found')
    end
    
    p0g11 = 1 - p1g11;
    p0g01 = 1 - p1g01;
    p0g10 = 1 - p1g10;
    p0g00 = 1 - p1g00;

    e0 = p11g0*p1g11 + p01g0*p1g01 + p10g0*p1g10 + p00g0*p1g00;
    e1 = p11g1*p0g11 + p01g1*p0g01 + p10g1*p0g10 + p00g1*p0g00;
    
    errorVals(testIndex, setup) = P0*e0 + P1*e1;
end
end %setup loop

% Error Prob SNR Comparisons
figure
hold on
plot(10*log10(PwMax.*PsMax./testVals),errorVals);
set(gca, 'YScale', 'log')
xlabel('SNR (dB)') 
ylabel('Error Probability')
legendText = {'$$P_1 = P_1^{max}, P_2 = \tilde{P}_2(P_1)$$','$$P_1 = P_1^{max}, P_2 = P_2^{max}$$','$$P_1 = P_1^{max}, P_2 =0$$','$$P_1 = 0, P_2 = P_2^{max}$$'};
legend(legendText, 'Interpreter', 'latex','FontSize',10)
