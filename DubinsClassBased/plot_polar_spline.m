% plot_spp  plots a single polar-polynomial (SPP)
%
% Method:
% -
%
% Inputs:
% - radius - minimum radius of SPP
% - beta - break angle (used for turn angles > 90 degrees) - angle at which
%   polar spline ends and circular arc begins
% - theta_start - beginning angle
% - theta_total - turn angle made by arc
%   (arc will be drawn from theta_start to theta_start+theta_total)
% - x_c, y_c - the x and y centerpoints of the arc (used to offset arc)
% - axes_num - handle to axes to draw arc on
% - options - (optional) options to be passed to plot function

function out = plot_polar_spline(radius, beta, theta_start, theta_total, x_c, y_c, axes_num,options)

if (nargin==6)
    axes_num=gca;
    options='';
elseif (nargin==7)
    options='';
end

% set axes number passed in to current axes
axes(axes_num);
% don't erase anything previously on plot
hold on;

% break arc up into three segments, 0 to beta, beta to theta-beta,
% theta-beta to theta
%----------------------------------------------------------------------
% segment 1 - spp from start_angle to start_angle + beta
spp.theta=linspace(0,beta);
spp.r=radius*(1+spp.theta.^2/2-spp.theta.^3/(2*beta)+spp.theta.^5/(10*beta^3));
% add start angle to rotate arc
spp.theta=spp.theta+theta_start;
% convert to cartesian coordinates
spp.x=x_c+spp.r.*sin(spp.theta);
spp.y=y_c+spp.r.*cos(spp.theta);
% plot results
plot(spp.x, spp.y,options);
%----------------------------------------------------------------------
% segment 2 - circular arc from beta to theta_total-beta
spp.theta=linspace(beta, theta_total-beta);
Rb=(beta^2+10)*radius/10;
spp.rc=Rb;
% add start angle to rotate arc
spp.theta=spp.theta+theta_start;
% convert to cartesian coordinates
spp.x=x_c+spp.rc.*sin(spp.theta);
spp.y=y_c+spp.rc.*cos(spp.theta);
% plot results
plot(spp.x, spp.y,options);
%----------------------------------------------------------------------
% segment 3
%spp.theta=theta_total-linspace(0, beta);
spp.theta=linspace(0,beta);
spp.r=fliplr(spp.r);
%spp.r=radius*(1+spp.theta.^2/2-spp.theta.^3/(2*beta)+spp.theta.^5/(10*beta^3));
% add start angle to rotate arc
spp.theta=linspace(0,beta)+(theta_start+theta_total-beta);
% convert to cartesian coordinates
spp.x=x_c+spp.r.*sin(spp.theta);
spp.y=y_c+spp.r.*cos(spp.theta);
% plot results
out=plot(spp.x, spp.y,options);

hold off;

end