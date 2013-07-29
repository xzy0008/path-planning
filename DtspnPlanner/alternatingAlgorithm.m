function out = alternatingAlgorithm( nodes, turn_radius )
%UNTITLED1 Summary of this function goes here
%   Detailed explanation goes here
    n=length(nodes);
    pos_cur=nodes(1).dockConfiguration(1:2);
    pos_next=nodes(2).dockConfiguration(1:2);
    nodes(1).dockConfiguration(3)=mod2pi(2.5*pi-...
        atan2(pos_next(2)-pos_cur(2),pos_next(1)-pos_cur(1)));
    for i=2:n-1
        if mod(i,2)==0
            nodes(i).dockConfiguration(3)=nodes(i-1).dockConfiguration(3);
        else
            pos_cur=nodes(i).dockConfiguration(1:2);
            pos_next=nodes(i+1).dockConfiguration(1:2);
            nodes(i).dockConfiguration(3)=mod2pi(2.5*pi-...
                atan2(pos_next(2)-pos_cur(2),pos_next(1)-pos_cur(1)));
        end
    end

    if mod(n,2)==0
        nodes(n).dockConfiguration(3)=nodes(n-1).dockConfiguration(3);
    else
        pos_cur=nodes(n).dockConfiguration(1:2);
        pos_next=nodes(1).dockConfiguration(1:2);
        nodes(n).dockConfiguration(3)=mod2pi(2.5*pi-...
            atan2(pos_next(2)-pos_cur(2),pos_next(1)-pos_cur(1)));
    end
    
    out=nodes;
end

function z = fmodr(x,y)
    z=x-y*floor(x/y);
end 

function z =mod2pi(theta)
    z=fmodr(theta,2*pi);
end