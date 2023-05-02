theta = 0.5;
BaseSetup;

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
% closestTheory = zeros(gridDensity^2,1);

% need to make this more robust
% for i = 1:gridDensity
%     for j = 1:gridDensity
%         A = dot([x(i),y(j)], w1)*2/N0;
%         B = dot([x(i),y(j)], s1)*2/N0;
%         if sign(B)*(tanh(A)/tanh(B)) > sign(B)*((K0-K1)/(K1+K0))
% %         if C1*sinh(A+B) > C2*sinh(-A+B)
%             closestTheory((i-1)*gridDensity + j) = 1;
%         else
%             closestTheory((i-1)*gridDensity + j) = 0;
%         end
%     end
% end

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

% constellation points
constX = points(:,1);
constY = points(:,2);

% plot regions
figure
hold on
scatter(X,Y,2,closest,'filled');
scatter(constX,constY,20,'red','filled');

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
