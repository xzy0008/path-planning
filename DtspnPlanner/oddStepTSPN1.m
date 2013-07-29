function [ out ] = oddStepTSPN1( nodes, turn_radius )
%ODDSTEPTSPN Summary of this function goes here
%   Detailed explanation goes here
    n=length(nodes);
    %test intersection between dubins path (i to i+1) and circle (i+1), update
    %dockconfiguration of node i+1
    for i=1:2:n
       initialConfig=nodes(i).dockConfiguration;
       terminalConfig=nodes(i+1).dockConfiguration;
       path=configurationsToDubinsPath([initialConfig;terminalConfig],turn_radius);
       circle=nodes(i+1).circle;
       [x,y,h]=dubinsCircleIntersection(path,circle);
       %update the first intersection point configuration
       if (length(x)==1 && ~isnan(x)) || (length(x)>=2)
           nodes(i+1).updateConfiguration(1)=x(1);
           nodes(i+1).updateConfiguration(2)=y(1);
           nodes(i+1).updateConfiguration(3)=h(1);
       end
       
       circle=nodes(i).circle;
       [x,y,h]=dubinsCircleIntersection(path,circle);
       %update the second intersection point configuration
       if length(x)>=2
           nodes(i).updateConfiguration(1)=x(end);
           nodes(i).updateConfiguration(2)=y(end);
           nodes(i).updateConfiguration(3)=h(end);
       elseif ~isnan(x) %in case test failed to get two intersection point due to the flout precision
           nodes(i).updateConfiguration(1)=x(1);
           nodes(i).updateConfiguration(2)=y(1);
           nodes(i).updateConfiguration(3)=h(1);
       end
    end

    
    %update the dockconfigurations
    for i=1:n
        nodes(i).dockConfiguration=nodes(i).updateConfiguration;
    end
    
    out=nodes;
end

