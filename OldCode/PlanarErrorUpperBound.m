thetaVals = linspace(0,pi/2,100);
errorVals = zeros(1, length(thetaVals));

for thetaIndex = 1:length(thetaVals)
    theta = thetaVals(thetaIndex);
    BaseSetup;
    errorVals(thetaIndex) = Ew + (1-Ew-Es)*(1 - normcdf((Pw + Ps*cos(theta))/sqrt(N0/2))) + ...
            (Es-Ew)*(1 - normcdf((Pw-Ps*cos(theta))/sqrt(N0/2)));
        
%     errorVals(thetaIndex) = (1-Ew)*(1-Es)*(1 - normcdf(a11(1)/sqrt(N0/2))) + ...
%         (1-Ew)*Es*(1 - normcdf(a10(1)/sqrt(N0/2))) + ...
%         Ew*(1-Es)*(normcdf(a10(1)/sqrt(N0/2))) + ...
%         Ew*Es*(normcdf(a11(1)/sqrt(N0/2)));
end

figure
plot(thetaVals, errorVals);
