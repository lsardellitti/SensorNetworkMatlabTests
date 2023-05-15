numVals = 100;
a11PartialVals = zeros(1, numVals);
a01PartialVals = zeros(1, numVals);

partA = zeros(1, numVals);
partB = zeros(1, numVals);

theta = 1;
BaseSetup;

xBound = abs((N0/(2*Pw))*atanh((K0-K1)/(K0+K1)));
xVals = linspace(-xBound+0.01, xBound-0.01, numVals);

a01pdf = @(a,b) mvnpdf([a.',b.'], a01, eye(2)*(N0/2)).';
a11pdf = @(a,b) mvnpdf([a.',b.'], a11, eye(2)*(N0/2)).';
    
a01Integrand = @(a,b) (2/N0)*(-Ps*sin(theta)*(a+Pw-Ps*cos(theta))+Ps*cos(theta)*(b-Ps*sin(theta))).*a01pdf(a,b);
a11Integrand = @(a,b) (2/N0)*(-Ps*sin(theta)*(a-Pw-Ps*cos(theta))+Ps*cos(theta)*(b-Ps*sin(theta))).*a11pdf(a,b);

partAIntegrand = @(a,b) (2/N0)*(-Ps*sin(theta)*(a-Pw-Ps*cos(theta))).*a11pdf(a,b);
partBIntegrand = @(a,b) (2/N0)*(Ps*cos(theta)*(b-Ps*sin(theta))).*a11pdf(a,b);

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
    
    partACurIntegrand = @(a) partAIntegrand(xVals(valIndex)*ones(1,length(a)), a); 
    partBCurIntegrand = @(a) partBIntegrand(xVals(valIndex)*ones(1,length(a)), a); 
    
    a01Integral = integral(a01CurIntegrand,lowerYBound,upperYBound);
    a11Integral = integral(a11CurIntegrand,lowerYBound,upperYBound);
    
    partAIntegral = integral(partACurIntegrand,lowerYBound,upperYBound);
    partBIntegral = integral(partBCurIntegrand,lowerYBound,upperYBound);
    
    a01PartialVals(valIndex) = a01Integral;
    a11PartialVals(valIndex) = a11Integral;
    
    partA(valIndex) = partAIntegral;
    partB(valIndex) = partBIntegral;
end

figure
hold on
plot(xVals, partA);
plot(xVals, partB);
plot(xVals, partA+partB);
plot(xVals, a11PartialVals);
