thetaVals = linspace(0,pi/2,1000);
errorVals = zeros(1, length(thetaVals));

for thetaIndex = 1:length(thetaVals)
    theta = thetaVals(thetaIndex);
    BaseSetup;
    if theta == 0
        if Pw/Ps > (K0-K1)/(K0+K1)
            planeX = 0;
        else 
            % This is too complicated to solve properly
            planeX = 0;
        end
    else
        planeX = abs((N0/(2*Pw))*atanh((K0-K1)/(K0+K1)));
    end
    
    errorTotal = 0;
    
    for pointIndex = 1:4
        if points(pointIndex,1) > 0
            errorVal = (1 - normcdf(points(pointIndex,1)/sqrt(N0/2)));
        else
            errorVal = (1 - normcdf((points(pointIndex,1) + planeX)/sqrt(N0/2))) + ...
                normcdf(points(pointIndex,1)) - normcdf(points(pointIndex,1) - planeX);
        end
        errorTotal = errorTotal + pc1(pointIndex)*errorVal;
    end
    errorVals(thetaIndex) = errorTotal;
end

figure
plot(thetaVals, errorVals);
