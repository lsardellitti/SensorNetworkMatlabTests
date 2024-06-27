setupValsOverride = true; %#ok<NASGU>

if ~exist('runningComparison','var') == 1 || runningComparison == false
    Pmax = [1 2 2 2];
    P = Pmax;
    testVals = linspace(0,4,50);
    useMAP = false;
end

numXVals = 5000;
xSearchOffset = 50;

errorVals = zeros(length(testVals),1);

PRatio = P0/P1;
PRatio2 = ((P0-P1)^2)/(P0*P1);

for testIndex = 1:length(testVals)
    N0 = prod(Pmax)^(2/n) / 10^(testVals(testIndex)/10);
    
    P(1) = Pmax(1);
    for i = 2:length(P)
        P(i) = (N0*P0*P1/(2*P(1)))*log(((1-E(1)-E(i))^2-PRatio2*(1-E(1))*(1-E(i))*E(1)*E(i))/((E(i)-E(1))^2-PRatio2*(1-E(1))*(1-E(i))*E(1)*E(i)));
        if ~isreal(P(i)) || P(i) > Pmax(i)
            P(i) = Pmax(i);
        end
    end
    
%     P = zeros(length(Pmax),1);
%     for i = 1:length(P)
%         for j = 2:length(P)
%             P(i) = P(i) + Pmax(i);
%             Ptilde = (N0*P0*P1/(2*P(i)))*log(((1-E(i)-E(j))^2-PRatio2*(1-E(i))*(1-E(j))*E(i)*E(j))/((E(j)-E(i))^2-PRatio2*(1-E(i))*(1-E(j))*E(i)*E(j)));
%             if ~isreal(Ptilde) || Ptilde > Pmax(j)
%                 Ptilde = Pmax(j);
%             end
%             P(j) = P(j) + Ptilde;
%         end
%     end
%     P = P/(N-1);
    
    MultiUserSetup;

    x = calculateXvalsMulti(points, P0, P1, pc0, pc1, N0, points(1)-xSearchOffset, points(2^N)+xSearchOffset, numXVals);
    
    if ~useMAP
        xErrVals = zeros(length(x), 1);
        for xIndex = 1:length(x)
            xErrVals(xIndex) = calculateErrorFromDRMulti(x(xIndex), points, P0, P1, pc0, pc1, noistdv);
        end
        errorVal = min(xErrVals);

        if isempty(x)
            errorVal = min(P0,P1);
        end
    else
        errorVal = calculateErrorFromDRMulti(x, points, P0, P1, pc0, pc1, noistdv);
    end

    errorVals(testIndex) = errorVal;

end

setupValsOverride = false;