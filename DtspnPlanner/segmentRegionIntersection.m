function [ xout,yout,hout ] = segmentRegionIntersection( line,arcs )
%segmentRegionIntersection Summary of this function goes here
%   Detailed explanation goes here
xout=[];
yout=[];
hout=[];
epsilon=1e-10;
if line.ccw~=2
    error('not a line!');
end

for i=1:length(arcs)
    if strcmp(arcs(i).name,'segment')
       r_arc=sqrt((arcs(i).centerEast-arcs(i).startEast)^2+(arcs(i).centerNorth-arcs(i).startNorth)^2);

       if (abs(line.startEast-line.endEast)<0.001)%line is verticle
           [x,y]=linecirc(inf,line.startEast,arcs(i).centerEast,arcs(i).centerNorth,r_arc);
       else %line is not verticle
           slope = (line.endNorth-line.startNorth)/(line.endEast-line.startEast);
           intercept_y=line.startNorth-slope*line.startEast;
           [x,y]=linecirc(slope,intercept_y,arcs(i).centerEast,arcs(i).centerNorth,r_arc);
       end
       
       %check to see if the intersection point lies on the line segment
       x_min_line=min(line.startEast,line.endEast)-epsilon;
       x_max_line=max(line.startEast,line.endEast)+epsilon;
       y_min_line=min(line.startNorth,line.endNorth)-epsilon;
       y_max_line=max(line.startNorth,line.endNorth)+epsilon;

       %check to see if the 1st intersection point lies on the arc segment
       x0_arc=x(1)-arcs(i).startEast;
       y0_arc=y(1)-arcs(i).startNorth;
       x1_arc=arcs(i).endEast-arcs(i).startEast;
       y1_arc=arcs(i).endNorth-arcs(i).startNorth;  
       %check the 1st intersetion point
       if (x(1)>=x_min_line && x(1)<=x_max_line && y(1)>=y_min_line && y(1)<=y_max_line) ...
           && (x0_arc*y1_arc-x1_arc*y0_arc >= 0)
           xout=[xout x(1)];
           yout=[yout y(1)];
           hout=[hout line.heading];
       end

       %check to see if the 2nd intersection point lies on the arc segment
       x0_arc=x(2)-arcs(i).startEast;
       y0_arc=y(2)-arcs(i).startNorth;
       x1_arc=arcs(i).endEast-arcs(i).startEast;
       y1_arc=arcs(i).endNorth-arcs(i).startNorth;
       %check the 2nd intersetion point
       if (x(2)>=x_min_line && x(2)<=x_max_line && y(2)>=y_min_line && y(2)<=y_max_line) ...
           && (x0_arc*y1_arc-x1_arc*y0_arc >= 0)
           xout=[xout x(2)];
           yout=[yout y(2)];
           hout=[hout line.heading];
       end
    elseif strcmp(arcs(i).name,'point')
       xout=[xout arcs(i).x];
       yout=[yout arcs(i).y];
       hout=[hout line.heading];
    elseif strcmp(arcs(i).name,'circle')
       if (abs(line.startEast-line.endEast)<0.001)%line is verticle
           [x,y]=linecirc(inf,line.startEast,arcs(i).x,arcs(i).y,arcs(i).radius);
       else %line is not verticle
           slope = (line.endNorth-line.startNorth)/(line.endEast-line.startEast);
           intercept_y=line.startNorth-slope*line.startEast;
           [x,y]=linecirc(slope,intercept_y,arcs(i).x,arcs(i).y,arcs(i).radius);
       end
       
       %check to see if the intersection point lies on the line segment
       x_min_line=min(line.startEast,line.endEast)-epsilon;
       x_max_line=max(line.startEast,line.endEast)+epsilon;
       y_min_line=min(line.startNorth,line.endNorth)-epsilon;
       y_max_line=max(line.startNorth,line.endNorth)+epsilon;
       
       %check the 1st intersetion point
       if (x(1)>=x_min_line && x(1)<=x_max_line && y(1)>=y_min_line && y(1)<=y_max_line)
           xout=[xout x(1)];
           yout=[yout y(1)];
           hout=[hout line.heading];
       end

       %check the 2nd intersetion point
       if (x(2)>=x_min_line && x(2)<=x_max_line && y(2)>=y_min_line && y(2)<=y_max_line)
           xout=[xout x(2)];
           yout=[yout y(2)];
           hout=[hout line.heading];
       end
    else
       %other types, should not be here
       error('other types, should not be here!');
    end
end

%sort the result points 
if abs(line.startEast-line.endEast)>epsilon
    if line.startEast<line.endEast
        [xout,k]=sort(xout,'ascend');
        yout=yout(k);
        hout=hout(k);
    else
        [xout,k]=sort(xout,'descend');
        yout=yout(k);
        hout=hout(k);
    end
else
    if line.startNorth<line.endNorth
        [yout,k]=sort(yout,'ascend');
        xout=xout(k);
        hout=hout(k);
    else
        [yout,k]=sort(yout,'descend');
        xout=xout(k);
        hout=hout(k);
    end
end
    

if isempty(xout)
    xout=NaN;
    yout=NaN;
    hout=NaN;
end