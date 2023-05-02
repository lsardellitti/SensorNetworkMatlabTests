thetaVals = linspace(0,1,100);
errorVals = zeros(1, length(thetaVals));
thetaDR = 0.1;

for thetaIndex = 1:length(thetaVals)
    theta = thetaVals(thetaIndex);
    BaseSetup;
        
    a00pdf = @(a,b) mvnpdf([a.',b.'], a00, eye(2)*(N0/2)).';
    a01pdf = @(a,b) mvnpdf([a.',b.'], a01, eye(2)*(N0/2)).';
    a10pdf = @(a,b) mvnpdf([a.',b.'], a10, eye(2)*(N0/2)).';
    a11pdf = @(a,b) mvnpdf([a.',b.'], a11, eye(2)*(N0/2)).';
    
    % testing constant decision regions
%     theta =  thetaDR;
%     BaseSetup;
    
    ybound = @(a) (N0/(2*Ps*sin(theta)))*(atanh(tanh(2*a*Pw/N0)*(K0+K1)/(K0-K1)) - 2*a*Ps*cos(theta)/N0);
    xBound = abs((N0/(2*Pw))*atanh((K0-K1)/(K0+K1)));
    
    if K0 < K1
        lowerYBound = -inf;
        upperYBound = ybound;
    else
        lowerYBound = ybound;
        upperYBound = inf; 
    end
    
    % testing constant decision regions, put back to normal
%     theta = thetaVals(thetaIndex);
%     BaseSetup;
    
    e00 = integral2(a00pdf,-xBound,xBound,lowerYBound,upperYBound) + (1 - normcdf((a00(1) + xBound)/sqrt(N0/2)));
    e01 = integral2(a01pdf,-xBound,xBound,lowerYBound,upperYBound) + (1 - normcdf((a01(1) + xBound)/sqrt(N0/2)));
    e10 = integral2(a10pdf,-xBound,xBound,lowerYBound,upperYBound) + (1 - normcdf((a10(1) + xBound)/sqrt(N0/2)));
    e11 = integral2(a11pdf,-xBound,xBound,lowerYBound,upperYBound) + (1 - normcdf((a11(1) + xBound)/sqrt(N0/2)));
    
    errorVals(thetaIndex) = p11g1*e11 + p10g1*e10 + p01g1*e01 + p00g1*e00;
end

figure
plot(thetaVals, errorVals);
