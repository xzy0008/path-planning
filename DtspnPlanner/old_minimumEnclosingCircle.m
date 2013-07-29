function minCircle = minimumEnclosingCircle( points )
%minimumEnclosingCircle Summary of this function goes here
%   Detailed explanation goes here
    count=length(points);
    for i=1:count
        pos=ceil(rand*count);
        temp=points(i);
        points(i)=points(pos);
        points(pos)=temp;
    end
    boundary=[ppPoint(0,0) ppPoint(0,0) ppPoint(0,0)];
    cxsave = 0;
    cysave = 0;
    radsave = 0;
    [cxsave, cysave, radsave]=mec(points, points.Length, boundary, 0, cxsave, cysave, radsave);
    minCircle = ppCircle(cxsave, cysave, radsave);
end

function [cxsave, cysave, radsave] = mec(points, n, boundary, b, cxsave, cysave, radsave)
    localCircle=ppCircle(0,0,0);
        
    if (b==3) 
        localCircle=calcCircle3(boundary(1), boundary(2), boundary(3));
    elseif (n==1 && b==0)
        localCircle=ppCircle(points(1).X, points(1).Y, 0);
    elseif (n==0 && b==2)
        localCircle=calcCircle2(boundary(1), boundary(2));
    elseif (n==1 && b==1)
        localCircle=calcCircle2(boundary(1), points(1));
    else 
        localCircle = mec(points, n-1, boundary, b);
        if (~pointInCircle(points(n)))
            boundary(b) = points(n);
            b=b+1;
            [cxsave, cysave, radsave] = mec(points, n, boundary, b, cxsave, cysave, radsave);
        end  
    end
    
    cxsave=localCircle.x;
    cysave=localCircle.y;
    radsave=localCircle.radius;
    
end

function bool = pointInCircle(point,circle)
    if (center.X - p.X) * (center.X - p.X) + (center.Y - p.Y) * (center.Y - p.Y) <= radius * radius
        bool=true;
    else 
        bool=false;
    end
end

function circle = calcCircle3(p1,p2,p3)
    p1x=p1.X;
    p1y=p1.Y;
    p2x=p2.X;
    p2y=p2.Y;
    p3x=p3.X;
    p3y=p3.Y;

    a=p2x-p1x;
    b=p2y-p1y;
    c=p3x-p1x;
    d=p3y-p1y;
    e=a*(p2x+p1x)*0.5+b*(p2y+p1y)*0.5;
    f=c*(p3x+p1x)*0.5+d*(p3y+p1y)*0.5;
    det=a*d-b*c;

    cx=(d*e-b*f)/det;
    cy=(-c*e+a*f)/det;
    
    circle=ppCircle(cx, cy, sqrt((p1x-cx)*(p1x-cx)+(p1y-cy)*(p1y-cy)), false, true);
end

function circle = calcCircle2(p1,p2)
    p1x=p1.X;
    p1y=p1.Y;
    p2x=p2.X;
    p2y=p2.Y;

    cx=0.5*(p1x+p2x);
    cy=0.5*(p1y+p2y); 
    
    circle=ppCircle(cx, cy, sqrt((p1x-cx)*(p1x-cx)+(p1y-cy)*(p1y-cy)));
end

function point = ppPoint( x,y )
%ppPoint Summary of this function goes here
%   Detailed explanation goes here

point.x=x;
point.y=y;
end