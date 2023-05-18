% source probability
P1 = 0.5;
P0 = 1 - P1;

% noise power
N0 = 1; 

% signal powers (expressed as square root of mean power)
Pw = sqrt(0.5);
Ps = sqrt(0.7);

% crossover probabilities
Ew = 0.1;
Es = 0.2;

% constellation parmeters
Aw = 1;
As = 1;
% theta = pi/3;
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

% testing things here
% norm(a00)^2 - norm(a11)^2
% 2*(Pw^2+Ps^2) - sqrt((1-Aw^2)*(1-As^2))

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

gridDensity = 150;
gridBound = Pw+Ps;
x = linspace(-gridBound,gridBound,gridDensity);
y = linspace(-gridBound,gridBound,gridDensity);
X = zeros(gridDensity^2,1);
Y = zeros(gridDensity^2,1);
closest = zeros(gridDensity^2,1);

% map decoding regions for 0,1
for i = 1:gridDensity
    for j = 1:gridDensity
        distances = zeros(length(points),1);
        for k = 1:length(points)
           distances(k) = norm([x(i), y(j)] - points(k,:))^2; 
        end
        weight0 = P0*(sum(pc0.*(exp(-distances/N0))));
        weight1 = P1*(sum(pc1.*(exp(-distances/N0))));
        [~, I] = max([weight0, weight1]);
        X((i-1)*gridDensity + j) = x(i);
        Y((i-1)*gridDensity + j) = y(j);
        closest((i-1)*gridDensity + j) = I;
    end
end

% region test for p=0.5, alpha=1
K1 = (1-Ew-Es)*exp(-(norm(points(4,:))^2)/N0);
K0 = (Es-Ew)*exp(-(norm(points(2,:))^2)/N0);
closestTheory = zeros(gridDensity^2,1);

% need to make this more robust
for i = 1:gridDensity
    for j = 1:gridDensity
        A = dot([x(i),y(j)], w1)*2/N0;
        B = dot([x(i),y(j)], s1)*2/N0;
        if sign(B)*(tanh(A)/tanh(B)) > sign(B)*((K0-K1)/(K1+K0))
%         if C1*sinh(A+B) > C2*sinh(-A+B)
            closestTheory((i-1)*gridDensity + j) = 1;
        else
            closestTheory((i-1)*gridDensity + j) = 0;
        end
    end
end

% map decoding regions for constellation points
% for i = 1:gridDensity
%     for j = 1:gridDensity
%         weights = zeros(length(points),1);
%         for k = 1:length(points)
%            distance = norm([x(i), y(j)] - points(k,:))^2; 
%            weights(k) = pc(k)*exp(-distance/N0);
%         end
%         [~, I] = max(weights);
%         X((i-1)*gridDensity + j) = x(i);
%         Y((i-1)*gridDensity + j) = y(j);
%         closest((i-1)*gridDensity + j) = I;
%     end
% end

% closest distance colouring
% for i = 1:gridDensity
%     for j = 1:gridDensity
%     distances = zeros(length(points),1);
%         for k = 1:length(points)
%            distances(k) = norm([x(i), y(j)] - points(k,:)); 
%         end
%         [~, I] = min(distances);
%         X((i-1)*gridDensity + j) = x(i);
%         Y((i-1)*gridDensity + j) = y(j);
%         closest((i-1)*gridDensity + j) = I;
%     end
% end

% plot constellation points
constX = points(:,1);
constY = points(:,2);

% plot regions
% figure
% hold on
% scatter(X,Y,2,closest,'filled');
% scatter(constX,constY,20,'red','filled');
% 
% figure
% hold on
% scatter(X,Y,2,closestTheory,'filled');
% scatter(constX,constY,20,'red','filled');


% testing error probs
% a00pdf = @(a,b) mvnpdf([a.',b.'], a00, eye(2)*N0);
% ybound = @(a) (N0/(2*Ps*sin(theta)))*(atanh(tanh(2*a*Pw/N0)*(K0+K1)/(K0-K1)) - 2*a*Ps*cos(theta)/N0);
% e00 = integral2(a00pdf,-100,100,ybound,100);

% simulating error
trials = 100000;
noise = mvnrnd([0,0],eye(2)*N0,trials); % this might need to be sqrt(N0) *******
source = rand(trials,1)<P1;
weakChannel = rand(trials,1)<Ew;
strongChannel = rand(trials,1)<Es;
weakSignal = xor(source,weakChannel);
strongSignal = xor(source,strongChannel);
sendPoints = points(weakSignal + 2*strongSignal + 1,:); % this depends heavily on the order of points array
recvPoints = sendPoints + noise;
errors = 0;

% decoding for Aw=As=1, P0=0.5
for i = 1:trials
    A = dot([recvPoints(i,1),recvPoints(i,2)], w1)*2/N0;
    B = dot([recvPoints(i,1),recvPoints(i,2)], s1)*2/N0;
    decoded = sign(B)*(tanh(A)/tanh(B)) > sign(B)*((K0-K1)/(K1+K0));
    if decoded ~= source(i)
        errors = errors + 1;
    end
end
