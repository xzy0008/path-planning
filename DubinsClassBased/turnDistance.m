function out=turnDistance(circle,x1,y1,x2,y2)
%TURNDISTANCE calculates the distance traveled during a turn that is part
%of a Dubins' path.
%
%   turnDistance(circle,x1,y1,x2,y2)
%       - circle = circle that turn is being made on
%       - x1 = initial point on circle (x coordinate)
%       - y1 = initial point on circle (y coordinate)
%       - x2 = final point on circle (x coordinate)
%       - y2 = final point on circle (y coordinate)
%
% output: 
%       -  out = length of turn
%
% Reference: Optimal Motion Control of a Ground Vehicle. Anisi
% written by: David Hodo - 2006 - hododav@auburn.edu

% calculate angles for start and end point
initAng=atan2(x1-circle.x,y1-circle.y);
finalAng=atan2(x2-circle.x,y2-circle.y);

% calculate angular distance around circle
if (circle.left)
    angDist=mod(initAng-finalAng+2*pi,2*pi);
else
    angDist=mod(finalAng-initAng+2*pi,2*pi);
end

% compute actual distance by multiplying by radius
out=abs(angDist*circle.radius);

end
