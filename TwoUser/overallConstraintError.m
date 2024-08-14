theta = 0;
BaseSetup;
Pmax = 4;
noistdv = sqrt(N0/2);
numVals = 1000;
P1Vals = linspace(0,sqrt(Pmax)-0.0001,numVals);
P2Vals = min((N0./(4*P1Vals))*log((1-Ew-Es)/(Es-Ew)),sqrt(Pmax-P1Vals.^2));
errorVals = zeros(numVals,1);
for pIndex = 1:length(P1Vals)
    P1 = P1Vals(pIndex);
    P2 = P2Vals(pIndex);
    errorVals(pIndex) = Ew+(1-Ew-Es)*(1-normcdf((P1+P2)/noistdv))+(Es-Ew)*(1-normcdf((P1-P2)/noistdv));
end

figure
plot(P1Vals,errorVals)