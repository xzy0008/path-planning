function out=line_circle_intersection(circle,m,b)
% line_circle_intersection - calculates intersection of a line and a circle
%
% format:   intersection = line_circle_intersection(h,k,r,m,b)
%
% input:    circle - ppCircle object
%           m       - slope of line
%           b       - y-intercept of line
%           
% output:   intersection - matrix containing two column vectors containing
%               x and y coordinates of intersections
%
%           intersections = [x1 x2
%                            y1 y2]
%
% Example: intersections=line_circle_intersection(2,3,5,1,-1)
% Results:
%         intersections =
% 
%             6.3912   -0.3912
%             5.3912   -1.3912

h=circle.x;
k=circle.y;
r=circle.radius;

% formulas calculated using:
% [x,y]=solve('y=m*x+b','(x-h)^2+(y-k)^2=r^2')

x1=0.5/(m^2+1)*(-2*m*b+2*k*m+2*h+2*(-2*m*b*h+2*k*m*h-m^2*h^2+m^2*r^2-k^2-b^2+2*k*b+r^2)^(1/2));
x2=0.5/(m^2+1)*(-2*m*b+2*k*m+2*h-2*(-2*m*b*h+2*k*m*h-m^2*h^2+m^2*r^2-k^2-b^2+2*k*b+r^2)^(1/2));
y1=0.5*m/(m^2+1)*(-2*m*b+2*k*m+2*h+2*(-2*m*b*h+2*k*m*h-m^2*h^2+m^2*r^2-k^2-b^2+2*k*b+r^2)^(1/2))+b;
y2=0.5*m/(m^2+1)*(-2*m*b+2*k*m+2*h-2*(-2*m*b*h+2*k*m*h-m^2*h^2+m^2*r^2-k^2-b^2+2*k*b+r^2)^(1/2))+b;

out =[x1 x2; y1 y2];  % use eval to make sure no symbols are present
end
