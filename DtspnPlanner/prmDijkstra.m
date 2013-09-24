function out = prmDijkstra( nodes, turn_radius, samples_per_node )
%UNTITLED1 Summary of this function goes here
%   Detailed explanation goes here
    m=length(nodes);
    n=samples_per_node;
    
    %obtain samples configuration list and V list for dijkstra
    samples = [];
    V=[];
    for i=1:m
        for j=1:n-2
            samples = [samples; [nodes(i).dockConfiguration(1), ...
                nodes(i).dockConfiguration(2), mod2pi(2.5*pi-j*2*pi/n),...
                nodes(i).dockConfiguration(4)]];
            V = [V; [nodes(i).dockConfiguration(1), ...
                    nodes(i).dockConfiguration(2)]];          
        end
        %add AA result(forward and backward) to be candidates
        if i==1
            pos_cur=nodes(i).dockConfiguration(1:2);
            pos_next=nodes(i+1).dockConfiguration(1:2);
            theta=mod2pi(2.5*pi-...
                atan2(pos_next(2)-pos_cur(2),pos_next(1)-pos_cur(1)));
            samples = [samples; [nodes(i).dockConfiguration(1), ...
                nodes(i).dockConfiguration(2), theta,...
                nodes(i).dockConfiguration(4)]];
            V = [V; [nodes(i).dockConfiguration(1), ...
                    nodes(i).dockConfiguration(2)]];

            pos_cur=nodes(m).dockConfiguration(1:2);
            pos_next=nodes(1).dockConfiguration(1:2);
            theta=mod2pi(2.5*pi-...
                atan2(pos_next(2)-pos_cur(2),pos_next(1)-pos_cur(1)));
            samples = [samples; [nodes(i).dockConfiguration(1), ...
                nodes(i).dockConfiguration(2), theta,...
                nodes(i).dockConfiguration(4)]];
            V = [V; [nodes(i).dockConfiguration(1), ...
                    nodes(i).dockConfiguration(2)]];
        elseif i==m
            pos_cur=nodes(i-1).dockConfiguration(1:2);
            pos_next=nodes(i).dockConfiguration(1:2);
            theta=mod2pi(2.5*pi-...
                atan2(pos_next(2)-pos_cur(2),pos_next(1)-pos_cur(1)));
            samples = [samples; [nodes(i).dockConfiguration(1), ...
                nodes(i).dockConfiguration(2), theta,...
                nodes(i).dockConfiguration(4)]];
            V = [V; [nodes(i).dockConfiguration(1), ...
                    nodes(i).dockConfiguration(2)]];

            pos_cur=nodes(m).dockConfiguration(1:2);
            pos_next=nodes(1).dockConfiguration(1:2);
            theta=mod2pi(2.5*pi-...
                atan2(pos_next(2)-pos_cur(2),pos_next(1)-pos_cur(1)));
            samples = [samples; [nodes(i).dockConfiguration(1), ...
                nodes(i).dockConfiguration(2), theta,...
                nodes(i).dockConfiguration(4)]];
            V = [V; [nodes(i).dockConfiguration(1), ...
                    nodes(i).dockConfiguration(2)]];
        else
            pos_cur=nodes(i).dockConfiguration(1:2);
            pos_next=nodes(i+1).dockConfiguration(1:2);
            theta=mod2pi(2.5*pi-...
                atan2(pos_next(2)-pos_cur(2),pos_next(1)-pos_cur(1)));
            samples = [samples; [nodes(i).dockConfiguration(1), ...
                nodes(i).dockConfiguration(2), theta,...
                nodes(i).dockConfiguration(4)]];
            V = [V; [nodes(i).dockConfiguration(1), ...
                    nodes(i).dockConfiguration(2)]]; 
                
            pos_cur=nodes(i-1).dockConfiguration(1:2);
            pos_next=nodes(i).dockConfiguration(1:2);
            theta=mod2pi(2.5*pi-...
                atan2(pos_next(2)-pos_cur(2),pos_next(1)-pos_cur(1)));
            samples = [samples; [nodes(i).dockConfiguration(1), ...
                nodes(i).dockConfiguration(2), theta,...
                nodes(i).dockConfiguration(4)]];
            V = [V; [nodes(i).dockConfiguration(1), ...
                    nodes(i).dockConfiguration(2)]]; 
        end
        
    end
    %append first n sample to the end
    samples=[samples; samples(1:n,:)];
    V=[V; V(1:n,:)];
    m=m+1;
    
    %obtain E3 for dijkstra
    E3=[];
    for ii=1:m-1
        for jj=1:n
            for kk=1:n
                dubinsPath=configurationsToDubinsPath(...
                    [samples((ii-1)*n+jj,:); samples(ii*n+kk,:)],...
                    turn_radius);
                len=0;
                for i=1:length(dubinsPath)
                    len=len+dubinsPath(i).length;
                end
                E3=[E3;[(ii-1)*n+jj,ii*n+kk,len]];
            end
        end
    end
    
    [costs,paths] = dijkstra(V,E3,1:n,(m-1)*n+1:m*n, 1);
    
    costs_diag=diag(costs);
    %paths_diag=diag(paths);
    paths_diag=paths(1:size(paths,1)+1:end);
    
    [min_length,index_pos]=min(costs_diag);
    path_index=paths_diag(index_pos);
    
    path_index=cell2mat(path_index);
    
    for i=1:length(nodes)
        nodes(i).dockConfiguration(3)=samples(path_index(i),3);
    end
    
    out=nodes;
end

function z = fmodr(x,y)
    z=x-y*floor(x/y);
end 

function z =mod2pi(theta)
    z=fmodr(theta,2*pi);
end
