thetaVals = linspace(0,pi/2,50);
errorDerivVals = zeros(1, length(thetaVals));
thetaDR = 0.5;

% calculate exact error funtion for p=0.5, A=1
for thetaIndex = 1:length(thetaVals)
    theta = thetaVals(thetaIndex);
    BaseSetup;
        
    a01pdf = @(a,b) mvnpdf([a.',b.'], a01, eye(2)*(N0/2)).';
    a11pdf = @(a,b) mvnpdf([a.',b.'], a11, eye(2)*(N0/2)).';
    
    a01Integrand = @(a,b) (2/N0)*(-Ps*sin(theta)*(a+Pw-Ps*cos(theta))+Ps*cos(theta)*(b-Ps*sin(theta))).*a01pdf(a,b);
    a11Integrand = @(a,b) (2/N0)*(-Ps*sin(theta)*(a-Pw-Ps*cos(theta))+Ps*cos(theta)*(b-Ps*sin(theta))).*a11pdf(a,b);
    
    % testing constant decision regions
    theta =  thetaDR;
    BaseSetup;
    
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
    theta = thetaVals(thetaIndex);
    BaseSetup;
    
    sigma = sqrt(N0/2);
    
    a01Tail = (Ps*sin(theta)/sigma)*normpdf((a01(1) + xBound)/sigma);
    a11Tail = (Ps*sin(theta)/sigma)*normpdf((a11(1) + xBound)/sigma);
    
    e01 = integral2(a01Integrand,-xBound,xBound,lowerYBound,upperYBound) + a01Tail;
    e11 = integral2(a11Integrand,-xBound,xBound,lowerYBound,upperYBound) + a11Tail;
    
    errorDerivVals(thetaIndex) = (1-Ew-Es)*e11 - (Es-Ew)*e01;
end

figure
hold on
plot(thetaVals, errorDerivVals);
plot(thetaVals, zeros(1, length(thetaVals)))
