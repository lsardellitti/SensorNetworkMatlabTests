function [xMin, PMin, errorVal] = calculateOptimalPVal(P, PMax, N0, xSearchOffset, numVals, PVar)
    P(PVar) = 0;
    MultiUserSetup;
    
    repVec0 = [ones(2^(N-PVar),1); zeros(2^(N-PVar),1)];
    repVec1 = [zeros(2^(N-PVar),1); ones(2^(N-PVar),1)];
    repMat0 = repmat(repVec0, 2^(PVar-1), 1);
    repMat1 = repmat(repVec1, 2^(PVar-1), 1);
    
    xSearchMin = points(1)-xSearchOffset;
    xSearchMax = points(2^N)+xSearchOffset;
    xVals0 = calculateXvalsMulti(points, P0, P1, pc0, pc1, N0, xSearchMin, xSearchMax, numVals, repMat0);
    xVals1 = calculateXvalsMulti(points, P0, P1, pc0, pc1, N0, xSearchMin, xSearchMax, numVals, repMat1);
    
    t0Vals = zeros(length(xVals0), 1);
    t1Vals = zeros(length(xVals1), 1);
    
    for xIndex = 1:length(xVals0)
        xTest = xVals0(xIndex);
        t0Vals(xIndex) = calculateErrorFromDRMulti(xTest, points, P0, P1, pc0, pc1, noistdv, repMat0);
    end
    
    for xIndex = 1:length(xVals1)
        xTest = xVals1(xIndex);
        t1Vals(xIndex) = calculateErrorFromDRMulti(xTest, points, P0, P1, pc0, pc1, noistdv, repMat1);
    end
    
    [t0Min, x0minIndex] = min(t0Vals);
    [t1Min, x1minIndex] = min(t1Vals);
    x0Min = xVals0(x0minIndex);
    x1Min = xVals1(x1minIndex);
    
    xMin = [x0Min, x1Min];
    PMin = (x1Min - x0Min)/(A(1) - A(2));
    errorVal = t0Min + t1Min;
    
    if PMin > PMax
        PMin = PMax;
        P(PVar) = PMin; %#ok<NASGU>
        MultiUserSetup;
    
        x = calculateXvalsMulti(points, P0, P1, pc0, pc1, N0, xSearchMin, xSearchMax, numVals);

        % One Decision Boundary
        xErrVals = zeros(length(x), 1);
        for xIndex = 1:length(x)
            xErrVals(xIndex) = calculateErrorFromDRMulti(x(xIndex), points, P0, P1, pc0, pc1, noistdv);
        end
        errorVal = min(xErrVals);

        if isempty(x)
            errorVal = min(P0,P1);
        end
        
        for xIndex0 = 1:length(xVals0)
            for xIndex1 = 1:length(xVals1)
                PVal = (xVals1(xIndex1) - xVals0(xIndex0))/(A(1) - A(2));
                if PVal < PMax && PVal > 0 && t0Vals(xIndex0) + t1Vals(xIndex1) < errorVal
                    PMin = PVal;
                    errorVal = t0Vals(xIndex0) + t1Vals(xIndex1);
                end
            end
        end
    end
end