dataDir = 'ErrorVarySNRMultiRuns';

% signal powers (expressed as square root of mean power)
Pw = sqrt(1);
Ps = sqrt(2);
Ew = 0.01;
Es = 0.02;

% placeholder for setup file
theta = 0;

dataFolder = strcat(dataDir,sprintf('/Pw%0.2fPs%0.2fEw%0.2fEs%0.2f/',Pw^2,Ps^2,Ew,Es));
if not(isfolder(dataFolder))
    error("Data not found")
end

fileNames = dir(strcat(dataFolder,"*.mat"));

noiseVals = zeros(1,length(fileNames));
expErrorVals = zeros(1,length(fileNames));
expErrorConfInt = zeros(1,length(fileNames));
expThetaVals = zeros(1,length(fileNames));
expThetaConfInt = zeros(1,length(fileNames));
theoErrorVals = zeros(1,length(fileNames));
theoThetaVals = zeros(1,length(fileNames));

% might want to make this more dependent on the proper t-test
% ZInterval = tinv([0.05  0.95],30)
ZInterval = 1.96; 
smoothWindow = 5;

for fileIndex = 1:length(fileNames)
    data = load(strcat(dataFolder,fileNames(fileIndex).name));

    totalErrorProbs = data.totalErrorProbs;
    totalErrorProbs = movmean(totalErrorProbs,smoothWindow,2);
    
    % min then mean (performs worse, but possible to find stdv)
    [minErrorProbs, minThetaIndices] = min(totalErrorProbs,[],2);
    errorMin = mean(minErrorProbs);
    minThetaVals = data.thetaVals(minThetaIndices);
    thetaMin = mean(minThetaVals);
    expErrorVals(fileIndex) = errorMin;
    expErrorConfInt(fileIndex) = ZInterval*std(minErrorProbs)/sqrt(length(minErrorProbs));
    expThetaVals(fileIndex) = thetaMin;
    expThetaConfInt(fileIndex) = ZInterval*std(minThetaVals)/sqrt(length(minThetaVals));
    
    % mean then min (this one performs better, but no reasonable way to
    % analyze stdv of theta vals
%     avgErrorProbs = mean(totalErrorProbs, 1);
    avgErrorProbs = mean(data.totalErrorProbs, 1);
    avgErrorProbs = movmean(avgErrorProbs, smoothWindow);
    [errorMin, errorMinIndex] = min(avgErrorProbs);
    errorProbsAtMin = totalErrorProbs(:,errorMinIndex);
    expErrorVals(fileIndex) = errorMin;
    expErrorConfInt(fileIndex) = ZInterval*std(errorProbsAtMin)/sqrt(length(errorProbsAtMin));
    expThetaVals(fileIndex) = data.thetaVals(errorMinIndex);

    
    noiseVals(fileIndex) = str2double(fileNames(fileIndex).name(3:11)); % this is hard coded from number of decimal percision
    N0 = noiseVals(fileIndex);
    ConstellationSetup;
    theoErrorVals(fileIndex) = errorStar;
    theoThetaVals(fileIndex) = thetaStar;
end

% convert noise vals to SNR, and do log scale (db snr)
SNRVals = 10*log10(Pw*Ps./noiseVals);

% figure
% hold on
% plot(SNRVals,expThetaVals)
% errorbar(SNRVals, expThetaVals, expThetaConfInt)
% plot(SNRVals,theoThetaVals)

figure
hold on
plot(SNRVals, expErrorVals, "blue")
errorbar(SNRVals, expErrorVals, expErrorConfInt, ".b", 'CapSize', 0, 'LineWidth', 3)
plot(SNRVals, theoErrorVals, "red")
set(gca, 'YScale', 'log')

% To change line width of a plot
% p = gcf;
% p.Children(2).Children(2).LineWidth = 1;
% p.Children(2).Children(5).LineWidth = 1;


% figure
% plot(SNRVals,expErrorVals-theoErrorVals)
% set(gca, 'YScale', 'log')
