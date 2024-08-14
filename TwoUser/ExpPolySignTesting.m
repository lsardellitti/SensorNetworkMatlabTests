setupValsOverride = true; %#ok<NASGU>
theta = 0;
N0 = 1;
Ps = 2;

gridDensity = 150;
pointSize = 2;
x = linspace(0,3,gridDensity);
y = linspace(0,6,gridDensity);
X = zeros(gridDensity^2,1);
Y = zeros(gridDensity^2,1);
values = zeros(gridDensity^2,1);

baseP = 0.5;
Pw = baseP;
BaseSetup;
baseX = calculateXvals(points, P0, P1, pc0, pc1, N0, knownFade, -Ps-Pw-xSearchOffset, Ps+Pw+xSearchOffset, numXVals);
[baseAVal, baseBVal, baseCVal, baseDVal, basePolyVal] = calculateExpPoly(P0, P1, pc0, pc1, N0, points, baseX);

% map decoding regions for source bits (0 or 1)
for i = 1:gridDensity
    Pw = x(i);
    BaseSetup;
    for j = 1:gridDensity
        [aVal, bVal, cVal, dVal, polyVal] = calculateExpPoly(P0, P1, pc0, pc1, N0, points, y(j));
        X((i-1)*gridDensity + j) = x(i);
        Y((i-1)*gridDensity + j) = y(j);
        values((i-1)*gridDensity + j) = sign(bVal-baseAVal+2*aVal);
    end
end

% plot regions
scatter(X,Y,pointSize,values,'filled');
plot(x,baseX + Aw*(x - baseP), 'r', 'LineWidth', lineSize);
% plot(x,Aw*(x+Ps), 'g', 'LineWidth', lineSize);
setupValsOverride = false;

function [aVal, bVal, cVal, dVal, polyVal] = calculateExpPoly(P0, P1, pc0, pc1, N0, points, x)
    adjFactor = exp(x^2/N0)*exp(-2*points(1)*x);
    aVal = (P1*pc1(4) - P0*pc0(4))*exp(-(x-points(4))^2/N0)*adjFactor;
    bVal = (P1*pc1(2) - P0*pc0(2))*exp(-(x-points(2))^2/N0)*adjFactor;
    cVal = (P1*pc1(3) - P0*pc0(3))*exp(-(x-points(3))^2/N0)*adjFactor;
    dVal = (P1*pc1(1) - P0*pc0(1))*exp(-(x-points(1))^2/N0)*adjFactor;
    polyVal = aVal + bVal + cVal + dVal;
end