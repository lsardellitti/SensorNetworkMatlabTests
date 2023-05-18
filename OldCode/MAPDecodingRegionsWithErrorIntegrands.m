theta = 1;
BaseSetup;

gridDensity = 150;
gridBound = max(abs(points),[],"all") * 1.5;
x = linspace(-gridBound,gridBound,gridDensity);
y = linspace(-gridBound,gridBound,gridDensity);
X = zeros(gridDensity^2,1);
Y = zeros(gridDensity^2,1);
closest = zeros(gridDensity^2,1);

% map decoding regions for source bits (0 or 1)
for i = 1:gridDensity
    for j = 1:gridDensity
%         distances = zeros(length(points),1);
%         for k = 1:length(points)
%            distances(k) = norm([x(i), y(j)] - points(k,:))^2; 
%         end
%         weight0 = P0*(sum(pc0.*(exp(-distances/N0))));
%         weight1 = P1*(sum(pc1.*(exp(-distances/N0))));

        distanceFunc = @(a,k) (x(i) - a*points(k,1)).^2 + (y(i) - a*points(k,2)).^2;
        fadePdf = @(a) (a/sigma2).*exp(-(a.^2)/(2*sigma2));
        condProbVals = zeros(length(points),1);
        for k = 1:length(points)
           integrand = @(a) exp(-distanceFunc(a,k)/N0).*fadePdf(a);
           condProbVals(k) = integral(integrand,0,inf); 
        end
        weight0 = P0*(sum(pc0.*condProbVals));
        weight1 = P1*(sum(pc1.*condProbVals));
        
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

% exact error derivative integral integrand sign
a11IntegrandSign = zeros(gridDensity^2,1);
a01IntegrandSign = zeros(gridDensity^2,1);
totalIntegrandSign = zeros(gridDensity^2,1);

a01pdf = @(a,b) mvnpdf([a.',b.'], a01, eye(2)*(N0/2)).';
a11pdf = @(a,b) mvnpdf([a.',b.'], a11, eye(2)*(N0/2)).';
a01Integrand = @(a,b) (2/N0)*(-Ps*sin(theta)*(a+Pw-Ps*cos(theta))+Ps*cos(theta)*(b-Ps*sin(theta))).*a01pdf(a,b);
a11Integrand = @(a,b) (2/N0)*(-Ps*sin(theta)*(a-Pw-Ps*cos(theta))+Ps*cos(theta)*(b-Ps*sin(theta))).*a11pdf(a,b);

for i = 1:gridDensity
    for j = 1:gridDensity
        a11IntegrandSign((i-1)*gridDensity + j) = a11Integrand(x(i),y(j)) ;%>= 0;
        a01IntegrandSign((i-1)*gridDensity + j) = a01Integrand(x(i),y(j)) ;%>= 0;
        totalIntegrandSign((i-1)*gridDensity + j) = (1-Es-Ew)*a11Integrand(x(i),y(j)) - (Es-Ew)*a01Integrand(x(i),y(j)) >= 0;
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

% closest distance colouring of constellation points
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

% figure
% hold on
% scatter(X,Y,2,a11IntegrandSign,'filled');
% scatter(constX,constY,20,'red','filled');
% 
% figure
% hold on
% scatter(X,Y,2,a01IntegrandSign,'filled');
% scatter(constX,constY,20,'red','filled');
% 
% figure
% hold on
% scatter(X,Y,2,totalIntegrandSign,'filled');
% scatter(constX,constY,20,'red','filled');
