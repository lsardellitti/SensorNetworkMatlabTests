% source probability
P1 = 0.3;
P0 = 1 - P1;

% crossover probabilities
Ew = 0.1;
Es = 0.15;

if exist('setupValsOverride','var') ~= 1 || setupValsOverride == false
    % noise power
    N0 = 1;
    
    % signal powers (expressed as square root of mean power)
    Pw = 1;
    Ps = 1;
end

% Noise standard deviation
noistdv = sqrt(N0/2);

% fading power, set to 0 for no fading
sigma = 0;
% if assuming knowledge of fading at receiver, set sigma to 0, and use this
% IMPORTANT: keep this at 1 otherwise
knownFade = 1;

% Case Type analysis
case1Thresh = (Ew*Es)/(1 - Ew - Es + 2*Ew*Es);
case2Thresh = (Ew - Ew*Es)/(Ew + Es - 2*Ew*Es);
if P1 <= case1Thresh
    caseType = 1;
elseif P1 <= case2Thresh
    caseType = 2;
else
    caseType = 3;
end

% constellation parmeters
Aw = sqrt(P0/P1);
As = sqrt(P0/P1);
% theta = 0; % this should be set where base setup is used
Bw = -sqrt((1 - P1*(Aw^2)) / P0);
Bs = -sqrt((1 - P1*(As^2)) / P0);

% constellation points
w0 = [Bw*Pw, 0];
w1 = [Aw*Pw, 0];
s0 = [Bs*Ps*cos(theta), Bs*Ps*sin(theta)];
s1 = [As*Ps*cos(theta), As*Ps*sin(theta)];

% note the choice of a10 and a01 is determined by w0,w1,s0,s1
a00 = w0 + s0;
a10 = w1 + s0;
a01 = w0 + s1;
a11 = w1 + s1;

points = [a00; a10; a01; a11];
centerPoint = (a00 + a11) / 2;

% conditional probabilities of constellation points
p11g0 = Ew*Es;
p10g0 = Ew*(1-Es);
p01g0 = (1-Ew)*Es;
p00g0 = (1-Ew)*(1-Es);

p11g1 = (1-Ew)*(1-Es);
p10g1 = (1-Ew)*Es;
p01g1 = Ew*(1-Es);
p00g1 = Ew*Es;

% these must be in the same order as in points array
pc0 = [p00g0; p10g0; p01g0; p11g0];
pc1 = [p00g1; p10g1; p01g1; p11g1];
pc = P0*pc0 + P1*pc1;

% MAP region constants for no fading
K1 = (1-Ew-Es)*exp(-(norm(points(4,:)-centerPoint)^2)/N0);
K0 = (Es-Ew)*exp(-(norm(points(2,:)-centerPoint)^2)/N0);
K = (K0-K1)/(K0+K1);

% Optimal Error Calculations
PwEquiv = knownFade * Pw * (Aw + abs(Bw)) / 2;
PsEquiv = knownFade * Ps * (As + abs(Bs)) / 2;
cosThetaStar = (N0/(4*PwEquiv*PsEquiv))*log((1-Ew-Es)/(Es-Ew)); 
PsStar = (N0/(4*PwEquiv))*log((1-Ew-Es)/(Es-Ew));
thetaStar = 0;
if 0 <= cosThetaStar && cosThetaStar <= 1
    thetaStar = acos(cosThetaStar);
end
errorStar = Ew + (1-Ew-Es)*(1 - normcdf((PwEquiv + PsEquiv*min(cosThetaStar,1))/sqrt(N0/2))) + ...
            (Es-Ew)*(1 - normcdf((PwEquiv-PsEquiv*min(cosThetaStar,1))/sqrt(N0/2)));
errorPlanar = Ew + (1-Ew-Es)*(1 - normcdf((PwEquiv + PsEquiv)/sqrt(N0/2))) + ...
            (Es-Ew)*(1 - normcdf((PwEquiv-PsEquiv)/sqrt(N0/2)));
        
PeW = Ew*normcdf(PwEquiv*sqrt(2/N0)) + (1-Ew)*(1-normcdf(PwEquiv*sqrt(2/N0)));
PeS = Es*normcdf(PsEquiv*sqrt(2/N0)) + (1-Es)*(1-normcdf(PsEquiv*sqrt(2/N0)));

PRatio = P0/P1;
PRatio2 = ((P0-P1)^2)/(P0*P1);

EFactorMinus = (P0-P1)/P1;
EFactorPlus = (P0-P1)/P0;

APsMinusXStar = (N0*sqrt(P0*P1)/(2*Pw))*log((1-Ew-Es-EFactorMinus*Ew*Es)/(PRatio*Es-Ew-EFactorMinus*Ew*Es)) - ((P0-P1)/(2*sqrt(P0*P1)))*Pw;
BPsPlusXStar = (N0*sqrt(P0*P1)/(2*Pw))*log((1-Ew-Es+EFactorPlus*Ew*Es)/((1/PRatio)*Es-Ew+EFactorPlus*Ew*Es)) + ((P0-P1)/(2*sqrt(P0*P1)))*Pw;

aBar = P1*p11g1 - P0*p11g0;
bBar = P1*p10g1 - P0*p10g0;
cBar = P1*p01g1 - P0*p01g0;
dBar = P1*p00g1 - P0*p00g0;
APwMinusXStar = (N0*sqrt(P0*P1)/(2*Ps))*log(aBar/-bBar) - ((P0-P1)/(2*sqrt(P0*P1)))*Ps;

PsTilde = (N0*P0*P1/(2*Pw))*log(((1-Ew-Es)^2-PRatio2*(1-Ew)*(1-Es)*Ew*Es)/((Es-Ew)^2-PRatio2*(1-Ew)*(1-Es)*Ew*Es));