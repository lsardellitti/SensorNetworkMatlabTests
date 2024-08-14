numVals = 100;
a11PartialVals = zeros(1, numVals);
a01PartialVals = zeros(1, numVals);

partA11 = zeros(1, numVals);
partB11 = zeros(1, numVals);
partA01 = zeros(1, numVals);
partB01 = zeros(1, numVals);

theta = 1;
BaseSetup;

xBound = abs((N0/(2*Pw))*atanh((K0-K1)/(K0+K1)));
xVals = linspace(-xBound+0.01, xBound-0.01, numVals);

a01pdf = @(a,b) mvnpdf([a.',b.'], a01, eye(2)*(N0/2)).';
a11pdf = @(a,b) mvnpdf([a.',b.'], a11, eye(2)*(N0/2)).';
    
a01Integrand = @(a,b) (2/N0)*(-Ps*sin(theta)*(a+Pw-Ps*cos(theta))+Ps*cos(theta)*(b-Ps*sin(theta))).*a01pdf(a,b);
a11Integrand = @(a,b) (2/N0)*(-Ps*sin(theta)*(a-Pw-Ps*cos(theta))+Ps*cos(theta)*(b-Ps*sin(theta))).*a11pdf(a,b);

partA11Integrand = @(a,b) (2/N0)*(-Ps*sin(theta)*(a-Pw-Ps*cos(theta))).*a11pdf(a,b);
partB11Integrand = @(a,b) (2/N0)*(Ps*cos(theta)*(b-Ps*sin(theta))).*a11pdf(a,b);
partA01Integrand = @(a,b) (2/N0)*(-Ps*sin(theta)*(a+Pw-Ps*cos(theta))).*a01pdf(a,b);
partB01Integrand = @(a,b) (2/N0)*(Ps*cos(theta)*(b-Ps*sin(theta))).*a01pdf(a,b);

for valIndex = 1:numVals
    ybound = (N0/(2*Ps*sin(theta)))*(atanh(tanh(2*xVals(valIndex)*Pw/N0)*(K0+K1)/(K0-K1)) - 2*xVals(valIndex)*Ps*cos(theta)/N0);
    
    if K0 < K1
        lowerYBound = -inf;
        upperYBound = ybound;
    else
        lowerYBound = ybound;
        upperYBound = inf; 
    end
    
    a01CurIntegrand = @(a) a01Integrand(xVals(valIndex)*ones(1,length(a)), a); 
    a11CurIntegrand = @(a) a11Integrand(xVals(valIndex)*ones(1,length(a)), a); 
    
    partA11CurIntegrand = @(a) partA11Integrand(xVals(valIndex)*ones(1,length(a)), a); 
    partB11CurIntegrand = @(a) partB11Integrand(xVals(valIndex)*ones(1,length(a)), a); 
    partA01CurIntegrand = @(a) partA01Integrand(xVals(valIndex)*ones(1,length(a)), a); 
    partB01CurIntegrand = @(a) partB01Integrand(xVals(valIndex)*ones(1,length(a)), a); 
    
    a01Integral = integral(a01CurIntegrand,lowerYBound,upperYBound);
    a11Integral = integral(a11CurIntegrand,lowerYBound,upperYBound);
    
    partA11Integral = integral(partA11CurIntegrand,lowerYBound,upperYBound);
    partB11Integral = integral(partB11CurIntegrand,lowerYBound,upperYBound);
    partA01Integral = integral(partA01CurIntegrand,lowerYBound,upperYBound);
    partB01Integral = integral(partB01CurIntegrand,lowerYBound,upperYBound);
    
    a01PartialVals(valIndex) = a01Integral;
    a11PartialVals(valIndex) = a11Integral;
    
    partA11(valIndex) = partA11Integral;
    partB11(valIndex) = partB11Integral;
    partA01(valIndex) = partA01Integral;
    partB01(valIndex) = partB01Integral;
end

figure
hold on
plot(xVals, (1-Ew-Es)*partA11-(Es-Ew)*partA01);
plot(xVals, (1-Ew-Es)*partB11-(Es-Ew)*partB01);
% plot(xVals, partA11+partB11);
plot(xVals, (1-Ew-Es)*a11PartialVals-(Es-Ew)*a01PartialVals);

figure
hold on
plot(xVals, (1-Ew-Es)*partB11);
plot(xVals, (Es-Ew)*partB01);
% plot(xVals, partA01+partB01);
% plot(xVals, a01PartialVals);

