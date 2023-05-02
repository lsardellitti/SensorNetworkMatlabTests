%Run this after setting the Problem Parameters
% source probability
P1 = 0.5;
P0 = 1 - P1;

% constellation parmeters
Aw = 1;
As = 1;
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

p11g0 = Ew*Es;
p10g0 = Ew*(1-Es);
p01g0 = (1-Ew)*Es;
p00g0 = (1-Ew)*(1-Es);

p11g1 = (1-Ew)*(1-Es);
p10g1 = (1-Ew)*Es;
p01g1 = Ew*(1-Es);
p00g1 = Ew*Es;

pc0 = [p00g0; p10g0; p01g0; p11g0];
pc1 = [p00g1; p10g1; p01g1; p11g1];
pc = P0*pc0 + P1*pc1;

% Optimal Error Calculations
cosThetaStar = (N0/(4*Pw*Ps))*log((1-Ew-Es)/(Es-Ew)); 
thetaStar = 0;
if 0 <= cosThetaStar && cosThetaStar <= 1
    thetaStar = acos(cosThetaStar);
end
errorStar = Ew + (1-Ew-Es)*(1 - normcdf((Pw + Ps*min(cosThetaStar,1))/sqrt(N0/2))) + ...
            (Es-Ew)*(1 - normcdf((Pw-Ps*min(cosThetaStar,1))/sqrt(N0/2)));