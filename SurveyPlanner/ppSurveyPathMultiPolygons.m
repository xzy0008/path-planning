function totalLength=ppSurveyPathMultiPolygons(boundingPolygons, startDirection, minRadius, spacing, pathSpeed, flipSide, plotResults)
%PPSURVEYPATH generates a path to be used for surveying a field
%
%   ppSurveyPath(boundingPolygon, startDirection, minRadius, spacing,
%                pathSpeed, flipSide, plotResults)
%       - boundingPolygon = ppPolygon that defines boundary of field
%       - startDirection = initial direction of travel in radians measured
%           from north.
%       - minRadius = minimum turning radius (m)
%       - spacing = spacing between passes (m)
%       - pathSpeed = speed of each path segment
%       - flipSide = swaps side of field that path starts on
%
%   Output: an array of configurations that can then be used to generate a
%      path.
%          Ex: [e1 n1 h1 s1; e2 n2 h2 s2; ... ]
%           where (ek,nk) is the east-north coordinate and hk is the
%           heading
%
%   Modified from ppSurveyPath to allow arbitrary number of vertices to
%   define grid - must be a convex polygon though
%
% written by: David Hodo - 2008 - hododav@auburn.edu

%    
%       2------------------------3
%       /                       /
%      /                       /
%     /                       /   
%    /                       /
%   1-----------------------4
%

clc;
%% check input arguments

if (nargin==0)
%     boundingPolygons(1)=ppPolygon([50 50 74 74],[60 100 100 60]);
%     boundingPolygons(2)=ppPolygon([75.2 75.2 121.2 121.2],[70 90 90 70]);
%     boundingPolygons(3)=ppPolygon([120 120 144 144],[60 100 100 60]);

    boundingPolygons(1)=ppPolygon([54.8 54.8 107.6 107.6],[60 160 160 60]);
    boundingPolygons(2)=ppPolygon([107.6 107.6 126.8 126.8],[120 160 160 120]);
    boundingPolygons(3)=ppPolygon([107.6 107.6 126.8 126.8],[60 90 90 60]);

%     boundingPolygons(1)=ppPolygon([10 10 60 60 30],[10 60 60 10 20]);
%     boundingPolygons(2)=ppPolygon([10 10 30 60 60],[-50 10 0 10 -50]);
%     boundingPolygons(3)=ppPolygon([0 0 9 9],[-50 60 60 -50]);
%     boundingPolygons(4)=ppPolygon([61 61 70 70],[-50 60 60 -50]);
%     boundingPolygons(5)=ppPolygon([120 120 280 280],[100 170 170 100]);
%     boundingPolygons(6)=ppPolygon([280 350 350 280],[60 60 260 260]);
       
    pathSpeed=0.75;    % speed to run path at (m/s)
    minRadius=6;    % min distance between passes
    spacing=2.4;      % 
    startDirections(1)=0*pi/180;   % direction to run 1st path (measured clockwise from north) 
    startDirections(2)=0*pi/180;
    startDirections(3)=0*pi/180;

%     startDirections(1)=0*pi/180;   % direction to run 1st path (measured clockwise from north) 
%     startDirections(2)=180*pi/180;
%     startDirections(3)=0*pi/180;
%     startDirections(4)=0*pi/180;   % direction to run 1st path (measured clockwise from north) 
%     startDirections(5)=90*pi/180;
%     startDirections(6)=0*pi/180;

    flipSide=false;	% start at opposite end of field
elseif (nargin==6)
end


%% convert from east, north, down to XYZ coordinate system
% define x-y coordinate system that is centered at the first corner passed
% in and whose x axis points in the direction given in startDirection
startPointsFinal.x=[];
startPointsFinal.y=[];
endPointsFinal.x=[];
endPointsFinal.y=[];
startDirectionsFinal=[];


numPolygons=length(boundingPolygons);
eastRef=boundingPolygons(1).x(1);
northRef=boundingPolygons(1).y(1);

out_hodo=[];

for i=1:numPolygons
%     if i==3
%         flipSide=false;
%     else
%         flipSide=true;
%     end
    
    boundingPolygon=boundingPolygons(i);
    startDirection=startDirections(i);
    
    east=boundingPolygon.x;
    north=boundingPolygon.y;

    east=east-eastRef;
    north=north-northRef;

    corners=[east' north'];

    % number of vertices
    n=length(east);

    % calculate angle to be used to rotate coordinate frame
    rotation=-startDirection+pi/2;

    % allocate memory
    xCorner=[];
    yCorner=[];

    xRef=corners(1,1);
    yRef=corners(1,2);

    % rotate points so that startDirection points along x axis
    for ii=1:n
    xCorner(ii)=(corners(ii,1)-xRef)*cos(rotation)+(corners(ii,2)-yRef)*sin(rotation);
    yCorner(ii)=-(corners(ii,1)-xRef)*sin(rotation)+(corners(ii,2)-yRef)*cos(rotation);
    end

    %    
    %       2------------------------3
    %       /                       /
    %      /                       /
    %     /                       /   
    %    /                       /
    %   1-----------------------4
    %
    %

    % define line segments to indicate sides of field
    clear sides;
    for ii=2:n
    sides(ii)=ppLineSegment(xCorner(ii-1),yCorner(ii-1),xCorner(ii),yCorner(ii));
    end
    % add last side
    sides(1)=ppLineSegment(xCorner(n),yCorner(n),xCorner(1),yCorner(1));

    % determine lines that bound top and bottom of field
    y_max=max(yCorner);
    y_min=min(yCorner);
    % calculate number of passes required to cover field
    numPasses = floor((y_max-y_min)/spacing)+1;

    % calculate start and endpoints for line segments crossing field

    % allocate memory
    startPoints.x=[];
    startPoints.y=[];
    endPoints.x=[];
    endPoints.y=[];

    % create crossing line
    if (flipSide)
    crossLine=ppLine(0,y_min);
    else
    crossLine=ppLine(0,y_max);
    end


    jj=1; % index of current start and end point
    for ii=1:numPasses
    % calculate intersection of crossing line and line segments that define field
    % should find two intersections for each crossing line
    numFound=0; % number of intersections found

    % check for intersections with each side
    for kk=1:n
        [intersect x y]=lineLineSegmentIntersection(crossLine,sides(kk));
        if ((intersect==1)||(intersect==3))
          numFound=numFound+1;
          intX(numFound)=x;
          intY(numFound)=y;
        end        
    end


    % make sure exactly 2 intersections were found
    if (numFound<2)
       error('Something went horribly wrong! Not enough intersections found');
    elseif (numFound==3)
        % check to see if duplicate intersections found
        % ex: if a crossing line intersects two segments where they meet,
        % the same point will be calculated for both segments
        if ((abs(intX(1)-intX(2))<0.01)&&(abs(intY(1)-intY(2))<0.01))&&((abs(intX(1)-intX(3))>0.01)||(abs(intY(1)-intY(3))>0.01))
            intX(1)=intX(3);
            intY(1)=intY(3);
        elseif (abs(intX(1)-intX(2))>0.01)||(abs(intY(1)-intY(2))>0.01)
            % just ignore the extra one. intersections 1 and 2 are looked
            % at and they are different
        else
            error('Something went horribly wrong! Too many non-matching intersections found');
        end
    elseif (numFound>3)
    %         figure()
    %         for kk=1:n
    %            hold on
    %            plotppLineSegment(sides(kk));
    %         end
    %         plotppLineSegment(crossLine,'r')
       error('Something went horribly wrong! Too many intersections found');
    end

    % make sure a zero lenght segment wasn't found - these can occur at
    % corners
    if (abs(intX(1)-intX(2))<0.01)&&(abs(intY(1)-intY(2))<0.01)
        % do not add line and reduce number of passes by one
        numPasses=numPasses-1;
    else
        % determine which points should be start points and which should be end
        % points
        % start direction should be in the direction of the x axis in local
        % coordinates so the point with the large x value should be the end
        % point
        if (intX(1)>intX(2))
            startPoints.x(jj)=intX(2);
            startPoints.y(jj)=intY(2);
            endPoints.x(jj)=intX(1);
            endPoints.y(jj)=intY(1);
        else
            startPoints.x(jj)=intX(1);
            startPoints.y(jj)=intY(1);
            endPoints.x(jj)=intX(2);
            endPoints.y(jj)=intY(2);            
        end
        jj=jj+1;
    end
    % slide line down
    if (flipSide)
        crossLine.b=crossLine.b+spacing;    
    else
        crossLine.b=crossLine.b-spacing;
    end
    end


    % convert start and end points from x-y-z to e-n-d
    % allocate memory

    startPointsTemp.x=[];
    startPointsTemp.y=[];
    endPointsTemp.x=[];
    endPointsTemp.y=[];
    startDirectionTemp=[];

    % rotate and translate points back to east-north frame
    for ii=1:numPasses
        startPointsTemp.x(ii)=startPoints.x(ii)*cos(rotation)-startPoints.y(ii)*sin(rotation)+xRef;
        startPointsTemp.y(ii)=startPoints.x(ii)*sin(rotation)+startPoints.y(ii)*cos(rotation)+yRef;
        endPointsTemp.x(ii)=endPoints.x(ii)*cos(rotation)-endPoints.y(ii)*sin(rotation)+xRef;
        endPointsTemp.y(ii)=endPoints.x(ii)*sin(rotation)+endPoints.y(ii)*cos(rotation)+yRef;
        startDirectionTemp(ii)=startDirection;
    end


    startPointsFinal.x=[startPointsFinal.x startPointsTemp.x(1:numPasses)];
    startPointsFinal.y=[startPointsFinal.y startPointsTemp.y(1:numPasses)];
    endPointsFinal.x=[endPointsFinal.x endPointsTemp.x(1:numPasses)];
    endPointsFinal.y=[endPointsFinal.y endPointsTemp.y(1:numPasses)];
    startDirectionsFinal=[startDirectionsFinal startDirectionTemp(1:numPasses)];
    
    %% survey using hodo method
    %%generate path connected points

    % selects points on start and end of field to be connected with line
    % segments to generate the path

    % use interleaving as far as possible and then switch to making large loops
    % at the end of the field

    nextPoint=1;        % index of next point to pick in array of start and end points
    dir=-1;             % indicates direction of larger radius turn for interleaving method
    jj=1;               % current segment index
    N=2*floor(2*minRadius/spacing)+1;    % numbers of rows in each set


    waypoints=[];

    % number of passes that can be completed using interleaving without
    % covering the same ground twice ( rest must be done with some other method
    intPasses=(floor(numPasses/N)*N); 

    % check to see if any rows are left over
    leftOver=numPasses-intPasses;

    % if (leftOver>0)
    %     intPasses=intPasses-N;
    % end

    %%generate path using interleaving (sets method)
    for ii=1:intPasses

        % modify N for last pass
        if ((ii==intPasses+1)&&(leftOver>0))
            % add any leftover rows to last set
            N=N+leftOver;
            % N must be an odd number
            if (mod(N,2)==0)
               N=N-1; 
            end
            dir=dir*-1;
        end


        if ((mod(ii-1,N)==0)&&(ii<intPasses))
            % there are N passes in each set.  after each set is finished, the
            % vehicle is on the opposite side of the field as it was at the
            % beginning.  the turning direction is swapped (now turning
            % minRadius+1 on the bottom and minRadius on the top) and another
            % set is started
            dir=dir*-1; 
        end

        % determine which side of the field you are on.  on the
        % start (near) side of the field is ii is odd, on the end (far) side of
        % the field if ii is even.
        if (mod(ii,2)==1)   % near side of field
            % add point on starting edge of field
            waypoints(jj).E=startPointsTemp.x(nextPoint)+eastRef;
            waypoints(jj).N=startPointsTemp.y(nextPoint)+northRef;
            waypoints(jj).heading=atan2(endPointsTemp.x(nextPoint)-startPointsTemp.x(nextPoint),endPointsTemp.y(nextPoint)-startPointsTemp.y(nextPoint));
            waypoints(jj).heading=startDirection;
            waypoints(jj).speed=pathSpeed;

            % increment current waypoint index
            jj=jj+1;
            % add point on far (ending) edge of field
            waypoints(jj).E=endPointsTemp.x(nextPoint)+eastRef;
            waypoints(jj).N=endPointsTemp.y(nextPoint)+northRef;
            waypoints(jj).heading=atan2(endPointsTemp.x(nextPoint)-startPointsTemp.x(nextPoint),endPointsTemp.y(nextPoint)-startPointsTemp.y(nextPoint));
            waypoints(jj).heading=startDirection;
            waypoints(jj).speed=pathSpeed;

            % determine index of next segment
            % skip minRadius segments on the far side and minRadius-1 segments on the near side 
            if (dir==1)
               nextPoint=nextPoint+ceil(N/2);
            else
                nextPoint=nextPoint-floor(N/2);            
            end

        else
            % add point on far (ending) edge of field
            waypoints(jj).E=endPointsTemp.x(nextPoint)+eastRef;
            waypoints(jj).N=endPointsTemp.y(nextPoint)+northRef;
            waypoints(jj).speed=pathSpeed;
            waypoints(jj).heading=atan2(startPointsTemp.x(nextPoint)-endPointsTemp.x(nextPoint),startPointsTemp.y(nextPoint)-endPointsTemp.y(nextPoint));
            waypoints(jj).heading=startDirection+pi;
            % increment current waypoint index
            jj=jj+1;
            % add point on starting edge of field
            waypoints(jj).E=startPointsTemp.x(nextPoint)+eastRef;
            waypoints(jj).N=startPointsTemp.y(nextPoint)+northRef;
            waypoints(jj).heading=atan2(startPointsTemp.x(nextPoint)-endPointsTemp.x(nextPoint),startPointsTemp.y(nextPoint)-endPointsTemp.y(nextPoint));
            waypoints(jj).heading=startDirection+pi;
            waypoints(jj).speed=pathSpeed;

            % determine index of next segment
            % skip minRadius segments on the far side and minRadius-1 segments on the near side 
            if (dir==1)
               nextPoint=nextPoint-floor(N/2);            
            else
               nextPoint=nextPoint+ceil(N/2);
            end 

        end
        jj=jj+1;
    end


    for ii=intPasses+1:numPasses

        if ((mod(ii-1,N)==0)&&(ii<intPasses))
            % there are N passes in each set.  after each set is finished, the
            % vehicle is on the opposite side of the field as it was at the
            % beginning.  the turning direction is swapped (now turning
            % minRadius+1 on the bottom and minRadius on the top) and another
            % set is started
            dir=dir*-1; 
        end

        % determine which side of the field you are on.  on the
        % start (near) side of the field is ii is odd, on the end (far) side of
        % the field if ii is even.
        if (mod(ii,2)==1)   % near side of field
            % add point on starting edge of field
            waypoints(jj).E=startPointsTemp.x(nextPoint)+eastRef;
            waypoints(jj).N=startPointsTemp.y(nextPoint)+northRef;
            waypoints(jj).heading=atan2(endPointsTemp.x(nextPoint)-startPointsTemp.x(nextPoint),endPointsTemp.y(nextPoint)-startPointsTemp.y(nextPoint));
            waypoints(jj).heading=startDirection;
            waypoints(jj).speed=pathSpeed;

            % increment current waypoint index
            jj=jj+1;
            % add point on far (ending) edge of field
            waypoints(jj).E=endPointsTemp.x(nextPoint)+eastRef;
            waypoints(jj).N=endPointsTemp.y(nextPoint)+northRef;
            waypoints(jj).heading=atan2(endPointsTemp.x(nextPoint)-startPointsTemp.x(nextPoint),endPointsTemp.y(nextPoint)-startPointsTemp.y(nextPoint));
            waypoints(jj).heading=startDirection;
            waypoints(jj).speed=pathSpeed;

            % determine index of next segment
            % skip minRadius segments on the far side and minRadius-1 segments on the near side 
            nextPoint=nextPoint+1;

        else
            % add point on far (ending) edge of field
            waypoints(jj).E=endPointsTemp.x(nextPoint)+eastRef;
            waypoints(jj).N=endPointsTemp.y(nextPoint)+northRef;
            waypoints(jj).speed=pathSpeed;
            waypoints(jj).heading=atan2(startPointsTemp.x(nextPoint)-endPointsTemp.x(nextPoint),startPointsTemp.y(nextPoint)-endPointsTemp.y(nextPoint));
            waypoints(jj).heading=startDirection+pi;
            % increment current waypoint index
            jj=jj+1;
            % add point on starting edge of field
            waypoints(jj).E=startPointsTemp.x(nextPoint)+eastRef;
            waypoints(jj).N=startPointsTemp.y(nextPoint)+northRef;
            waypoints(jj).heading=atan2(startPointsTemp.x(nextPoint)-endPointsTemp.x(nextPoint),startPointsTemp.y(nextPoint)-endPointsTemp.y(nextPoint));
            waypoints(jj).heading=startDirection+pi;
            waypoints(jj).speed=pathSpeed;

            % determine index of next segment
            % skip minRadius segments on the far side and minRadius-1 segments on the near side 
            nextPoint=nextPoint+1;

        end
        jj=jj+1;
    end


    %%generate path
    out=[waypoints.E; waypoints.N; waypoints.heading; waypoints.speed;]';

    out_hodo=[out_hodo; out];

end


    
%% working length 
workLength=0;
for ii=1:length(startPointsFinal.x)
workLength=workLength+sqrt((startPointsFinal.x(ii)-endPointsFinal.x(ii))^2+(startPointsFinal.y(ii)-endPointsFinal.y(ii))^2);
end
workLength

%% survey using optimal tsp method
out=ppSurveyTspOptimalMultiply(startPointsFinal, endPointsFinal, startDirectionsFinal, minRadius, pathSpeed, eastRef, northRef);

colFreePath=configurationsToDubinsPath(out, minRadius);
totalLength=0;
for i=1:length(colFreePath)
   totalLength=totalLength+colFreePath(i).length;
end
turnLength_optsp=totalLength-workLength

h=figure(4);clf;

for i =1:size(boundingPolygons,2)
    boundingPolygons(i).x=boundingPolygons(i).x+spacing/2;
    if i==1
        plotppPolygon(boundingPolygons(i));
    else
        plotppPolygon(boundingPolygons(i),[0.83 0.83 0.83]);
    end
    hold on;
end
axes_num=gca;
plot_linetracker_path(colFreePath, axes_num,'RS',0,'k'); % draw arcs and lines that represent path
axis equal
axis([28 153 47.5 172.5])
saveTightFigure(h,'multiresult4.eps')

%% survey using boustrophedon method
% out=ppSurveyBoustrophMultiply(startPointsFinal, endPointsFinal, startDirectionsFinal, minRadius, pathSpeed, eastRef, northRef);
% 
% colFreePath=configurationsToDubinsPath(out, minRadius);
% totalLength=0;
% for i=1:length(colFreePath)
%    totalLength=totalLength+colFreePath(i).length;
% end
% turnLength_bous=totalLength-workLength
% 
% figure(2);clf;
% for i =1:size(boundingPolygons,2)
%     boundingPolygons(i).x=boundingPolygons(i).x;
%     if i==1
%         plotppPolygon(boundingPolygons(i));
%     else
%         plotppPolygon(boundingPolygons(i),[0.83 0.83 0.83]);
%     end
%     hold on;
% end
% axes_num=gca;
% plot_linetracker_path(colFreePath, axes_num,'RS',0,'k'); % draw arcs and lines that represent path
% axis equal
% axis([28 153 45 175])
% 
% 
% 
% 
% %% survey using set method
% colFreePath=configurationsToDubinsPath(out_hodo, minRadius);
% 
% totalLength=0;
% for i=1:length(colFreePath)
%    totalLength=totalLength+colFreePath(i).length;
% end
% turnLength_hodo=totalLength-workLength
% 
% figure(5);
% clf;
% for i =1:size(boundingPolygons,2)
%     boundingPolygons(i).x=boundingPolygons(i).x;
%     if i==1
%         plotppPolygon(boundingPolygons(i));
%     else
%         plotppPolygon(boundingPolygons(i),[0.83 0.83 0.83]);
%     end
%     hold on;
% end
% axes_num=gca;   
% plot_linetracker_path(colFreePath, axes_num,'RS',0,'k'); % draw arcs and lines that represent path
% axis equal
% 
% axis([28 153 45 175])



end