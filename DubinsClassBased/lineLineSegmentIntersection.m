% function out = lineLineSegmentIntersection(line, linesegment)
% 
% m=line.a;
% c=line.b;
% 
% x1=linesegment.start.x;
% y1=linesegment.start.y;
% x2=linesegment.end.x;
% y2=linesegment.end.y;
% 
% t=(c-y1+m*x1)/(y2-y1+m*(x1-x2));
% if (t>=0 && t<=1)
%     out.found=true;
%     out.x=x1+(x2-x1)*t;
%     out.y=y1+(y2-y1)*t;
% else
%     out.found=false;
%     out.x=NaN;
%     out.y=NaN;
% end
% 
% end

function [intersect x y] = lineLineSegmentIntersection(line, linesegment)

m=line.a;
c=line.b;

x1=linesegment.start.x;
y1=linesegment.start.y;
x2=linesegment.end.x;
y2=linesegment.end.y;

t=(c-y1+m*x1)/(y2-y1+m*(x1-x2));
if (t>=0 && t<=1)
    intersect=1;
    x=x1+(x2-x1)*t;
    y=y1+(y2-y1)*t;
else
    intersect=-1;
    x=NaN;
    y=NaN;
end

end