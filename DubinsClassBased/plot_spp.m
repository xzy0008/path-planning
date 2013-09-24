% plot_spp  plots a single polar-polynomial (SPP)
%
% Method:
% -
%
% Inputs:
% - radius - minimum radius of SPP
% - theta_start - beginning angle
% - theta_total - turn angle made by arc
%   (arc will be drawn from theta_start to theta_start+theta_total)
% - x_c, y_c - the x and y centerpoints of the arc (used to offset arc)
% - axes_num - handle to axes to draw arc on
% - options - (optional) options to be passed to plot function

function out = plot_spp(radius, theta_start, theta_total, x_c, y_c, axes_num,options)

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

% generate SPP arc
spp.theta=linspace(0, theta_total);
spp.r=radius*(1+spp.theta.^2/2-spp.theta.^3/theta_total+spp.theta.^4/(2*theta_total^2));
% add start angle to rotate arc
spp.theta=spp.theta+theta_start;

% convert to cartesian coordinates
spp.x=x_c+spp.r.*sin(spp.theta);
spp.y=y_c+spp.r.*cos(spp.theta);

% plot results
out=plot(spp.x, spp.y,options);

hold off;

end