function [ out ] = evenStepTSPN( nodes, turn_radius )
%EVENSTEPTSPN Summary of this function goes here
%   Detailed explanation goes here
    n=length(nodes);
    %test intersection between dubins path (i to i+1) and circle (i), update
    %dockconfiguration of node i
    for i=1:n-1
       if nodes(i).flag_combine==true
           if turn_radius>0 %dubins path
                nodes(i).updateConfiguration=nodes(i).dockConfiguration;
           else %line path
               initialConfig=nodes(i).dockConfiguration;
               terminalConfig=nodes(i+1).dockConfiguration;
               path=ppSegment(initialConfig(1),initialConfig(2),terminalConfig(1),terminalConfig(2),...
                                initialConfig(1),initialConfig(2),2,initialConfig(4));
               %obtain the intersection points
               region=nodes(i).entryRegion;
               [x,y,h]=segmentRegionIntersection(path,region);
               %update the second intersection point configuration
               if length(x)>=2
                   nodes(i).updateConfiguration(1)=x(2);
                   nodes(i).updateConfiguration(2)=y(2);
                   nodes(i).updateConfiguration(3)=h(2);
               elseif ~isnan(x) %in case test failed to get two intersection point due to the flout precision
                   nodes(i).updateConfiguration(1)=x(1);
                   nodes(i).updateConfiguration(2)=y(1);
                   nodes(i).updateConfiguration(3)=h(1);
               end
           end
       else
           if turn_radius>0 %dubins path
               initialConfig=nodes(i).dockConfiguration;
               terminalConfig=nodes(i+1).dockConfiguration;
               path=configurationsToDubinsPath([initialConfig;terminalConfig],turn_radius);
               %obtain the intersection points
               circle=nodes(i).circle;
               [x,y,h]=dubinsCircleIntersection(path,circle);
           else %line path
               initialConfig=nodes(i).dockConfiguration;
               terminalConfig=nodes(i+1).dockConfiguration;
               path=ppSegment(initialConfig(1),initialConfig(2),terminalConfig(1),terminalConfig(2),...
                                initialConfig(1),initialConfig(2),2,initialConfig(4));
               %obtain the intersection points
               region=nodes(i).entryRegion;
               [x,y,h]=segmentRegionIntersection(path,region);
           end

           %update the second intersection point configuration
           if length(x)>=2
               nodes(i).updateConfiguration(1)=x(2);
               nodes(i).updateConfiguration(2)=y(2);
               nodes(i).updateConfiguration(3)=h(2);
           elseif ~isnan(x) %in case test failed to get two intersection point due to the flout precision
               nodes(i).updateConfiguration(1)=x(1);
               nodes(i).updateConfiguration(2)=y(1);
               nodes(i).updateConfiguration(3)=h(1);
           end
       end
    end
    %test intersection between dubins path (n to 1) and circle (n), update
    %dockconfiguration of node n
    if nodes(n).flag_combine
        if turn_radius>0 %dubins path
            nodes(n).updateConfiguration=nodes(n).dockConfiguration;
        else %line path
           initialConfig=nodes(n).dockConfiguration;
           terminalConfig=nodes(1).dockConfiguration;
           path=ppSegment(initialConfig(1),initialConfig(2),terminalConfig(1),terminalConfig(2),...
                            initialConfig(1),initialConfig(2),2,initialConfig(4));
           %obtain the intersection points
           region=nodes(n).entryRegion;
           [x,y,h]=segmentRegionIntersection(path,region);
           %update the second intersection point configuration
           if length(x)>=2
               nodes(n).updateConfiguration(1)=x(2);
               nodes(n).updateConfiguration(2)=y(2);
               nodes(n).updateConfiguration(3)=h(2);
           elseif ~isnan(x) %in case test failed to get two intersection point due to the flout precision
               nodes(n).updateConfiguration(1)=x(1);
               nodes(n).updateConfiguration(2)=y(1);
               nodes(n).updateConfiguration(3)=h(1);
           end
        end
    else
        if turn_radius>0 %dubins path
            initialConfig=nodes(n).dockConfiguration;
            terminalConfig=nodes(1).dockConfiguration;
            path=configurationsToDubinsPath([initialConfig;terminalConfig],turn_radius);
            %obtain the intersection points
            circle=nodes(n).circle;
            [x,y,h]=dubinsCircleIntersection(path,circle);
        else %line path
            initialConfig=nodes(n).dockConfiguration;
            terminalConfig=nodes(1).dockConfiguration;
            path=ppSegment(initialConfig(1),initialConfig(2),terminalConfig(1),terminalConfig(2),...
                            initialConfig(1),initialConfig(2),2,initialConfig(4));
           %obtain the intersection points
           region=nodes(n).entryRegion;
           [x,y,h]=segmentRegionIntersection(path,region);
        end

        %update the second intersection point configuration
        if length(x)>=2
            nodes(n).updateConfiguration(1)=x(2);
            nodes(n).updateConfiguration(2)=y(2);
            nodes(n).updateConfiguration(3)=h(2);
        elseif ~isnan(x) %in case test failed to get two intersection point due to the flowt precision
            nodes(n).updateConfiguration(1)=x(1);
            nodes(n).updateConfiguration(2)=y(1);
            nodes(n).updateConfiguration(3)=h(1);        
        end
    end
    
    %update the dockconfigurations
    for i=1:n
        nodes(i).dockConfiguration=nodes(i).updateConfiguration;
    end
    
    out=nodes;
end

