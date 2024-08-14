compareN = false;

if compareN
   dirName = 'CACData/ErrN';
else
   dirName = 'CACData\ErrCompP0.35E0.05 0.1 0.15 0.2 0.2PMax1 3';
end

fileNames = dir(strcat(dirName,"*.mat"));
for fileIndex = 1:length(fileNames)
load(strcat("CACData/",fileNames(fileIndex).name));

% figure
% hold on

if compareN
    plot(NVals, orthoError)
    plot(NVals, maxMacError)
    plot(NVals, pairwiseError)
    plot(NVals, algoError)
    set(gca, 'YScale', 'log')
    ylabel('Error Probability')
    xlabel('Number of Sensors')
    legend({'Orthogonal Signaling','MAC Full Power','Pairwise MAC','MAC Algorithm'})
else
%     plot(testVals, orthoError)
    plot(testVals, maxMacError)
    plot(testVals, maxMacMapError)
%     plot(testVals, pairwiseError)
%     plot(testVals, pairwiseMapError)
    plot(testVals, algoError)
%     plot(testVals, algoMaxError)
    set(gca, 'YScale', 'log')
    ylabel('Error Probability')
    xlabel('SNR (dB)')
    legend({'Orthogonal Signaling','MAC Full Power','Pairwise MAC','MAC Algorithm'})

    figure
    plot(testVals, powerUsage);
    ylabel('Power Usage Ratio')
    xlabel('SNR (dB)')
    legend({'MAC Algorithm','MAC Algorithm Full Start'})
end
end