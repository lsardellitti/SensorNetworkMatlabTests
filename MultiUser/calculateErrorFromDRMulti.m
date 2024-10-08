function errorVal = calculateErrorFromDRMulti(x, points, P0, P1, pc0, pc1, noistdv, partialVals)
    pg1 = zeros(length(points),1);
    parity = 1;
    
    if ~exist('partialVals', 'var')
        partialVals = ones(length(points),1);
    end
    
    if isempty(x)
        errorVal = min(P0,P1);
        return
    else 
        for i = 1:length(x)
            for p = 1:length(points)
                pg1(p) = pg1(p) + parity*normcdf((points(p) - x(i))/noistdv);
            end
            parity = -parity;
        end
    end
    
    pg0 = 1 - pg1;

    e0 = sum(pc0.*pg1.*partialVals);
    e1 = sum(pc1.*pg0.*partialVals);
    
    errorVal = P0*e0 + P1*e1;
end