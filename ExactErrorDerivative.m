thetaVals = linspace(0,pi/2,50);
tailDeriv01Vals = zeros(1, length(thetaVals));
tailDeriv11Vals = zeros(1, length(thetaVals));
integralDeriv01Vals = zeros(1, length(thetaVals));
integralDeriv11Vals = zeros(1, length(thetaVals));
errorDerivVals = zeros(1, length(thetaVals));
thetaDR = 1;

for thetaIndex = 1:length(thetaVals)
    theta = thetaVals(thetaIndex);
    BaseSetup;
        
    a01pdf = @(a,b) mvnpdf([a.',b.'], a01, eye(2)*(N0/2)).';
    a11pdf = @(a,b) mvnpdf([a.',b.'], a11, eye(2)*(N0/2)).';
    
    a01Integrand = @(a,b) (2/N0)*(-Ps*sin(theta)*(a+Pw-Ps*cos(theta))+Ps*cos(theta)*(b-Ps*sin(theta))).*a01pdf(a,b);
    a11Integrand = @(a,b) (2/N0)*(-Ps*sin(theta)*(a-Pw-Ps*cos(theta))+Ps*cos(theta)*(b-Ps*sin(theta))).*a11pdf(a,b);
    
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
    
    sigma = sqrt(N0/2);
    
    a01Tail = (Ps*sin(theta)/sigma)*normpdf((a01(1) + xBound)/sigma);
    a11Tail = (Ps*sin(theta)/sigma)*normpdf((a11(1) + xBound)/sigma);
    
    a01Integral = integral2(a01Integrand,-xBound,xBound,lowerYBound,upperYBound);
    a11Integral = integral2(a11Integrand,-xBound,xBound,lowerYBound,upperYBound);
    
    e01 = a01Integral + a01Tail;
    e11 = a11Integral + a11Tail;
    
    tailDeriv01Vals(thetaIndex) = (Es-Ew)*a01Tail;
    tailDeriv11Vals(thetaIndex) = (1-Ew-Es)*a11Tail;
    integralDeriv01Vals(thetaIndex) = (Es-Ew)*a01Integral;
    integralDeriv11Vals(thetaIndex) = (1-Ew-Es)*a11Integral;
    errorDerivVals(thetaIndex) = (1-Ew-Es)*e11 - (Es-Ew)*e01;
end

figure
hold on 
plot(thetaVals, tailDeriv01Vals);
plot(thetaVals, tailDeriv11Vals);

figure
hold on 
plot(thetaVals, integralDeriv01Vals);
plot(thetaVals, integralDeriv11Vals);

figure
hold on
plot(thetaVals, errorDerivVals);
plot(thetaVals, zeros(1, length(thetaVals)))
