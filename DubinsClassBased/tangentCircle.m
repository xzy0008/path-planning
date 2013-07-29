function out = tangentCircle(circ1,circ2,config1,config2,plot_results)
%TANGENTCIRLCE generates a circle tangent to two given circles that is part
% of an Dubins' admissable path
%
%   tangentCircle(circ1,circ2)
%       - circle1 = 1st circle to find tangent to
%       - circle2 = 2nd circle to find tangent to
%       - config1 = starting configuration
%       - config2 = ending configuration
%       - plot_results = boolean - if true plots all four circles
%
% output: 
%       -  out.initCirle = circle for initial turn       
%       -  out.intCircle = circle object for intermediate turn
%       -  out.termCircle = circle object for terminal turn
%       -  out.x_c1 = point of tangency with 1st circle (x coordinate)
%       -  out.y_c1 = point of tangency with 1st circle (y coordinate)
%       -  out.x_c2 = point of tangency with 2nd circle (x coordinate)
%       -  out.y_c2 = point of tangency with 2nd circle (y coordinate)
%       -  out.lengths = vector containing total path length followed by length
%           of each segment: [l a b c] where l = total length, a = length of
%           1st turn, b = length of the straight segment, and c = length of
%           final turn
%       -  out.BBB = boolean - true if path is of type BBB (3 turn segments)
%
% Reference: http://mathcentral.uregina.ca/qq/database/QQ.09.02/keith1.html
% written by: David Hodo - 2006 - hododav@auburn.edu

%plot_results=true;

out.initCircle=circ1;
out.intCircle=0;    % make sure structure is created in right order - won't be needed in c++ 
out.termCircle=circ2;

% solution found by solving:
%>> syms x1 x2 y1 y2 xs ys r
%>> sol=solve('sqrt((xs-x1)^2+(ys-y1)^2)=2*r','sqrt((xs-x2)^2+(ys-y2)^2)=2*r',xs,ys)
% where xs and ys are the center of the solution circle and (x1,y1) and
% (x2,y2) are the centers of circ1 and circ2 respectively.

% assign needed values to varibles so that structure name doesn't have to be
% used over and over again
x1=circ1.x;
y1=circ1.y;
x2=circ2.x;
y2=circ2.y;
r=circ1.radius;

% from looking at plots - choose solution1 if the two circles are left
% directed, choose solution2 if the two circles are right directed
% HAVEN'T PROVED THIS MATHEMATICALLY - DOES IT ALWAYS WORK?
% - UPDATE: DOESN'T ALWAYS WORK - TRY BOTH AND PICK SHORTEST


% check to see if circles have the same x coordinate - if so a divide
% by zero will occur in the equations below, so a special case is added


if (circ1.left~=circ2.left)
    % if circles are not equi-directed - no admissable tangent circle exists
    error('Circles are not equi-directed.  No admissable tangent circle exists');
end

% check to see if circles are stacked (x1=x2) - see note above
if (abs(x2-x1)<0.01)
    % compute 1st solution
    xs1=x1+sqrt(4*r^2-(abs(y2-y1)/2)^2);
    ys1=(y2+y1)/2;
    % compute 2nd solution
    xs2=x1-sqrt(4*r^2-(abs(y2-y1)/2)^2);
    ys2=(y2+y1)/2;
else
    % factored out common terms by looking at pretty
    g=-2*y2*y1-2*x1*x2+y2^2+y1^2+x2^2+x1^2;
    g2=real((g*(-x2+x1)^2*(-x1^2+2*x1*x2+2*y2*y1-x2^2-y1^2-y2^2+16*r^2))^(1/2));

    xs1=(x2^2*y2*y1-0.5*x2^4+0.5*x1^4-0.5*x2^2*y2^2-0.5*x2^2*y1^2+0.5*y2^2*x1^2+0.5*x1^2*y1^2+x1*x2^3-x1^3*x2+0.5*y2*g2-0.5*y1*g2-x1^2*y2*y1)/(g*(x1-x2));
    ys1=(-0.5*y2^2*y1-x1*x2*y1-0.5*y2*y1^2+0.5*x2^2*y1+0.5*x1^2*y2+0.5*y2^3+0.5*y1^3+0.5*x1^2*y1-x1*x2*y2+0.5*x2^2*y2+0.5*g2)/(g);
    xs2=(x2^2*y2*y1-0.5*x2^4+0.5*x1^4-0.5*x2^2*y2^2-0.5*x2^2*y1^2+0.5*y2^2*x1^2+0.5*x1^2*y1^2+x1*x2^3-x1^3*x2-0.5*y2*g2+0.5*y1*g2-x1^2*y2*y1)/(g*(x1-x2));
    ys2=(-0.5*y2^2*y1-x1*x2*y1-0.5*y2*y1^2+0.5*x2^2*y1+0.5*x1^2*y2+0.5*y2^3+0.5*y1^3+0.5*x1^2*y1-x1*x2*y2+0.5*x2^2*y2-0.5*g2)/(g);
end

% define two possible solution circles
% solution circles should be in opposite direction of both circles passed in
intCircle1=ppCircle(xs1,ys1,r,~circ1.left,true);
intCircle2=ppCircle(xs2,ys2,r,~circ1.left,true);


% calculate the points of tangency
% since the two circles are tangent and have the same radius, their point 
% of intersection is at the midpoint of the line segment between their
% centers
% calculate tangent points for 1st solution
x1_c1=(circ1.x+xs1)/2;
y1_c1=(circ1.y+ys1)/2;
x1_c2=(circ2.x+xs1)/2;
y1_c2=(circ2.y+ys1)/2;
% calculate tangent points for 2nd solution
x2_c1=(circ1.x+xs2)/2;
y2_c1=(circ1.y+ys2)/2;
x2_c2=(circ2.x+xs2)/2;
y2_c2=(circ2.y+ys2)/2;


% calculate path length for each case and pick shortest
% calculate distance of first turn
a1=turnDistance(circ1,config1.x,config1.y,x1_c1,y1_c1);
% calculate distance of intermediate turn
b1=turnDistance(intCircle1,x1_c1,y1_c1,x1_c2,y1_c2);
% calculate distance of final turn
c1=turnDistance(circ2,x1_c2,y1_c2,config2.x,config2.y);
l1=a1+b1+c1;

% calculate lenght of 2nd possible path
a2=turnDistance(circ1,config1.x,config1.y,x2_c1,y2_c1);
% calculate distance of intermediate turn
b2=turnDistance(intCircle2,x2_c1,y2_c1,x2_c2,y2_c2);
% calculate distance of final turn
c2=turnDistance(circ2,x2_c2,y2_c2,config2.x,config2.y);
l2=a2+b2+c2;

% compare lengths and determine which path to return
if (abs(l2)<abs(l1))
    % return 2nd path
    out.x_c1=x2_c1;
    out.y_c1=y2_c1;
    out.x_c2=x2_c2;
    out.y_c2=y2_c2;
    out.intCircle=intCircle2;
    out.length=[l2 a2 b2 c2];
    
    % plot all four circles
    if (plot_results)
        figure();
        hold on;
        circle3([circ1.x;circ1.y;0],circ1.radius,1000,'b');
        circle3([circ2.x;circ2.y;0],circ2.radius,1000,'k');
        circle3([xs2;ys2;0],r,1000,'g--');
        circle3([xs1;ys1;0],r,1000,'r--');
        legend('Circle1','Circle2','Solution','Solution2')
        % plot points of tangency
        scatter([out.x_c1 out.x_c2],[out.y_c1 out.y_c2],'^');
        axis equal
    end
else
    % return 1st path
    out.x_c1=x1_c1;
    out.y_c1=y1_c1;
    out.x_c2=x1_c2;
    out.y_c2=y1_c2;
    out.intCircle=intCircle1;
    out.length=[l1 a1 b1 c1];
    % plot all four circles
    if (plot_results)
        figure();
        hold on;
        circle3([circ1.x;circ1.y;0],circ1.radius,1000,'b');
        circle3([circ2.x;circ2.y;0],circ2.radius,1000,'k');
        circle3([xs1;ys1;0],r,1000,'g--');
        circle3([xs2;ys2;0],r,1000,'r--');
        legend('Circle1','Circle2','Solution','Solution2')
        % plot points of tangency
        scatter([out.x_c1 out.x_c2],[out.y_c1 out.y_c2],'^');
        axis equal
    end
end

out.BBB=true;

end % end function