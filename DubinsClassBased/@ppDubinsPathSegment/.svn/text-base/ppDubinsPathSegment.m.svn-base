function out = ppDubinsPathSegment(startCfg, endCfg, radius, plot_results)
%PPDUBINSPATH constructor for a Dubins' path object
%   Generates a path between two configurations consisting of only line and
%   arc segments
%
%   ppDubinsPathSegment(startCfg, endCfg, radius, plot_results)
%       - startCfg = initial configuration
%       - endCfg = goal configuration
%       - radius = minimum turning radius (m)
%       - plot_results = boolean - if true all admissable paths are drawn
%
%   output:
%       - startCircle = circle for 1st turn
%       - intCircle = intermediate circle for RLR and LRL paths
%       - endCircle = circle for final turn
%       - x_c1 = x coordinate of tangent point to 1st circle
%       - y_c1 = y coordinate of tangent point to 1st circle
%       - x_c2 = x coordinate of tangent point to 2nd circle
%       - y_c2 = y coordinate of tangent point to 2nd circle
%       - lengths = array containing the length of the total path and each
%           individual segment
%       - BBB = determines if middle segment is an arc or a line
%           - if true - path consists of three turns
%
%
% Reference: Optimal Motion Control of a Ground Vehicle. Anisi
% written by: David Hodo - 2006 - hododav@auburn.edu

% delcare vector to hold lenghts of possible path types
path_length=-ones(1,9);


%% 1) find the center of the two circles at each endpoint by rotating v +-90
% degrees
r_cip=[radius*sin(startCfg.theta)*cos(pi/2)+radius*cos(startCfg.theta)*sin(pi/2)+startCfg.x;
      -radius*sin(startCfg.theta)*sin(pi/2)+radius*cos(startCfg.theta)*cos(pi/2)+startCfg.y];  %r_ci+ counterclockwise
r_cim=[radius*sin(startCfg.theta)*cos(-pi/2)+radius*cos(startCfg.theta)*sin(-pi/2)+startCfg.x;
      -radius*sin(startCfg.theta)*sin(-pi/2)+radius*cos(startCfg.theta)*cos(-pi/2)+startCfg.y];  %r_ci- clockwise
r_cfp=[radius*sin(endCfg.theta)*cos(pi/2)+radius*cos(endCfg.theta)*sin(pi/2)+endCfg.x;
      -radius*sin(endCfg.theta)*sin(pi/2)+radius*cos(endCfg.theta)*cos(pi/2)+endCfg.y];  %r_cf+ counterclockwise
r_cfm=[radius*sin(endCfg.theta)*cos(-pi/2)+radius*cos(endCfg.theta)*sin(-pi/2)+endCfg.x;
      -radius*sin(endCfg.theta)*sin(-pi/2)+radius*cos(endCfg.theta)*cos(-pi/2)+endCfg.y];  %r_cf- clockwise

% create the circle objects
start_left_forward=ppCircle(r_cim(1),r_cim(2),radius,true,true);
start_right_forward=ppCircle(r_cip(1),r_cip(2),radius,false,true);
end_left_backward=ppCircle(r_cfm(1),r_cfm(2),radius,true,false);
end_right_backward=ppCircle(r_cfp(1),r_cfp(2),radius,false,false);


if (plot_results)
    % plot the circles to verify
    figure(10);
    clf;
    hold on;
    circle3([start_left_forward.x;start_left_forward.y;0],start_left_forward.radius,1000,'r');
    circle3([start_right_forward.x;start_right_forward.y;0],start_right_forward.radius,1000,'g');
    circle3([end_left_backward.x;end_left_backward.y;0],end_left_backward.radius,1000,'b');
    circle3([end_right_backward.x;end_right_backward.y;0],end_right_backward.radius,1000,'y');
    plot_arrow_angle(startCfg.x,startCfg.y,startCfg.theta,3);
    plot_arrow_angle(endCfg.x,endCfg.y,endCfg.theta,3);
    axis equal
end

%% 2) calculate paths between configurations

% calculate all admissable paths between the two configurations that
% consist of at most 3 segments - compare lenghts when done to determine
% optimal path

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% case EMPTY
% check to see if starting and ending configurations are the same
if (configurationsEqual(startCfg,endCfg))
   % no path needed - start and end are the same 
   %disp('Start and end configurations are the same.');
   paths(1).initCircle=ppCircle(0,0,0,false,false);
   paths(1).intCircle=ppCircle(0,0,0,false,false);
   paths(1).termCircle=ppCircle(0,0,0,false,false);
   paths(1).x_c1=startCfg.x;
   paths(1).y_c1=startCfg.y;
   paths(1).x_c2=endCfg.x;
   paths(1).y_c2=endCfg.y;
   % distance of both turn segments is 0
   paths(1).length=[0 0 0 0];
   paths(1).BBB=false;
   % this is always the shortest path - don't check others
   out=paths(1);
   return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (1) case S
% check to see if configurations are aligned - if so they can be connected
% by a straight line segment
if (configurationsAligned(startCfg,endCfg))
   % create a path that consists of only a straight line segment between 
   % the two endpoints
   %disp('Start and end configurations are aligned')
   paths(1).initCircle=ppCircle(0,0,0,false,false);
   paths(1).intCircle=ppCircle(0,0,0,false,false);
   paths(1).termCircle=ppCircle(0,0,0,false,false);
   paths(1).x_c1=startCfg.x;
   paths(1).y_c1=startCfg.y;
   paths(1).x_c2=endCfg.x;
   paths(1).y_c2=endCfg.y;
   % calculate distance of line segment
   d=sqrt((endCfg.x-startCfg.x)^2+(endCfg.y-startCfg.y)^2);
   % distance of both turn segments is 0
   paths(1).length=[d 0 d 0];
   paths(1).BBB=false;
   % this is always the shortest path - don't check others
   out=paths(1);
   return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (2) case L
% if the configuration is on the starting, left circle then it can be
% reached with a single left turn
if (configurationOnCircle(endCfg,start_left_forward))
    %disp('Start and end configurations are on the same circle (L).')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (3) case R
% if the configuration is on the starting, left circle then it can be
% reached with a single right turn
if (configurationOnCircle(endCfg,start_right_forward))
    %disp('Start and end configurations are on the same circle (R).')    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (4) case RLR
% if start and end configurations are too close together, a 3rd circle
% might be required to connect them
if (tangentCircleExists(start_right_forward,end_right_backward))
     %disp('Tangent circle exists between start and end configurations (RLR).')
     paths(4)=tangentCircle(start_right_forward,end_right_backward,startCfg,endCfg,false);
     path_length(4)=paths(4).length(1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (5) case LRL
% if start and end configurations are too close together, a 3rd circle
% might be required to connect them
if (tangentCircleExists(start_left_forward,end_left_backward))
     %disp('Tangent circle exists between start and end configurations (LRL).')
     paths(5)=tangentCircle(start_left_forward,end_left_backward,startCfg,endCfg,false);
     path_length(5)=paths(5).length(1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (6) case RSR
% if circles are equi-directed - calculate external tangents (4.8)
if (externalTangentsExist(start_right_forward,end_right_backward))
    paths(6)=dubinsAdmissableTangent(start_right_forward,end_right_backward,startCfg,endCfg);
    path_length(6)=paths(6).length(1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (7) case RSL
if (internalTangentsExist(start_right_forward,end_left_backward))
    paths(7)=dubinsAdmissableTangent(start_right_forward,end_left_backward,startCfg,endCfg);
    path_length(7)=paths(7).length(1);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (8) case LSR
if internalTangentsExist(start_left_forward,end_right_backward)
    paths(8)=dubinsAdmissableTangent(start_left_forward,end_right_backward,startCfg,endCfg);
    path_length(8)=paths(8).length(1);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (9) case LSL
if (externalTangentsExist(start_left_forward,end_left_backward))
    paths(9)=dubinsAdmissableTangent(start_left_forward,end_left_backward,startCfg,endCfg);
    path_length(9)=paths(9).length(1);
end


% search for shortest path
shortest_length=max(path_length)+1;
for i=1:length(path_length)
   if ((path_length(i)>0) && (path_length(i)<shortest_length))
       shortest_length=path_length(i);
       shortest_index=i;
   end
end

out=paths(shortest_index);

%shortest_index
%% plot results

if (plot_results)
    if (path_length(1)>0)
        % plot S case
        figure(1);
        clf;
        hold on;
        % plot velocity vectors
        plot_arrow_angle(startCfg.x,startCfg.y,startCfg.theta,3);
        plot_arrow_angle(endCfg.x,endCfg.y,endCfg.theta,3);
        plot([paths(1).x_c1 paths(1).x_c2],[paths(1).y_c1 paths(1).y_c2])
        title('S')
        axis equal
    end

    
    if (path_length(4)>0)
        % plot RLR case
        figure(4);
        clf;
        hold on;
        % plot velocity vectors
        plot_arrow_angle(startCfg.x,startCfg.y,startCfg.theta,3);
        plot_arrow_angle(endCfg.x,endCfg.y,endCfg.theta,3);
        % plot circles - REPLACE THIS LATER TO JUST DRAW THE ARCS - USE
        % CIRCULARC
        circle3([start_right_forward.x;start_right_forward.y;0],start_right_forward.radius,1000);
        circle3([end_right_backward.x;end_right_backward.y;0],end_right_backward.radius,1000);
        circle3([paths(4).intCircle.x;paths(4).intCircle.y;0],paths(4).intCircle.radius,1000,'r');
        title('RLR')
        axis equal
    end

    if (path_length(5)>0)
        % plot LRL case
        figure(5);
        clf;
        hold on;
        % plot velocity vectors
        plot_arrow_angle(startCfg.x,startCfg.y,startCfg.theta,3);
        plot_arrow_angle(endCfg.x,endCfg.y,endCfg.theta,3);
        % plot circles - REPLACE THIS LATER TO JUST DRAW THE ARCS - USE
        % CIRCULARC
        circle3([start_left_forward.x;start_left_forward.y;0],start_left_forward.radius,1000);
        circle3([end_left_backward.x;end_left_backward.y;0],end_left_backward.radius,1000);
        circle3([paths(5).intCircle.x;paths(5).intCircle.y;0],paths(5).intCircle.radius,1000,'r');
        title('LRL')
        axis equal
    end
    
    if (path_length(6)>0)  
        % plot RSR case
        figure(6);
        clf;
        hold on;
        % plot velocity vectors
        plot_arrow_angle(startCfg.x,startCfg.y,startCfg.theta,3);
        plot_arrow_angle(endCfg.x,endCfg.y,endCfg.theta,3);
        % plot circles - REPLACE THIS LATER TO JUST DRAW THE ARCS - USE
        % CIRCULARC
        circle3([start_right_forward.x;start_right_forward.y;0],start_right_forward.radius,1000);
        circle3([end_right_backward.x;end_right_backward.y;0],end_right_backward.radius,1000);
        % plot tangent
        plot([paths(6).x_c1 paths(6).x_c2],[paths(6).y_c1 paths(6).y_c2])
        title('RSR')
        axis equal
    end
    
    if (path_length(7)>0)    
        % plot RSL case
        figure(7);
        clf;
        hold on;
        % plot velocity vectors
        plot_arrow_angle(startCfg.x,startCfg.y,startCfg.theta,3);
        plot_arrow_angle(endCfg.x,endCfg.y,endCfg.theta,3);
        % plot circles - REPLACE THIS LATER TO JUST DRAW THE ARCS - USE
        % CIRCULARC
        circle3([start_right_forward.x;start_right_forward.y;0],start_right_forward.radius,1000);
        circle3([end_left_backward.x;end_left_backward.y;0],end_left_backward.radius,1000);
        % plot tangent
        plot([paths(7).x_c1 paths(7).x_c2],[paths(7).y_c1 paths(7).y_c2])
        title('RSL')
        axis equal
    end
    
    if (path_length(8)>0)  
        % plot LSR case
        figure(8);
        clf;
        hold on;
        % plot velocity vectors
        plot_arrow_angle(startCfg.x,startCfg.y,startCfg.theta,3);
        plot_arrow_angle(endCfg.x,endCfg.y,endCfg.theta,3);
        % plot circles - REPLACE THIS LATER TO JUST DRAW THE ARCS - USE
        % CIRCULARC
        circle3([start_left_forward.x;start_left_forward.y;0],start_left_forward.radius,1000);
        circle3([end_right_backward.x;end_right_backward.y;0],end_right_backward.radius,1000);
        % plot tangent
        plot([paths(8).x_c1 paths(8).x_c2],[paths(8).y_c1 paths(8).y_c2])
        title('LSR')
        axis equal
    end
    
    if (path_length(9)>0)
        % plot LSL case
        figure(9);
        clf;
        hold on;
        % plot velocity vectors
        plot_arrow_angle(startCfg.x,startCfg.y,startCfg.theta,3);
        plot_arrow_angle(endCfg.x,endCfg.y,endCfg.theta,3);
        % plot circles - REPLACE THIS LATER TO JUST DRAW THE ARCS - USE
        % CIRCULARC
        circle3([start_left_forward.x;start_left_forward.y;0],start_left_forward.radius,1000);
        circle3([end_left_backward.x;end_left_backward.y;0],end_left_backward.radius,1000);
        % plot tangent
        plot([paths(9).x_c1 paths(9).x_c2],[paths(9).y_c1 paths(9).y_c2])
        title('LSL')
        axis equal
    end    
end

end
