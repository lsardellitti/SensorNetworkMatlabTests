% source probability
P1 = 0.5;
P0 = 1 - P1;

% Number of Sensors
N = 4;

% crossover probabilities
E = [0.1, 0.1, 0.3, 0.3];

if exist('setupValsOverride','var') ~= 1 || setupValsOverride == false
    % noise power
    N0 = 1;
    
    % signal powers (expressed as square root of mean power)
    P = [1, 1, 1, 1];
end

% Noise standard deviation
noistdv = sqrt(N0/2);

% constellation parmeters
A = [-sqrt(P1/P0), sqrt(P0/P1)];

% constellation points
points = zeros(2^N,1);
pc0 = ones(2^N,1);
pc1 = ones(2^N,1);
binWords = dec2bin(0:2^N-1)-'0';
for i = 1:2^N
    for n = 1:N
        points(i) = points(i) + A(binWords(i,n)+1)*P(n);
        pc0(i) = pc0(i) * (binWords(i,n)*E(n) + (1-binWords(i,n))*(1-E(n)));
        pc1(i) = pc1(i) * (binWords(i,n)*(1-E(n)) + (1-binWords(i,n))*E(n));
    end
end

centerPoint = (points(1) + points(2^N)) / 2;
pc = P0*pc0 + P1*pc1;
pBar = P1*pc1 - P0*pc0;
