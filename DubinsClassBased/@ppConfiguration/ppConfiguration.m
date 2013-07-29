function out = ppConfiguration(x,y,theta,speed)
%PPCONFIGURATION constructor for a path planning configuration object
%   Defines a configuration that defines a position and orientation of a
%   vehicle
%
%   ppConfiguration(x,y,theta)
%       - x = position (x coordinate)
%       - y = position (y coordinate)
%       - theta = vehicle orientation (radians) - measured counterclockwise
%               from the x axis
%       - speed = desired speed for current path segment

out.x=x;
out.y=y;
out.theta=theta;
out.speed=speed;

end