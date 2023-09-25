theta = 0;
numXVals = 1000;
xSearchOffset = 5;

% Values to test over
testVals = linspace(0.001,3,50);

PwVals = ones(length(testVals)^2,1);
PsVals = ones(length(testVals)^2,1);

for i = 1:length(testVals)
    for j = 1:length(testVals)
        PwVals((i-1)*length(testVals) + j) = testVals(i);
        PsVals((i-1)*length(testVals) + j) = testVals(j);
    end
end

errorVals = zeros(length(testVals)^2,1);

for testIndex = 1:length(testVals)^2
    % Comment out whichever parameter is being modified here in BaseSetup
    Ps = PsVals(testIndex);
    Pw = PwVals(testIndex);

    BaseSetup;

    x = calculateXvals(points, P0, P1, pc0, pc1, N0, knownFade, -Ps-Pw-xSearchOffset, Ps+Pw+xSearchOffset, numXVals);
    
    if isempty(x)
        errorVals(testIndex) = min(P0,P1);
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
    
    errorVals(testIndex) = P0*e0 + P1*e1;
end

% Error heat map P1 P2
figure
hold on
levels = 100;
fontSize = 12;
lineSize = 1;

errorMatrix = reshape(errorVals, length(testVals), length(testVals));
set(gca,'ColorScale','log')
contourf(testVals, testVals, errorMatrix, levels, 'LineColor', 'none','HandleVisibility','off')
cBar = colorbar;
cBar.TickLabelInterpreter = 'latex';
cBar.Ticks = [0.02, 0.03, 0.05, 0.1, 0.2, 0.3];
cBar.TickLabels = {'$$2\times10^{-2}$$', '$$3\times10^{-2}$$', '$$5\times10^{-2}$$', '$$10^{-1}$$', '$$2\times10^{-1}$$', '$$3\times10^{-1}$$'};
title(cBar, '$$P_e(P_1,P_2)$$', 'Interpreter', 'latex','FontSize',fontSize)

PsTildeVals = (N0*P0*P1./(2*testVals))*log(((1-Ew-Es)^2-PRatio2*(1-Ew)*(1-Es)*Ew*Es)/((Es-Ew)^2-PRatio2*(1-Ew)*(1-Es)*Ew*Es));
plot(testVals, PsTildeVals, 'r', 'LineWidth', lineSize)
legend('$$\tilde{P}_2(P_1)$$', 'Interpreter', 'latex','FontSize',fontSize)
xlim([0 3])
ylim([0 3])
xlabel('$$P_1$$', 'Interpreter', 'latex','FontSize',fontSize) 
ylabel('$$P_2$$', 'Interpreter', 'latex','FontSize',fontSize) 
