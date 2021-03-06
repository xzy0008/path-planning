function [ out ] = oddStepTSPN( nodes, turn_radius )
%ODDSTEPTSPN Summary of this function goes here
%   Detailed explanation goes here
    n=length(nodes);
    %test intersection between dubins path (i to i+1) and circle (i+1), update
    %dockconfiguration of node i+1
    for i=1:n-1
       if nodes(i+1).flag_combine==true
           if turn_radius>0 %dubins path
                nodes(i+1).updateConfiguration=nodes(i+1).dockConfiguration;
           else %line path
               initialConfig=nodes(i).dockConfiguration;
               terminalConfig=nodes(i+1).dockConfiguration;
               path=ppSegment(initialConfig(1),initialConfig(2),terminalConfig(1),terminalConfig(2),...
                                initialConfig(1),initialConfig(2),2,initialConfig(4));
               %obtain the intersection points
               region=nodes(i+1).entryRegion;
               [x,y,h]=segmentRegionIntersection(path,region);
               %update the first intersection point configuration
               if (length(x)==1 && ~isnan(x)) || (length(x)>=2)
                   nodes(i+1).updateConfiguration(1)=x(1);
                   nodes(i+1).updateConfiguration(2)=y(1);
                   nodes(i+1).updateConfiguration(3)=h(1);
               end
           end
       else
           if turn_radius>0 %dubins path
               initialConfig=nodes(i).dockConfiguration;
               terminalConfig=nodes(i+1).dockConfiguration;
               path=configurationsToDubinsPath([initialConfig;terminalConfig],turn_radius);
               %obtain the intersection points
               circle=nodes(i+1).circle;
               [x,y,h]=dubinsCircleIntersection(path,circle);
           else %line path
               initialConfig=nodes(i).dockConfiguration;
               terminalConfig=nodes(i+1).dockConfiguration;
               path=ppSegment(initialConfig(1),initialConfig(2),terminalConfig(1),terminalConfig(2),...
                                initialConfig(1),initialConfig(2),2,initialConfig(4));
               %obtain the intersection points
               region=nodes(i+1).entryRegion;
               [x,y,h]=segmentRegionIntersection(path,region);
           end

           %update the first intersection point configuration
           if (length(x)==1 && ~isnan(x)) || (length(x)>=2)
               nodes(i+1).updateConfiguration(1)=x(1);
               nodes(i+1).updateConfiguration(2)=y(1);
               nodes(i+1).updateConfiguration(3)=h(1);
           end
       end
    end
    %test intersection between dubins path (n to 1) and circle (1), update
    %dockconfiguration of node 1
    if nodes(1).flag_combine
        if turn_radius>0 %dubins path
            nodes(1).updateConfiguration=nodes(1).dockConfiguration;
        else %line path
           initialConfig=nodes(n).dockConfiguration;
           terminalConfig=nodes(1).dockConfiguration;
           path=ppSegment(initialConfig(1),initialConfig(2),terminalConfig(1),terminalConfig(2),...
                            initialConfig(1),initialConfig(2),2,initialConfig(4));
           %obtain the intersection points
           region=nodes(1).entryRegion;
           [x,y,h]=segmentRegionIntersection(path,region);
           %update the first intersection point configuration
           if (length(x)==1 && ~isnan(x)) || (length(x)>=2)
               nodes(1).updateConfiguration(1)=x(1);
               nodes(1).updateConfiguration(2)=y(1);
               nodes(1).updateConfiguration(3)=h(1);
           end
        end
    else
        if turn_radius>0 %dubins path
            initialConfig=nodes(n).dockConfiguration;
            terminalConfig=nodes(1).dockConfiguration;
            path=configurationsToDubinsPath([initialConfig;terminalConfig],turn_radius);
            %obtain the intersection points
            circle=nodes(1).circle;
            [x,y,h]=dubinsCircleIntersection(path,circle);
        else %line path
            initialConfig=nodes(n).dockConfiguration;
            terminalConfig=nodes(1).dockConfiguration;
            path=ppSegment(initialConfig(1),initialConfig(2),terminalConfig(1),terminalConfig(2),...
                            initialConfig(1),initialConfig(2),2,initialConfig(4));
            %obtain the intersection points
            region=nodes(1).entryRegion;
            [x,y,h]=segmentRegionIntersection(path,region);
        end

        %update the first intersection point configuration
        if (length(x)==1 && ~isnan(x)) || (length(x)>=2)
            nodes(1).updateConfiguration(1)=x(1);
            nodes(1).updateConfiguration(2)=y(1);
            nodes(1).updateConfiguration(3)=h(1);
        end
    end
    
    %update the dockconfigurations
    for i=1:n
        nodes(i).dockConfiguration=nodes(i).updateConfiguration;
    end
    
    out=nodes;
end

