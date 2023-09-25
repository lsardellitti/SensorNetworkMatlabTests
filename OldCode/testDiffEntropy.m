theta = 0;
BaseSetup;
noistdv = N0/2;
trials = 100000;
pVals = linspace(0,5,100);
MIVals = zeros(100,1);

for pIndex = 1:length(pVals)
    Pw = pVals(pIndex);
    BaseSetup;
    
    recvRV = gmdistribution(points(:,1),noistdv,pc);
    vals = random(recvRV, trials);
    recvDE = differential_entropy(vals);

    condRecvRV = gmdistribution(points(:,1),noistdv,pc0);
    condVals = random(condRecvRV, trials);
    condDE = differential_entropy(condVals);
    
    MIVals(pIndex) = recvDE - condDE;
end

figure
plot(pVals, MIVals)
