function [xVals] = calculateXvalsMulti(points, P0, P1, pc0, pc1, N0, xMin, xMax, numVals, partialVals)
    if ~exist('partialVals', 'var')
        partialVals = ones(length(points),1);
    end
    
    xTests = linspace(xMin,xMax,numVals);
    prevI = -1;
    xVals = [];
    for xIndex = 1:length(xTests)
        x = xTests(xIndex);
        condProbVals = exp(-((x-points).^2)/N0);
        weight0 = P0*(sum(pc0.*condProbVals.*partialVals));
        weight1 = P1*(sum(pc1.*condProbVals.*partialVals));
        
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