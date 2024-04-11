function [xMin, PMin, errorVal] = calculateOptimalPVal(P, N0, xSearchOffset, numVals, PVar)
    setupValsOverride = true; %#ok<NASGU>
    P(PVar) = 0; %#ok<NASGU>
    MultiUserSetup;
    
    repVec0 = [ones(2^(N-PVar),1); zeros(2^(N-PVar),1)];
    repVec1 = [zeros(2^(N-PVar),1); ones(2^(N-PVar),1)];
    repMat0 = repmat(repVec0, 2^(PVar-1), 1);
    repMat1 = repmat(repVec1, 2^(PVar-1), 1);
    
    xMin = points(1)-xSearchOffset;
    xMax = points(2^N)+xSearchOffset;
    xVals0 = calculateXvalsMulti(points, P0, P1, pc0, pc1, N0, xMin, xMax, numVals, repMat0);
    xVals1 = calculateXvalsMulti(points, P0, P1, pc0, pc1, N0, xMin, xMax, numVals, repMat1);
    
    % Check for zero length
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
    
    setupValsOverride = false; %#ok<NASGU>
end