% PLOT_ARC  Draws a circular arc
% Syntax: H=plot_arc(radius, theta_start, theta_total, x_c, y_c,
%           axes_num,options)
%
% Inputs:
% - radius - radius of arc
% - theta_start - beginning angle
% - theta_total - turn angle made by arc 
%   (arc will be drawn from theta_start to theta_start+theta_total)
% - x_c, y_c - the x and y centerpoints of the arc (used to offset arc)
% - axes_num - handle to axes to draw arc on
% - options - (optional) options to be passed to plot function
%
% Returns handle to graphics object

function out = plot_arc(radius, theta_start, theta_total, x_c, y_c, axes_num,options)

if (nargin==5)
    axes_num=gca;
    options='';
elseif (nargin==6)
    options='';
end

% set axes number passed in to current axes
axes(axes_num);
% don't erase anything previously on plot
hold on;

% do coordinate transforms:
%theta_start=mod(-theta_start+pi/2+2*pi,2*pi);

%generate points to plot
rs.theta=linspace(theta_start, theta_start+theta_total);
rs.r=radius.*ones(1,100);

% convert to cartesian coordinates
rs.x=x_c+rs.r.*sin(rs.theta);
rs.y=y_c+rs.r.*cos(rs.theta);

% plot results
out=plot(rs.x,rs.y,options);

hold off;

end