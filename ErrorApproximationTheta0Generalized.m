theta = 0;
numXVals = 1000;
xSearchOffset = 5;

% Values range to test over
testVals = linspace(0.001,2.5,1000);

errorVals = zeros(length(testVals),1);
lowerBoundVals = zeros(length(testVals),1);

for testIndex = 1:length(testVals)
    % Comment out whichever parameter is being modified here in BaseSetup
    Ps = testVals(testIndex);

    BaseSetup;

    x = calculateXvals(points, P0, P1, pc0, pc1, N0, knownFade, -Ps-Pw-xSearchOffset, Ps+Pw+xSearchOffset, numXVals);
    
    if isempty(x)
        errorVals(testIndex) = min(P0,P1);
        lowerBoundVals(testIndex) = min(P0,P1);
        continue
    elseif length(x) == 1
        p1g11 = normcdf((a11(1) - x(1))/noistdv);
        p1g01 = normcdf((a01(1) - x(1))/noistdv);
        p1g10 = normcdf((a10(1) - x(1))/noistdv);
        p1g00 = normcdf((a00(1) - x(1))/noistdv);
        
        LBp1g11 = p1g11;
        LBp1g01 = p1g01;
        LBp1g10 = p1g10;
        LBp1g00 = p1g00;
    elseif length(x) == 3
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
    
    errorVals(testIndex) = P0*e0 + P1*e1;
    lowerBoundVals(testIndex) = P0*LBe0 + P1*LBe1;
end

figure
hold on
plot(testVals, errorVals)
plot(testVals, lowerBoundVals)
xlabel('P2') 
ylabel('Error Probability')

% [~, idx] = min(errorVals);
% testVals(idx)
% xBarVals(idx)
