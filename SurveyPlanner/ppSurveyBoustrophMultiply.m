function out = ppSurveyBoustrophMultiply(startPoints, endPoints, startDirections, minRadius, pathSpeed, eastRef, northRef)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Writen by: Xin Yu
%%%find optimal survey directions by Traveling Salesman Problem
%%%with Lin kernihan heuristic
%%%cost matrix generated by endpoints of each pass 
%%%refer to D.D.Bochtis "The vehicle routing problem in field logistics part I" 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numPasses=length(startPoints.x);

for i=1:numPasses
    if mod(i,2)==1
        configurations(2*i-1).x=startPoints.x(i)+eastRef;
        configurations(2*i-1).y=startPoints.y(i)+northRef;
        configurations(2*i-1).heading=startDirections(i);
        configurations(2*i-1).speed=pathSpeed;

        configurations(2*i).x=endPoints.x(i)+eastRef;
        configurations(2*i).y=endPoints.y(i)+northRef;
        configurations(2*i).heading=startDirections(i);
        configurations(2*i).speed=pathSpeed;
    else
        configurations(2*i-1).x=endPoints.x(i)+eastRef;
        configurations(2*i-1).y=endPoints.y(i)+northRef;
        configurations(2*i-1).heading=startDirections(i)+pi;
        configurations(2*i-1).speed=pathSpeed;

        configurations(2*i).x=startPoints.x(i)+eastRef;
        configurations(2*i).y=startPoints.y(i)+northRef;
        configurations(2*i).heading=startDirections(i)+pi;
        configurations(2*i).speed=pathSpeed;
    end
end


% configurations=[configurations configurations(1)];

out=[configurations.x; configurations.y; configurations.heading; configurations.speed]'; 

end