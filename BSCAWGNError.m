x = 0:.01:1; 
y = 0:.1:10;

[xx,yy] = meshgrid(x,y);
z = xx.*(1-normcdf(yy)) + (1-xx).*normcdf(yy);

% [px,py] = gradient(zz,.2,.2);
% 
% quiver(x,y,px,py)

surf(xx,yy,z)
% 
% surf(x.*(1-normcdf(y)) + (1-x).*normcdf(y))