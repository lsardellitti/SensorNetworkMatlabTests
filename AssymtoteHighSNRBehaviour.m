% signal powers (expressed as square root of mean power)
Pw = sqrt(2);
Ps = sqrt(1);
theta = 1;

% crossover probabilities
Ew = 0.01;
Es = 0.02;

% constellation points
w0 = [-Pw, 0];
w1 = [Pw, 0];
s0 = [-Ps*cos(theta), -Ps*sin(theta)];
s1 = [Ps*cos(theta), Ps*sin(theta)];

% note the choice of a10 and a01 is determined by w0,w1,s0,s1
a00 = w0 + s0;
a10 = w1 + s0;
a01 = w0 + s1;
a11 = w1 + s1;

points = [a00; a10; a01; a11];

nVals = linspace(0.0001,0.1,10);
xVals = zeros(1,length(nVals));

oldDigs = digits(100000);

for nIndex = 1:length(nVals)
    N0 = nVals(nIndex);

    K1 = (1-Ew-Es)*exp(-vpa((norm(points(4,:))^2)/N0));
    K0 = (Es-Ew)*exp(-vpa((norm(points(2,:))^2)/N0));
    
    xVals(nIndex) = abs((N0/(2*Pw))*atanh((K0-K1)/(K0+K1)));
end

digits(oldDigs);

figure
plot(nVals,xVals)
