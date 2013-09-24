function [ xout,yout,hout ] = dubinsCircleIntersection( path, circle )
%DUBINSCIRCLEINTERSECTION Summary of this function goes here
%   Detailed explanation goes here
xout=[];
yout=[];
hout=[];

for i=1:length(path)
   % test the segment is a line segment or an arc
   % a line segment if the ccw is 2
   if path(i).ccw == 2 %line segment
       %check to see if line is verticle
       if (abs(path(i).startEast-path(i).endEast)<0.001)%line is verticle
           [x,y]=linecirc(inf,path(i).startEast,circle.x,circle.y,circle.radius);
       else %line is not verticle
           slope = (path(i).endNorth-path(i).startNorth)/(path(i).endEast-path(i).startEast);
           intercept_y=path(i).startNorth-slope*path(i).startEast;
           [x,y]=linecirc(slope,intercept_y,circle.x,circle.y,circle.radius);
       end
       
       if length(x)==1
           %check to see if the intersection point lies between segment
           x_min=min(path(i).startEast,path(i).endEast);
           x_max=max(path(i).startEast,path(i).endEast);
           y_min=min(path(i).startNorth,path(i).endNorth);
           y_max=max(path(i).startNorth,path(i).endNorth);
           if (x>=x_min && x<=x_max && y>=y_min && y<=y_max)
               xout=[xout x];
               yout=[yout y];
               hout=[hout path(i).heading];
           end
       elseif length(x)==2
           %check to see if the first intersection point lies between segment
           x_min=min(path(i).startEast,path(i).endEast);
           x_max=max(path(i).startEast,path(i).endEast);
           y_min=min(path(i).startNorth,path(i).endNorth);
           y_max=max(path(i).startNorth,path(i).endNorth);
           if (x(1)>=x_min && x(1)<=x_max && y(1)>=y_min && y(1)<=y_max)
               xout=[xout x(1)];
               yout=[yout y(1)];
               hout=[hout path(i).heading];
           end
           %check to see if the second intersection point lies between segment           
           x_min=min(path(i).startEast,path(i).endEast);
           x_max=max(path(i).startEast,path(i).endEast);
           y_min=min(path(i).startNorth,path(i).endNorth);
           y_max=max(path(i).startNorth,path(i).endNorth);
           if (x(2)>=x_min && x(2)<=x_max && y(2)>=y_min && y(2)<=y_max)
               xout=[xout x(2)];
               yout=[yout y(2)];
               hout=[hout path(i).heading];
           end
       else
           %no intersetion between the dubins arc and circle
       end
           
   elseif path(i).ccw == 1 %counterclockwise
       r_dubins=sqrt((path(i).centerEast-path(i).startEast)^2+(path(i).centerNorth-path(i).startNorth)^2);
       [x,y]=circcirc(path(i).centerEast,path(i).centerNorth,r_dubins,circle.x,circle.y,circle.radius);
       
       if length(x)==1
           x0=x-path(i).startEast;
           y0=y-path(i).startNorth;
           x1=path(i).endEast-path(i).startEast;
           y1=path(i).endNorth-path(i).startNorth;
           %turn cartesian coordinate angle to +pi/2
           theta=mod(atan2(x-path(i).centerEast,y-path(i).centerNorth)+2*pi,2*pi);
           heading=mod(theta-pi/2,2*pi);
           %check to see if the intersection point lies on the arc
           if x0*y1-x1*y0 >= 0 %lie on the arc, cross product
               xout=[xout x];
               yout=[yout y];
               hout=[hout heading];
           end
           
       elseif length(x)==2
           %check the first intersection point
           x0=x(1)-path(i).startEast;
           y0=y(1)-path(i).startNorth;
           x1=path(i).endEast-path(i).startEast;
           y1=path(i).endNorth-path(i).startNorth;
           %turn cartesian coordinate angle to +pi/2
           theta=mod(atan2(x(1)-path(i).centerEast,y(1)-path(i).centerNorth)+2*pi,2*pi);
           heading=mod(theta-pi/2,2*pi);
           %check to see if the intersection point lies on the arc
           if x0*y1-x1*y0 >= 0 %lie on the arc
               xout=[xout x(1)];
               yout=[yout y(1)];
               hout=[hout heading];
           end
           
           %chech the second intersection point
           x0=x(2)-path(i).startEast;
           y0=y(2)-path(i).startNorth;
           x1=path(i).endEast-path(i).startEast;
           y1=path(i).endNorth-path(i).startNorth;
           %turn cartesian coordinate angle to +pi/2
           theta=mod(atan2(x(2)-path(i).centerEast,y(2)-path(i).centerNorth)+2*pi,2*pi);
           heading=mod(theta-pi/2,2*pi);
           %check to see if the intersection point lies on the arc
           if x0*y1-x1*y0 >= 0 %lie on the arc
               xout=[xout x(2)];
               yout=[yout y(2)];
               hout=[hout heading];
           end
       else 
           %no intersetion between the dubins arc and circle
       end
       
   elseif path(i).ccw == 0 %clockwise
       r_dubins=sqrt((path(i).centerEast-path(i).startEast)^2+(path(i).centerNorth-path(i).startNorth)^2);
       [x,y]=circcirc(path(i).centerEast,path(i).centerNorth,r_dubins,circle.x,circle.y,circle.radius);
       
       if length(x)==1
           x0=x-path(i).endEast;
           y0=y-path(i).endNorth;
           x1=path(i).startEast-path(i).endEast;
           y1=path(i).startNorth-path(i).endNorth;
           %turn cartesian coordinate angle to +pi/2
           theta=mod(atan2(x-path(i).centerEast,y-path(i).centerNorth)+2*pi,2*pi);
           heading=mod(theta+pi/2,2*pi);
           %check to see if the intersection point lies on the arc
           if x0*y1-x1*y0 >= 0 %lie on the arc
               xout=[xout x];
               yout=[yout y];
               hout=[hout heading];
           end
           
       elseif length(x)==2
           %check the first intersection point
           x0=x(1)-path(i).endEast;
           y0=y(1)-path(i).endNorth;
           x1=path(i).startEast-path(i).endEast;
           y1=path(i).startNorth-path(i).endNorth;
           %turn cartesian coordinate angle to +pi/2
           theta=mod(atan2(x(1)-path(i).centerEast,y(1)-path(i).centerNorth)+2*pi,2*pi);
           heading=mod(theta+pi/2,2*pi);
           %check to see if the intersection point lies on the arc
           if x0*y1-x1*y0 >= 0 %lie on the arc
               xout=[xout x(1)];
               yout=[yout y(1)];
               hout=[hout heading];
           end
           
           %chech the second intersection point
           x0=x(2)-path(i).endEast;
           y0=y(2)-path(i).endNorth;
           x1=path(i).startEast-path(i).endEast;
           y1=path(i).startNorth-path(i).endNorth;
           %turn cartesian coordinate angle to +pi/2
           theta=mod(atan2(x(2)-path(i).centerEast,y(2)-path(i).centerNorth)+2*pi,2*pi);
           heading=mod(theta+pi/2,2*pi);
           %check to see if the intersection point lies on the arc
           if x0*y1-x1*y0 >= 0 %lie on the arc
               xout=[xout x(2)];
               yout=[yout y(2)];
               hout=[hout heading];
           end
       else 
           %no intersetion between the dubins arc and circle
       end           
           
   end
       
end

if isempty(xout)
    xout=NaN;
    yout=NaN;
    hout=NaN;
end


