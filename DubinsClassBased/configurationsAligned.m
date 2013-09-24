function out=configurationsAligned(config1,config2)
%CONFIGURATIONSALIGNED determines if two configurations are aligned or not
%   Configurations are considered aligned if a path can be generated
%   between them using only a straight line
%   i.e. they must have the same orientation and the orientation of the 1st
%   configuration must be pointed along a line between the two orientations
%
%   configurationsAligned(config1,config2)
%       - config1 = initial configuration
%       - config2 = goal configuration
%
% written by: David Hodo - 2006 - hododav@auburn.edu

% check to see if the two orientations are equal
% if (abs(CheckWrap(config2.theta-config1.theta))>0.01)
if (abs((config2.theta-config1.theta))>0.01)
   out=false; 
else
    % calculate angle of line joining the two configuration
    ang=atan2(config2.x-config1.x,config2.y-config1.y);
    % check to see if the angle of that line is the same as the orientation
    % of the 1st configuration
%     if (abs(CheckWrap(ang-config1.theta))>0.01)
    if (abs((ang-config1.theta))>0.01)
       out=false; 
    else
        out=true;
    end
end


end

% 
% // deux configurations sont elles alignees ?
% bool configuration_aligned (SMT_Configuration q1, 
% 			    SMT_Configuration q2) {
%   // identical orientations ?
%   if ( fabs (q2.theta - q1.theta) > get_epsilon () ) { return false; }
%   // angle de la droite orientee joignant q1 a q2
%   angle of the upright orientee joining q1 has q2
%   double angle = twopify (atan2 (q2.y - q1.y, q2.x - q1.x));
%   return fabs (angle - q1.theta) <= get_epsilon ();
% }
