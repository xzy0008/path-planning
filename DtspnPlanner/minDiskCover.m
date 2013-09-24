function [ out_nodes ] = minDiskCover( in_nodes, sensor_radius )
%minDiskCover Summary of this function goes here
%   Detailed explanation goes here
    T=[]; out_nodes=[];
    n=length(in_nodes);
    for i=1:n
        T=[T in_nodes(i)];
        disk_c=minEnclosingCircle(T);
        if disk_c.radius<=sensor_radius
            disk_p=disk_c;
        else 
            dock_config=[disk_p.x,disk_p.y,0,in_nodes(1).dockConfiguration(4),in_nodes(1).dockConfiguration(5)];
            disk_p.radius=sensor_radius;
            out_nodes=[out_nodes ppNode(dock_config,disk_p,T(1:end-1),(length(T)~=2))];
            
            T=[];
            T=[T in_nodes(i)];
            disk_p=minEnclosingCircle(T);
        end
    end
    
    dock_config=[disk_p.x,disk_p.y,0,in_nodes(1).dockConfiguration(4),in_nodes(1).dockConfiguration(5)];
    disk_p.radius=sensor_radius;
    out_nodes=[out_nodes ppNode(dock_config,disk_p,T,(length(T)~=1))];
    

end

% function [ nodes ] = minDiskCover( configurations, sensor_radius )
% %minDiskCover Summary of this function goes here
% %   Detailed explanation goes here
%     T=[]; nodes=[];
%     n=length(configurations);
%     for i=1:n
%         T=[T configurations(i)];
%         disk_c=minEnclosingCircle(T);
%         if disk_c.radius<=sensor_radius
%             disk_p=disk_c;
%         else 
%             dock_config=[disk_p.x,disk_p.y,0,configurations(1).speed];
%             disk_p.radius=sensor_radius;
%             nodes=[nodes ppNode(dock_config,disk_p,T(1:end-1),(length(T)~=2))];
%             
%             T=[];
%             T=[T configurations(i)];
%             disk_p=minEnclosingCircle(T);
%         end
%     end
%     
%     dock_config=[disk_p.x,disk_p.y,0,configurations(1).speed];
%     disk_p.radius=sensor_radius;
%     nodes=[nodes ppNode(dock_config,disk_p,T,(length(T)~=1))];
%     
% 
% end