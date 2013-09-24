function [ out ] = evenStepTSPN( nodes, turn_radius )
%EVENSTEPTSPN Summary of this function goes here
%   Detailed explanation goes here
    n=length(nodes);
    %test intersection between dubins path (i to i+1), update
    %dockconfiguration of node i
    for i=1:n-1
       initialConfig=nodes(i).dockConfiguration;
       terminalConfig=nodes(i+1).dockConfiguration;
       path=configurationsToDubinsPath([initialConfig;terminalConfig],turn_radius);
       circle=nodes(i).circle;
       [x,y,h]=dubinsCircleIntersection(path,circle);
       %update the second intersection point configuration
       if length(x)>=2
           nodes(i).dockConfiguration(1)=x(end);
           nodes(i).dockConfiguration(2)=y(end);
           nodes(i).dockConfiguration(3)=h(end);
       elseif ~isnan(x) %in case test failed to get two intersection point due to the flowt precision
           nodes(i).dockConfiguration(1)=x(1);
           nodes(i).dockConfiguration(2)=y(1);
           nodes(i).dockConfiguration(3)=h(1);
       end
    end
    %test intersection between dubins path (n to 1), update
    %dockconfiguration of node n
    initialConfig=nodes(n).dockConfiguration;
    terminalConfig=nodes(1).dockConfiguration;
    path=configurationsToDubinsPath([initialConfig;terminalConfig],turn_radius);
    circle=nodes(n).circle;
    [x,y,h]=dubinsCircleIntersection(path,circle);
    %update the second intersection point configuration
    if length(x)>=2
        nodes(n).dockConfiguration(1)=x(end);
        nodes(n).dockConfiguration(2)=y(end);
        nodes(n).dockConfiguration(3)=h(end);
    elseif ~isnan(x) %in case test failed to get two intersection point due to the flowt precision
        nodes(n).dockConfiguration(1)=x(1);
        nodes(n).dockConfiguration(2)=y(1);
        nodes(n).dockConfiguration(3)=h(1);        
    end
    
    out=nodes;
end

