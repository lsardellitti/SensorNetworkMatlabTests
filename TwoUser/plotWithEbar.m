figure
hold on

p = plot(SNRVals, expErr1,"blue");
% p.LineStyle = '--'
pe = errorbar(SNRVals, expErr1, expErrBar1, ".b", 'CapSize', 0, 'LineWidth', 1);
q = plot(SNRVals, theoErr1, "red");
q.LineStyle = '--';

plot(SNRVals, expErr2, "blue");
errorbar(SNRVals, expErr2, expErrBar2, ".b", 'CapSize', 0, 'LineWidth', 1);
r = plot(SNRVals, theoErr2, "red");
r.LineStyle = '--';

legend([p(1),pe(1),q(1)],'Experimental', 'Confidence Interval','Upper Bound')
set(gca, 'YScale', 'log')
ylim([0.009,0.25])