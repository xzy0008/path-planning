function out = ppCircle(x_c,y_c,radius,left,forward)
%PPCIRCLE constructor for a path planning circle object
%   Defines a circle that is to be used as part of a path
%
%   ppCircle(x_c,y_c,radius,left,forward)
%       - x_c = center of circle (x coordinate)
%       - y_c = center of circle (y coordinate)
%       - radius = radius of circle
%       - left = direction of circle - true if circle turns left (is
%                   counter-clockwise)
%       - forward = direction of travel when on arc - true if vehicle is
%               traveling forward
%
% written by: David Hodo - 2006 - hododav@auburn.edu
if nargin==3
    left=false;
    forward=true;
end

out.x=x_c;
out.y=y_c;
out.radius=radius;
out.left=left;
out.forward=forward;
out.name='circle';
end