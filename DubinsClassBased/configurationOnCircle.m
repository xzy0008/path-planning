function out=configurationOnCircle(config, circle)
%CONFIGURATIONONCIRCLE determination if a configuration is a posibile
%   configuration on a given circle
%
%   configurationOnCircle(config, circle)
%       - config = 
%       - circle = 
%
% written by: David Hodo - 2006 - hododav@auburn.edu

% distance between configuration and center of circle
d=sqrt((circle.x-config.x)^2+(circle.y-config.y)^2);
% if the configuration is on the circle, the distance from the center of
% the circle to the configuration should be equal to the radius
if (abs(d-circle.radius)>0.01)
   out=false; 
else
    ang=atan2(config.x-circle.x,config.y-circle.y);
    
    % calculate tangent
    if (circle.left)
        ang=ang+pi/2;
    elseif (~circle.left)
        ang=ang-pi/2;
    end
    
%     if (abs(CheckWrap(config.theta-ang))<0.01)
    if (abs((config.theta-ang))<0.01)
        out=true;
    else
        out=false;
    end   
end


end

% // appartenance d'une configuration a un cc-circle
% bool configuration_on_cc_circle (SMT_CC_Circle c, 
% 				 SMT_Configuration q) {
%   // distance du centre de c a q
%   double distance = point_distance (c.xc, c.yc, q.x, q.y);
%   //
%   if ( fabs (distance - c.radius) > get_epsilon () ) { return false; }
%   // angle of the upright orientee joining the center of c has q
%   double angle = atan2 (q.y - c.yc, q.x - c.xc);
%   // amgle of the direction of the moved tangential one
%   if ( c.left && c.forward ) { angle = angle + Half_Pi - c.mu; }
%   if ( c.left && !c.forward ) { angle = angle + Half_Pi + c.mu; }
%   if ( !c.left && c.forward ) { angle = angle - Half_Pi + c.mu; }
%   if ( !c.left && !c.forward ) { angle = angle - Half_Pi - c.mu; }
%   angle = twopify (angle);
%   //
%   return fabs (q.theta - angle) < get_epsilon ();
% }
