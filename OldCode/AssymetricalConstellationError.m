% Comment out Aw or As in BaseSetup
aVals = linspace(0,sqrt(2)-0.01,100);
errorProbs = zeros(1,length(aVals));

for aIndex = 1:length(aVals)
    % Change this to test different params
    As = aVals(aIndex);
    BaseSetup;
    
    errorProbs(aIndex) = errorStar;
end

figure
plot(aVals,errorProbs)