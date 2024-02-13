setupValsOverride = true; %#ok<NASGU>
N0 = 1;
P = [1, 1, 1];
MultiUserSetup;
PRel = 1;

dataDir = 'GridSearchData';
fileName = sprintf('/N0-%0.2fP1-%0.2f',N0, P1);
for i = 1:N
    fileName = strcat(fileName, sprintf('E%d-%0.2f',i, E(i)));
end
fileName = strcat(fileName, '.mat');

if ~isfile(strcat(dataDir,fileName))
    error("No Data Found");
end

prevData = load(strcat(dataDir,fileName));
errorVals = prevData.errorVals;
PVals = prevData.PVals;

indArr = 1:N;
indArr(PRel) = [];
permuteArr = [PRel indArr];
[minError, minIndex] = min(errorVals, [], indArr, 'linear');

figure
plot(permute(PVals{PRel}(minIndex), permuteArr), permute(minError, permuteArr))
xlabel(sprintf('P%d',PRel))
ylabel('error')

for i = indArr
    figure
    plot(permute(PVals{PRel}(minIndex), permuteArr), permute(PVals{i}(minIndex), permuteArr))
    xlabel(sprintf('P%d',PRel))
    ylabel(sprintf('P%d',i))
end

setupValsOverride = false;