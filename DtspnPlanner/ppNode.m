function [ out ] = ppNode( dock_conf, circle, enc_nodes, flag_combine)
%PPNODE Summary of this function goes here
%   Detailed explanation goes here
    if nargin==3
        flag_combine=false;
    end
    
    out.dockConfiguration=dock_conf;
    out.updateConfiguration=dock_conf;
    out.circle=circle;
    out.enclosingNodes=enc_nodes;
    out.flag_combine=flag_combine;
end

