theta = pi/4;
BaseSetup;

gridDensity = 50;
pointSize = 4;
gridBound = max(abs(points),[],"all") * 1.5;
gridMeshSize = 2*gridBound / (gridDensity - 1);
x = linspace(-gridBound,gridBound,gridDensity);
y = linspace(-gridBound,gridBound,gridDensity);
X = zeros(gridDensity^2,1);
Y = zeros(gridDensity^2,1);
sourceReceived = zeros(gridDensity^2,1);

trials = 50000000;
noise = mvnrnd([0,0],eye(2)*(N0/2),trials);
source = rand(trials,1)<P1;
weakChannel = rand(trials,1)<Ew;
strongChannel = rand(trials,1)<Es;
weakSignal = xor(source,weakChannel);
strongSignal = xor(source,strongChannel);
sendPoints = points(weakSignal + 2*strongSignal + 1,:); % this depends heavily on the order of points array
recvPoints = sendPoints + noise;
errors = 0;

for i = 1:trials
    xIndex = round((recvPoints(i,1)+gridBound)/gridMeshSize)+1;
    yIndex = round((recvPoints(i,2)+gridBound)/gridMeshSize)+1;
    
    xIndex = min(max(xIndex,1),gridDensity);
    yIndex = min(max(yIndex,1),gridDensity);
    
    gridIndex = (xIndex-1)*gridDensity + yIndex;
    sourceReceived(gridIndex) = sourceReceived(gridIndex) + 2*source(i) - 1;
end

for i = 1:gridDensity
    for j = 1:gridDensity
        gridIndex = (i-1)*gridDensity + j;
        X(gridIndex) = x(i);
        Y(gridIndex) = y(j);
        
        sourceReceived(gridIndex) = sourceReceived(gridIndex) >= 0;
    end
end

figure
scatter(X,Y,pointSize,sourceReceived,'filled');
