theta = 0;
BaseSetup;
noistdv = sqrt(N0/2);
pVals = linspace(0,5,1000);
errorVals = zeros(length(pVals),1);
xBarVals = zeros(length(pVals),1);
drType = zeros(length(pVals),1);
lowerBound = zeros(length(pVals),1);
remainderFunc = zeros(length(pVals),1);

for pIndex = 1:length(pVals)
    Ps = pVals(pIndex);
    xVals = linspace(0,Pw+Ps,1000);
    
    a11Err = (1-normcdf((xVals+Pw+Ps)/noistdv)) - (1-normcdf((Pw+Ps)/noistdv)) + (1-normcdf((Pw+Ps-xVals)/noistdv));
    a10Err = (1-normcdf((xVals+Pw-Ps)/noistdv)) - (1-normcdf((Pw-Ps)/noistdv)) + (1-normcdf((Pw-Ps-xVals)/noistdv));
    
    intermErrorVals = Ew + (1-Ew-Es)*a11Err + (Es-Ew)*a10Err;
    
    [errorVals(pIndex), xIndex] = min(intermErrorVals);
    xBarVals(pIndex) = xVals(xIndex);
    drType(pIndex) = Pw < Ps && (Ps+Pw)/(Ps-Pw) < exp(4*Ps*Pw/N0)*(Es-Ew)/(1-Es-Ew);
    
    termA1 = 1 - normcdf((Pw+Ps+xVals(xIndex))/noistdv);
    termA2 = 1 - normcdf((Pw+Ps-xVals(xIndex))/noistdv);
    termA3 = 1 - normcdf((Pw+Ps)/noistdv);
    termA4 = 1 - normcdf((Pw+PsStar)/noistdv);
    termB1 = 1 - normcdf((Pw-Ps+xVals(xIndex))/noistdv);
    termB2 = 1 - normcdf((Pw-Ps-xVals(xIndex))/noistdv);
    termB3 = 1 - normcdf((Pw-Ps)/noistdv);
    termB4 = 1 - normcdf((Pw-PsStar)/noistdv);
    lowerBound(pIndex) = Ew + (1-Ew-Es)*termA2 + (Es-Ew)*termB1;
    remainderFunc(pIndex) = (1-Ew-Es)*(termA1-termA3) + (Es-Ew)*(termB2-termB3);
%     testFuncA(pIndex) = Ew + (1-Ew-Es)*(termA2) + (Es-Ew)*(termB1);
end

figure
hold on
plot(pVals,errorVals);
% plot(pVals,lowerBound);

% figure
% plot(pVals,remainderFunc);

% figure
% hold on
% plot(pVals,xBarVals);

% Ps = 2;
% figure
% plot(xVals,Ew+(1-Ew-Es)*(1-normcdf((Pw+Ps+xVals)/noistdv))+(Es-Ew)*(1-normcdf((Pw-Ps-xVals)/noistdv)));
% figure
% plot(xVals,Ew+(1-Ew-Es)*(1-normcdf((Pw+Ps-xVals)/noistdv))+(Es-Ew)*(1-normcdf((Pw-Ps+xVals)/noistdv)));
