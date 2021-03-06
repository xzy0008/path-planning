% plot_linetracker_path   Plots Linetracker Paths
%
% Syntax: [fig h]=plot_linetracker_path(path, axes_num, plot_type, headings, options)   
%
% - plots a Reeds and Shepp's Path, which consists of line segments and
%   circular arcs
%  (or)
% - plots a SPP plath which consists of single polar-polynomial arcs or
%   polar splines
%
% Inputs:
% - path - an array of ppSegment objects
% - axes_num - handle to axes to plot path on
% - type - 'RS' for a Reeds and Shepp's Path (or)
%        - 'SPP' for a single polar polynomial path
%        - 'PS' for a single polar polynomial path with polar splines for
%           curves > 90 degrees
% - headings  - boolean - if true an arrow showing the orientation at each
%       waypoint is drawn
% - options - options to be sent to the plot function (ex: use ':r' for a
%             dotted red line)
%
% Outputs:
% - fig - handle to figure
% - h - handle to path plot

function [fig h]=plot_linetracker_path(path, axes_num, plot_type, headings, options)


%beta=0.9; % break angle in radians (only used for SPP paths)

axes(axes_num);
%cla;
hold on
% draw endpoints and centers
%plot([path.endEast],[path.endNorth],'rx')
%plot([path.centerEast],[path.centerNorth],'bo')

type(length(path))=NaN;

for i=1:length(path)
    % determine if points describe line or arc
    %   - section if a line if the beginning waypoint and center are the
    %     same point (or very close)
    %   - a section is an arc if the beginning waypoint and center are not he same point
    if ((abs(path(i).startEast-path(i).centerEast)<0.01)&&(abs(path(i).startNorth-path(i).centerNorth)<0.01))
        % section is a line
        type(i)='l';

        % generate line between previous waypoint and new waypoint

        % check to see if line will be vertical
        if (abs(path(i).endEast-path(i).startEast)<0.001) % line is vertical
            prev.E(1:100)=path(i).startEast*ones(1,100);
            prev.N(1:100)=linspace(path(i).startNorth,path(i).endNorth);
        else % line is not vertical
            prev.E(1:100)=linspace(path(i).startEast,path(i).endEast);
            m=(path(i).endNorth-path(i).startNorth)/(path(i).endEast-path(i).startEast);
            b=path(i).endNorth-m*path(i).endEast;
            prev.N(1:100)=m.*prev.E+b;
        end
        hold on;
        h=plot(prev.E,prev.N,'r');

    else
        % section is an arc
        R=path(i).radius;
        theta_min=path(i).thetaMin;
        theta_max=path(i).thetaMax;
        theta_total=path(i).thetaTotal;

        % draw arc
        switch plot_type
            case 'RS'
                h=plot_arc(R, theta_min, theta_total,path(i).centerEast,path(i).centerNorth,axes_num,options);
            case 'SPP'
                h=plot_spp(R,theta_min, theta_total,path(i).centerEast,path(i).centerNorth,axes_num,options);
            case 'SPP_Modified'
                h=plot_modified_spp(R,theta_min, theta_total,path(i).centerEast,path(i).centerNorth,axes_num,options);
            case 'PS'
                if (theta_max-theta_min)>(pi/2)
                    h=plot_polar_spline(R,0.9,theta_min, theta_total,path(i).centerEast,path(i).centerNorth,axes_num,options);
                else
                    h=plot_spp(R,theta_min, theta_total,path(i).centerEast,path(i).centerNorth,axes_num,options);
                end
        end
        type(i)='a';
    end
end

% label axes
xlabel('East (m)');
ylabel('North (m)');


hold on

% plot heading arrows
% plot_arrow_angle(path.end.E(1),path.end.E(2), path.heading(1), 20);
if (headings)
    line_length=5;
    for j=1:length(path)
        y_change=cos(path(j).heading)*line_length;
        x_change=sin(path(j).heading)*line_length;
        hdg_arrow_x=path(j).endEast+x_change;
        hdg_arrow_y=path(j).endNorth + y_change;
        plot_arrow(path(j).endEast,path(j).endNorth, hdg_arrow_x, hdg_arrow_y);
    end
end
axis equal
hold off

fig=axes_num;
end
