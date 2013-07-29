function [ out ] = alternateIterativeAlgorithm( nodes ,delta, turn_radius)
%ALTERNATEITERATIVEALGORITHM Summary of this function goes here
%   Detailed explanation goes here
Lp=enclideanTourLength(nodes);
nodes=oddStepTSPN(nodes, turn_radius);
Ln=enclideanTourLength(nodes);
i=2;
while (Lp-Ln)>delta
    Lp=Ln;
    if mod(i,2)==0
        nodes=evenStepTSPN(nodes, turn_radius);
    else
        nodes=oddStepTSPN(nodes, turn_radius);
    end
    Ln=enclideanTourLength(nodes);
    i=i+1;
end

out=nodes;
end

function totallength = enclideanTourLength(nodes)
    totallength=0;
    n=length(nodes);
    for i=1:n-1
        totallength=totallength+sqrt((nodes(i+1).dockConfiguration(1)-nodes(i).dockConfiguration(1))^2 ...
                +(nodes(i+1).dockConfiguration(2)-nodes(i).dockConfiguration(2))^2);
    end
    totallength=totallength+sqrt((nodes(1).dockConfiguration(1)-nodes(n).dockConfiguration(1))^2 ...
        +(nodes(1).dockConfiguration(2)-nodes(n).dockConfiguration(2))^2);
end