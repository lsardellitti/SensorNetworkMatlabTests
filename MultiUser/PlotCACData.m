P1 = 0.4;
E = [0.1 0.1 0.2 0.2 0.2 0.2 0.3 0.3];
Pmax = [1 1 5 5 5 5 5 5];

fileNames = dir(strcat("CACData/","*.mat"));
for fileIndex = 1:length(fileNames)
load(strcat("CACData/",fileNames(fileIndex).name));


% fileName = sprintf('CACData/ErrCompP%0.2fE%sPMax%s.mat',P1,join(string(E)),join(string(Pmax)));
% load(fileName);

figure
hold on

plot(testVals, orthoError)
plot(testVals, maxMacError)
plot(testVals, maxMacMapError)
plot(testVals, pairwiseError)
plot(testVals, pairwiseMapError)
plot(testVals, algoError)
plot(testVals, algoMaxError)
set(gca, 'YScale', 'log')
ylabel('Error Probability')
xlabel('SNR (dB)')
legend({'Ortho','MAC full','MAC full MAP','Pairwise MAC','Pairwise MAC MAP','MAC algo','MAC algo max'})

figure
plot(testVals, powerUsage);
ylabel('Power Usage Ratio')
xlabel('SNR (dB)')
legend({'MAC algo','MAC algo max'})

end