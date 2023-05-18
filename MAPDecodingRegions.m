theta = 0.5;
BaseSetup;

gridDensity = 150;
gridBound = max(abs(points),[],"all") * 1.1;
x = linspace(-gridBound,gridBound,gridDensity);
y = linspace(-gridBound,gridBound,gridDensity);
X = zeros(gridDensity^2,1);
Y = zeros(gridDensity^2,1);
closest = zeros(gridDensity^2,1);

% map decoding regions for source bits (0 or 1)
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

% region test for p=0.5
% closestTheory = zeros(gridDensity^2,1);
% 
% for i = 1:gridDensity
%     for j = 1:gridDensity
%         A = dot([x(i),y(j)]-centerPoint, (abs(w0) + w1)/2)*2/N0;
%         B = dot([x(i),y(j)]-centerPoint, (abs(s0) + s1)/2)*2/N0;
%         if sign(B)*(tanh(A)/tanh(B)) > sign(B)*((K0-K1)/(K1+K0))
%             closestTheory((i-1)*gridDensity + j) = 1;
%         else
%             closestTheory((i-1)*gridDensity + j) = 0;
%         end
%     end
% end

% constellation points
constX = points(:,1);
constY = points(:,2);

% plot regions
figure
hold on
scatter(X,Y,2,closest,'filled');
scatter(constX,constY,20,'red','filled');
scatter(centerPoint(1),centerPoint(2),20,'green','filled');
scatter(0,0,20,'black','filled');

% add point labels
textXoff = -0.2;
textYoff = 0.3;
textSize = 15;
textColor = 'black';
textFont = 'Times';
text(constX(1)+textXoff,constY(1)+textYoff,'{\it a}_{00}','Color',textColor,'FontSize',textSize,'FontName',textFont);
text(constX(2)+textXoff,constY(2)+textYoff,'{\it a}_{10}','Color',textColor,'FontSize',textSize,'FontName',textFont);
text(constX(3)+textXoff,constY(3)+textYoff,'{\it a}_{01}','Color',textColor,'FontSize',textSize,'FontName',textFont);
text(constX(4)+textXoff,constY(4)+textYoff,'{\it a}_{11}','Color',textColor,'FontSize',textSize,'FontName',textFont);

% figure
% hold on
% scatter(X,Y,2,closestTheory,'filled');
% scatter(constX,constY,20,'red','filled');

