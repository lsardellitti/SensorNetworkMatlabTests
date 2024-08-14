runningComparison = true; %#ok<NASGU>

Pmax = [1 1 1 1 1];
PInit = 0.1*ones(1,length(Pmax)-1);
Pstart = [Pmax(1) PInit];
testVals = linspace(-20,20,20);

numXVals = 5000;
xSearchOffset = 100;

errorProbs = zeros(2,length(testVals));
powerUsage = zeros(2,length(testVals));

for testIndex = 1:length(testVals)
    N0 = 1 / 10^(testVals(testIndex)/10);
    
    P = Pstart;
    IncrementalOptimalPowerApproximation;
    errorProbs(1,testIndex) = errorVals(end);
    powerUsage(1,testIndex) = sum(P.^2)/sum(Pmax.^2);
    
    options = optimoptions('fminunc','Display','off','Algorithm','quasi-newton');
    [PStar,fval,eflag,output] = fminunc(@calcError,PInit,options);
    errorProbs(2,testIndex) = fval;
    powerUsage(2,testIndex) = sum([Pmax(1) PStar].^2)/sum(Pmax.^2);
end

figure
plot(testVals, errorProbs);
ylabel('Error Probability')
xlabel('SNR (dB)')
legend({'MAC Algorithm','Gradient Descent'})

figure
plot(testVals, powerUsage);
ylabel('Power Usage Ratio')
xlabel('SNR (dB)')
legend({'MAC Algorithm','Gradient Descent'})

runningComparison = false;

function errorVal = calcError(PVars)  
    numXVals = evalin('base', 'numXVals');
    xSearchOffset = evalin('base', 'xSearchOffset');
    N0 = evalin('base', 'N0');
    P = [1 PVars];
    setupValsOverride = true; %#ok<NASGU>
    MultiUserSetup;
    x = calculateXvalsMulti(points, P0, P1, pc0, pc1, N0, points(1)-xSearchOffset, points(2^N)+xSearchOffset, numXVals);
    xErrVals = zeros(length(x), 1);
    for xIndex = 1:length(x)
        xErrVals(xIndex) = calculateErrorFromDRMulti(x(xIndex), points, P0, P1, pc0, pc1, noistdv);
    end
    errorVal = min(xErrVals);

    if isempty(x)
        errorVal = min(P0,P1);
    end
    setupValsOverride = false;
end

