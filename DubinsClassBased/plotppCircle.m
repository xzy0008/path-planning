function out = plotppCircle(circle,options)
%PLOTPPCIRCULARARC Plots a circular arc
%   plots a ppCircularArc object with the given options
%
%   Syntax: plotppCircularArc(arc,options)
%  
%   Inputs:
%   - circle = ppCircle structure to plot
%   - options (optional) = plotting options
%
%   Written by David Hodo - hododav@auburn.edu - January 2008

if (nargin==1)
    options='';
end

%generate points to plot
rs.theta=linspace(-pi, pi);
rs.r=circle.radius*ones(1,100);

% convert to cartesian coordinates
rs.x=circle.x+rs.r.*sin(rs.theta);
rs.y=circle.y+rs.r.*cos(rs.theta);

% plot results
plot(rs.x,rs.y,options)

% output generated structure
out = rs;
end