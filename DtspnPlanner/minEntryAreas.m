function [ nodes ] = minEntryAreas( nodes )
%minEntryAreas Summary of this function goes here
%   Detailed explanation goes here
    epsilon=1e-10;
    n=length(nodes);
    radius=nodes(1).circle.radius;
    speed=nodes(1).dockConfiguration(4);
    
    for i=1:n
        candidates=[];
        vertices=[];
        
        m=length(nodes(i).enclosingNodes);
        if m==1  %contain only one node and is one circle
            nodes(i).entryRegion=nodes(i).circle;
        else %contain many nodes, calculate the common area
            for jj=1:m-1
                for kk=jj+1:m
                    %get intersections between each pair of circles
                    circle1=nodes(i).enclosingNodes(jj).circle;
                    circle2=nodes(i).enclosingNodes(kk).circle;
                    [x,y]=circcirc(circle1.x,circle1.y,circle1.radius,...
                                    circle2.x,circle2.y,circle2.radius);
                    %add intersection points to be candidate common area
                    %enclosing corner
                    if isnan(x(1)) 
                        error('no intersetion point!'); 
                    end
                    
                    if abs(x(1)-x(2))<epsilon && abs(y(1)-y(2))<epsilon
                        candidate_m=ppPoint(x(1),y(1));
                        candidates=[candidates candidate_m];
                    else
                        candidate_m=ppPoint(x(1),y(1));
                        candidates=[candidates candidate_m];
                        
                        candidate_m=ppPoint(x(2),y(2));
                        candidates=[candidates candidate_m];
                    end
                end
            end
            %test if a candidate lies in all circles, if true, it is
            %intersection vertex, otherwise it is not.
            for jj=1:length(candidates)
                flag=true;
                for kk=1:m
                    circle=nodes(i).enclosingNodes(kk).circle;
                    distance=sqrt((candidates(jj).x-circle.x)^2+...
                        (candidates(jj).y-circle.y)^2);
                    if distance>(circle.radius+epsilon)
                        flag=false;
                        break;
                    end
                end
                if flag==true
                    vertices=[vertices candidates(jj)];
                end
            end

                   
            %create arc segments,
            %if only one vertex, then store this vertex
            if length(vertices)==1
                nodes(i).entryRegion=vertices;
            else %multiple vertices, store arc segments connecting vertices 
                %rearrange vertices by counterclockwise, if the number less
                %than 2, retain original order
                if length(vertices)>2
                    for jj=1:length(vertices)
                        x(jj)=vertices(jj).x;
                        y(jj)=vertices(jj).y;
                    end 
                    k=convhull(x,y);
                    vertices=[vertices(k)]; %notice that the number of vertices increases 1
                else % length(vertices)==2
                    vertices=[vertices vertices(1)];
                end
            
                for jj=1:length(vertices)-1
                    [x,y]=circcirc(vertices(jj).x,vertices(jj).y,radius,...
                                vertices(jj+1).x,vertices(jj+1).y,radius);
                    if isnan(x(1)) 
                        error('no intersetion point!'); 
                    end

                    %find a circle traverse two point and with a given radius
                    %the center is on the left side of chord
                    x0=vertices(jj+1).x-vertices(jj).x;
                    y0=vertices(jj+1).y-vertices(jj).y;
                    x1=x(1)-vertices(jj).x;
                    y1=y(1)-vertices(jj).y;
                    if x0*y1-x1*y0>=0
                        circle=ppCircle(x(1),y(1),radius);
                    else
                        circle=ppCircle(x(2),y(2),radius);
                    end

                    nodes(i).entryRegion(jj)=ppSegment(vertices(jj).x,vertices(jj).y,...
                        vertices(jj+1).x,vertices(jj+1).y,circle.x,circle.y,1,speed);
                end
            end
        end
    end %end of for i=1:n
    
end %end of function


