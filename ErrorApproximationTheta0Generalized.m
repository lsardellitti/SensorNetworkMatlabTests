theta = 0;
numXVals = 1000;
xSearchOffset = 10;

BaseSetup;
testVals = linspace(0,3,1000);
% testVals = linspace(0,1/sqrt(P1),1000);
errorVals = zeros(length(testVals),1);
xBarVals = zeros(length(testVals),1);
drType = zeros(length(testVals),1);

for testIndex = 1:length(testVals)
    % Comment out whichever parameter is being modified here in BaseSetup
    Ps = testVals(testIndex);
    BaseSetup;
    x = calculateXvals(points, P0, P1, pc0, pc1, N0, knownFade, -Ps-Pw-xSearchOffset, Ps+Pw+xSearchOffset, numXVals);
    
    if isempty(x)
        xBarVals(testIndex) = 0;
        errorVals(testIndex) = min(P0,P1);
        continue
    elseif length(x) == 1
        xBarVals(testIndex) = x(1);
        p1g11 = normcdf((a11(1) - x(1))/noistdv);
        p1g01 = normcdf((a01(1) - x(1))/noistdv);
        p1g10 = normcdf((a10(1) - x(1))/noistdv);
        p1g00 = normcdf((a00(1) - x(1))/noistdv);
    elseif length(x) == 3
        xBarVals(testIndex) = 3;%x(1);
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

figure
hold on
plot(testVals,xBarVals);

figure
hold on
plot(testVals,errorVals);

[~, idx] = min(errorVals);
testVals(idx)
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
