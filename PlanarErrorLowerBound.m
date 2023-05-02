thetaVals = linspace(0,pi/2,100);
errorVals = zeros(1, length(thetaVals));

for thetaIndex = 1:length(thetaVals)
    theta = thetaVals(thetaIndex);
    BaseSetup;
    if theta == 0
        if Pw/Ps > (K0-K1)/(K0+K1)
            planeX = 0;
        else 
            % This is too complicated to solve properly
            fprintf('not good 0\n')
            planeX = 0;
        end
    else
        planeX = abs((N0/(2*Pw))*atanh((K0-K1)/(K0+K1)));
    end
    errorVals(thetaIndex) = (1-Ew)*(1-Es)*(1 - normcdf((a11(1) + planeX)/sqrt(N0/2))) + ...
        (1-Ew)*Es*(1 - normcdf((a10(1) + planeX)/sqrt(N0/2))) + ...
        Ew*(1-Es)*(1 - normcdf((a01(1) + planeX)/sqrt(N0/2))) + ...
        Ew*Es*(1 - normcdf((a00(1) + planeX)/sqrt(N0/2)));
end

% figure
plot(thetaVals, errorVals);
