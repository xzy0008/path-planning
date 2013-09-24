clc; clear;

boundingPolygon=ppPolygon([10 0 45 30],[0 30 35 0]);
pathSpeed=0.75;    % speed to run path at (m/s)
minRadius=1;    % min distance between passes
spacing=2;      % 

flipSide=true;	% start at opposite end of field
plotResults=false;

total=[];
for i=1:180
    startDirection=i*pi/180;   % direction to run 1st path (measured clockwise from north) 
    tt=ppSurveyPathPolygon(boundingPolygon, startDirection, minRadius, spacing, pathSpeed, flipSide, plotResults);
    total=[total tt];
end

figure;
plot(total);




%statistic 
bb=boundingPolygon;
bb.x(5)=bb.x(1);
bb.y(5)=bb.y(1);
for i=1:4
    tt = sqrt((bb.x(i)-bb.x(i+1))^2+(bb.y(i)-bb.y(i+1))^2)
    angle = pi/2-atan2((bb.y(i)-bb.y(i+1)),(bb.x(i)-bb.x(i+1)));
    if angle >pi
        angle = angle -pi;
    end
    angle = angle/pi*180

end