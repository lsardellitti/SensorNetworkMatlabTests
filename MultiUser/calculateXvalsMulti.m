function [xVals] = calculateXvalsMulti(points, P0, P1, pc0, pc1, N0, xMin, xMax, numVals)
    xTests = linspace(xMin,xMax,numVals);
    prevI = -1;
    xVals = [];
    for xIndex = 1:length(xTests)
        x = xTests(xIndex);
        condProbVals = zeros(length(points),1);
        for k = 1:length(points)
           distance = (x - points(k))^2;
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