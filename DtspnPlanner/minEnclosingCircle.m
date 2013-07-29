function circle = minEnclosingCircle( nodes )
%minEnclosingCircle Summary of this function goes here
%   Detailed explanation goes here
    n=length(nodes);
    for i=1:n
        x(i)=nodes(i).dockConfiguration(1);
        y(i)=nodes(i).dockConfiguration(2);
    end
    
    [center, radius]=minboundcircle(x,y,true);
    circle=ppCircle(center(1),center(2),radius);
end