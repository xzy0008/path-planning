% plot_path_curvature   Plots Linetracker Path Curvatures
%
% Syntax: plot_path_curvature(path, axes_num, plot_type,options)
%
% - plots curvature of a linetracker path
%
% Inputs:
% - path - a path structure which contains e,n coordinates for waypoints
%          and center points as well as the vehicle's speed for each segment
% - axes_num - handle to axes to plot path on
% - type - 'RS' for a Reeds and Shepp's Path (or)
%        - 'SPP' for a single polar polynomial path
%        - 'PS' for single polar polynomial path using polar splines for
%           curves > 90 degrees (NOT YET IMPLEMENTED!)
% - options - options to be sent to the plot function (ex: use ':r' for a
%             dotted red line)
function fig=plot_path_curvature(path, axes_num, plot_type,options)

%----------------------%
% ds - function to integrate to get arc length of spp curve
function y = arc_length_func(theta, theta_total, R)
y = ((R.*(1+theta.^2/2-theta.^3./theta_total+theta.^4/(2*theta_total.^2))).^2+(R.*theta-(3*R./theta_total)*theta.^2+(2.*R/theta_total.^2).*theta.^3).^2).^(1/2);
end
%----------------------%

%----------------------%
% ds - function to integrate to get arc length of modified spp curve
function y = arc_length_func_modified(theta, theta_total, R)
y = ((R*(1+theta.^2/2-5*theta.^4/(2*theta_total^2)+3*theta.^5/(theta_total^3)-theta.^6/theta_total^4)).^2+(R.*theta-(10*R/theta_total^2)*theta.^3+(15*R/theta_total^3)*theta.^4-(6*R/theta_total^4)*theta.^5).^2).^(1/2);
end
%----------------------%

% generate headings and arc directions for plot
%path=RS_path_headings(path);

beta=0.9; % break angle in radians (only used for SPP paths)

axes(axes_num);
%cla;
hold on

distStart=0;  % set initial distance along path
Kplot.dist(1)=0;
Kplot.K(1)=0;
for i=1:length(path)
    % determine if points describe line or arc
    %   - section if a line if the beginning waypoint and center are the
    %     same point (or very close)
    %   - a section is an arc if the beginning waypoint and center are not he same point
    if (path(i).ccw==2)
        % section is a line
        % curvature of a line is always 0
        
        %determine length of line segment
        distEnd=sqrt((path(i).endEast-path(i).startEast)^2+(path(i).endNorth-path(i).startNorth)^2)+distStart;
        % plot curvature versus distance
        %plot(linspace(dist(i-1),dist(i)),zeros(1,100));
        Kplot.dist(length(Kplot.dist):length(Kplot.dist)+99)=linspace(distStart,distEnd);
        Kplot.K(length(Kplot.K):length(Kplot.K)+99)=zeros(1,100);
        distStart=distEnd;
    else
        % section is an arc
        R=path(i).radius;  %determine radius

        theta_total=path(i).thetaTotal;
        theta=linspace(0,theta_total);

        switch plot_type
            case 'RS'
                % calculate curvature
                %K=ones(1,100).*path.speed(i)/R;
                % claculate arc length of segment
                distEnd=R*theta_total+distStart;
                Kplot.K(length(Kplot.dist):length(Kplot.dist)+99)=ones(1,100).*path(i).speed/R;
            case 'SPP'
                spp.r=R*(1+theta.^2/2-theta.^3/theta_total+theta.^4/(2*theta_total^2));
                % calculate derivative of arc
                spp.dr=R.*theta-(3*R/theta_total)*theta.^2+(2*R/theta_total^2)*theta.^3;
                % calculate second derivative
                spp.dr2=R-6*R.*theta/theta_total+6*R*theta.^2/(theta_total^2);
                spp.K=(spp.r.^2+2*spp.dr.^2-spp.r.*spp.dr2)./((spp.r.^2+spp.dr.^2).^(3/2));
                % calculate arc length of segment
                distEnd=quad(@(theta)arc_length_func(theta, theta_total, R),0,theta_total)+distStart;
                Kplot.K(length(Kplot.K):length(Kplot.K)+99)=spp.K;
            case 'SPP_Modified'
                spp.r=R*(1+theta.^2/2-5*theta.^4/(2*theta_total^2)+3*theta.^5/(theta_total^3)-theta.^6/theta_total^4);
                % calculate derivative of arc
                spp.dr=R.*theta-(10*R/theta_total^2)*theta.^3+(15*R/theta_total^3)*theta.^4-(6*R/theta_total^4)*theta.^5;
                % calculate second derivative
                spp.dr2=R-30*R.*theta.^2/theta_total^2+60*R*theta.^3/(theta_total^3)-30*R*theta.^4/(theta_total^4);
                spp.K=(spp.r.^2+2*spp.dr.^2-spp.r.*spp.dr2)./((spp.r.^2+spp.dr.^2).^(3/2));
                % calculate arc length of segment
                distEnd=quad(@(theta)arc_length_func_modified(theta, theta_total, R),0,theta_total)+distStart;
                Kplot.K(length(Kplot.K):length(Kplot.K)+99)=spp.K;
        end

        Kplot.dist(length(Kplot.dist):length(Kplot.dist)+99)=linspace(distStart,distEnd);
        distStart=distEnd;
        
        % plot curvature versus distance
        %plot(linspace(dist(i-1),dist(i)),spp.K);
       
    end
end

axes(axes_num);
plot(Kplot.dist,Kplot.K,options);
title('Curvature vs. Distance Along Path');
xlabel('Distance Traveled (m)');
ylabel('Curvature (1/m)');

maximum_curvature=max(Kplot.K)

hold off

fig=axes_num;
end