function [ out ] = oddStepTSPN( nodes, turn_radius )
%ODDSTEPTSPN Summary of this function goes here
%   Detailed explanation goes here
    n=length(nodes);
    %test intersection between dubins path (i to i+1), update
    %dockconfiguration of node i+1
    for i=1:n-1
       initialConfig=nodes(i).dockConfiguration;
       terminalConfig=nodes(i+1).dockConfiguration;
       path=configurationsToDubinsPath([initialConfig;terminalConfig],turn_radius);
       circle=nodes(i+1).circle;
       [x,y,h]=dubinsCircleIntersection(path,circle);
       %update the first intersection point configuration
       if (length(x)==1 && ~isnan(x)) || (length(x)>=2)
           nodes(i+1).dockConfiguration(1)=x(1);
           nodes(i+1).dockConfiguration(2)=y(1);
           nodes(i+1).dockConfiguration(3)=h(1);
       end
    end
    %test intersection between dubins path (n to 1), update
    %dockconfiguration of node 1
    initialConfig=nodes(n).dockConfiguration;
    terminalConfig=nodes(1).dockConfiguration;
    path=configurationsToDubinsPath([initialConfig;terminalConfig],turn_radius);
    circle=nodes(1).circle;
    [x,y,h]=dubinsCircleIntersection(path,circle);
    %update the first intersection point configuration
    if (length(x)==1 && ~isnan(x)) || (length(x)>=2)
        nodes(1).dockConfiguration(1)=x(1);
        nodes(1).dockConfiguration(2)=y(1);
        nodes(1).dockConfiguration(3)=h(1);
    end
    
    out=nodes;
end

