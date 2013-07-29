function [ out ] = evenStepTSPN1( nodes, turn_radius )
%EVENSTEPTSPN Summary of this function goes here
%   Detailed explanation goes here
    n=length(nodes);
    %test intersection between dubins path (i to i+1) and circle (i), update
    %dockconfiguration of node i
    for i=2:2:n-1
       initialConfig=nodes(i).dockConfiguration;
       terminalConfig=nodes(i+1).dockConfiguration;
       path=configurationsToDubinsPath([initialConfig;terminalConfig],turn_radius);
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
       
       circle=nodes(i+1).circle;
       [x,y,h]=dubinsCircleIntersection(path,circle);
       %update the first intersection point configuration
       if (length(x)==1 && ~isnan(x)) || (length(x)>=2)
           nodes(i+1).updateConfiguration(1)=x(1);
           nodes(i+1).updateConfiguration(2)=y(1);
           nodes(i+1).updateConfiguration(3)=h(1);
       end

    end
    %test intersection between dubins path (n to 1) and circle (n), update
    %dockconfiguration of node n
    initialConfig=nodes(n).dockConfiguration;
    terminalConfig=nodes(1).dockConfiguration;
    path=configurationsToDubinsPath([initialConfig;terminalConfig],turn_radius);
    circle=nodes(n).circle;
    [x,y,h]=dubinsCircleIntersection(path,circle);
    %update the second intersection point configuration
    if length(x)>=2
        nodes(n).updateConfiguration(1)=x(end);
        nodes(n).updateConfiguration(2)=y(end);
        nodes(n).updateConfiguration(3)=h(end);
    elseif ~isnan(x) %in case test failed to get two intersection point due to the flowt precision
        nodes(n).updateConfiguration(1)=x(1);
        nodes(n).updateConfiguration(2)=y(1);
        nodes(n).updateConfiguration(3)=h(1);        
    end
    
    circle=nodes(1).circle;
    [x,y,h]=dubinsCircleIntersection(path,circle);
    %update the first intersection point configuration
    if (length(x)==1 && ~isnan(x)) || (length(x)>=2)
        nodes(1).updateConfiguration(1)=x(1);
        nodes(1).updateConfiguration(2)=y(1);
        nodes(1).updateConfiguration(3)=h(1);
    end
    
    %update the dockconfigurations
    for i=1:n
        nodes(i).dockConfiguration=nodes(i).updateConfiguration;
    end
    
    out=nodes;
end

