function totalLength=ppSurveyPathPolygon(boundingPolygon, startDirection, minRadius, spacing, pathSpeed, flipSide, plotResults)
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

clc;clear;close;

%% check input arguments

if (nargin==0)
    boundingPolygon=ppPolygon([10 120 120],[10 10 120]);
    boundingPolygon=ppPolygon([10 120 30],[100 100 40]);
    boundingPolygon=ppPolygon([0 0 30 30],[0 30 30 0]);
%     boundingPolygon=ppPolygon([70 116 100 40 24],[20 50 110 110 50]);
%     boundingPolygon=ppPolygon([50 18+22 40 100+23 100+23],[10 10 50 90 10]);
    boundingPolygon=ppPolygon([40 40 85.6 85.6],[10 40 80 10]);
    boundingPolygon2=ppPolygon([38.8 38.8 86.8 86.8],[10 38.9474 81.0526 10]);
%     boundingPolygon=ppPolygon([10 10 60.4 60.4],[10 60 15 10]);
%     boundingPolygon=ppPolygon([10 10 80 80 60.4 60.4],[10 60 60 10 50 10]);
%     boundingPolygon=ppPolygon([0 0 40 40 30 30 20 20],[0 25 25 10 0 -10 -10 0]);
%     boundingPolygon=ppPolygon([10 10 36.4 36.4],[10 40 40 10]);
%     boundingPolygon=ppPolygon([10 10 34 34],[10 40 40 10]);
    pathSpeed=0.75;    % speed to run path at (m/s)
    minRadius=4;    % min distance between passes
    spacing=2.4;      % 
%     startDirection=0*45*pi/180;
%     startDirection=5.7106*pi/180;
    startDirection=0*pi/180;
%     startDirection=(90-75)*pi/180;   % direction to run 1st path (measured clockwise from north) 
    flipSide=false;	% start at opposite end of field
    plotResults=true;
elseif (nargin==6)
    plotResults=false; 
end

%% convert from east, north, down to XYZ coordinate system
% define x-y coordinate system that is centered at the first corner passed
% in and whose x axis points in the direction given in startDirection

east=boundingPolygon.x;
north=boundingPolygon.y;

eastRef=east(1);
northRef=north(1);

east=east-eastRef;
north=north-northRef;

corners=[east' north'];

% number of vertices
n=length(east);

% calculate angle to be used to rotate coordinate frame
rotation=-startDirection+pi/2;

% allocate memory
xCorner(n)=NaN;
yCorner(n)=NaN;

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

%% define line segments to indicate sides of field
for ii=2:n
    sides(ii)=ppLineSegment(xCorner(ii-1),yCorner(ii-1),xCorner(ii),yCorner(ii));
end
% add last side
sides(1)=ppLineSegment(xCorner(n),yCorner(n),xCorner(1),yCorner(1));

%% determine lines that bound top and bottom of field
y_max=max(yCorner);
y_min=min(yCorner);
% calculate number of passes required to cover field
numPasses = floor((y_max-y_min)/spacing)+1;

%% calculate start and endpoints for line segments crossing field

% allocate memory
startPoints.x(numPasses)=NaN;
startPoints.y(numPasses)=NaN;
endPoints.x(numPasses)=NaN;
endPoints.y(numPasses)=NaN;

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


%% convert start and end points from x-y-z to e-n-d
% allocate memory

startPointsFinal.x(numPasses)=NaN;
startPointsFinal.y(numPasses)=NaN;
endPointsFinal.x(numPasses)=NaN;
endPointsFinal.y(numPasses)=NaN;

% rotate and translate points back to east-north frame
for ii=1:numPasses
    startPointsFinal.x(ii)=startPoints.x(ii)*cos(rotation)-startPoints.y(ii)*sin(rotation)+xRef;
    startPointsFinal.y(ii)=startPoints.x(ii)*sin(rotation)+startPoints.y(ii)*cos(rotation)+yRef;
    endPointsFinal.x(ii)=endPoints.x(ii)*cos(rotation)-endPoints.y(ii)*sin(rotation)+xRef;
    endPointsFinal.y(ii)=endPoints.x(ii)*sin(rotation)+endPoints.y(ii)*cos(rotation)+yRef;
end

%% working length 
workLength=0;
for ii=1:numPasses
    workLength=workLength+sqrt((startPointsFinal.x(ii)-endPointsFinal.x(ii))^2+(startPointsFinal.y(ii)-endPointsFinal.y(ii))^2);
end
workLength

%% survey using boustrophedon method
out=ppSurveyBoustroph(startPointsFinal, endPointsFinal, startDirection, minRadius, pathSpeed, eastRef, northRef);

colFreePath=configurationsToDubinsPath(out, minRadius);
totalLength=0;
for i=1:length(colFreePath)
   totalLength=totalLength+colFreePath(i).length;
end
turnLength_bous=totalLength-workLength
h=figure(2);clf;
axes_num=gca;

plotppPolygon(boundingPolygon2); 
hold on;
plot_linetracker_path(colFreePath, axes_num,'RS',0,'k'); % draw arcs and lines that represent path
axis equal
axis([17 108 -1 90 ])
saveTightFigure(h,'nodepotboustr2.eps')

%% survey using tsp method
% out=ppSurveyTsp(startPointsFinal, endPointsFinal, startDirection, minRadius, pathSpeed, eastRef, northRef);
% 
% colFreePath=configurationsToDubinsPath(out, minRadius);
% totalLength=0;
% for i=1:length(colFreePath)
%    totalLength=totalLength+colFreePath(i).length;
% end
% turnLength_tsp=totalLength-workLength
% figure(3);clf;
% axes_num=gca;
% plot_linetracker_path(colFreePath, axes_num,'RS',0,''); % draw arcs and lines that represent path
% axis equal
% hold on;
% plotppPolygon(boundingPolygon,'r:');  


%% survey using optimal tsp method
out=ppSurveyTspOptimal(startPointsFinal, endPointsFinal, startDirection, minRadius, pathSpeed, eastRef, northRef);

colFreePath=configurationsToDubinsPath(out, minRadius);
totalLength=0;
for i=1:length(colFreePath)
   totalLength=totalLength+colFreePath(i).length;
end
turnLength_optsp=totalLength-workLength

h=figure(4);clf;
axes_num=gca;

plotppPolygon(boundingPolygon2);
hold on;
plot_linetracker_path(colFreePath, axes_num,'RS',0,'k'); % draw arcs and lines that represent path

axis equal

axis([17 108 -1 90 ])
saveTightFigure(h,'nodepotopt3.eps')
% for ii=1:size(out,1)
%     plot_arrow_angle(out(ii,1),out(ii,2),out(ii,3), 3);
% end
% 
numPasses

%% survey using hodo method
%%generate path connected points

% selects points on start and end of field to be connected with line
% segments to generate the path

% use interleaving as far as possible and then switch to making large loops
% at the end of the field

nextPoint=1;        % index of next point to pick in array of start and end points
dir=-1;             % indicates direction of larger radius turn for interleaving method
jj=1;               % current segment index
N=2*ceil(2*minRadius/spacing)+1;    % numbers of rows in each set

% number of passes that can be completed using interleaving without
% covering the same ground twice ( rest must be done with some other method
intPasses=(floor(numPasses/N)*N); 

% check to see if any rows are left over
leftOver=numPasses-intPasses;

% if (leftOver>0)
%     intPasses=intPasses-N;
% end
trackseq=[nextPoint];
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
        waypoints(jj).E=startPointsFinal.x(nextPoint)+eastRef;
        waypoints(jj).N=startPointsFinal.y(nextPoint)+northRef;
        waypoints(jj).heading=atan2(endPointsFinal.x(nextPoint)-startPointsFinal.x(nextPoint),endPointsFinal.y(nextPoint)-startPointsFinal.y(nextPoint));
        waypoints(jj).heading=startDirection;
        waypoints(jj).speed=pathSpeed;
        
        % increment current waypoint index
        jj=jj+1;
        % add point on far (ending) edge of field
        waypoints(jj).E=endPointsFinal.x(nextPoint)+eastRef;
        waypoints(jj).N=endPointsFinal.y(nextPoint)+northRef;
        waypoints(jj).heading=atan2(endPointsFinal.x(nextPoint)-startPointsFinal.x(nextPoint),endPointsFinal.y(nextPoint)-startPointsFinal.y(nextPoint));
        waypoints(jj).heading=startDirection;
        waypoints(jj).speed=pathSpeed;
        
        % determine index of next segment
        % skip minRadius segments on the far side and minRadius-1 segments on the near side 
        if (dir==1)
           nextPoint=nextPoint+ceil(N/2);
        else
            nextPoint=nextPoint-floor(N/2);            
        end
        trackseq = [trackseq nextPoint];
    else
        % add point on far (ending) edge of field
        waypoints(jj).E=endPointsFinal.x(nextPoint)+eastRef;
        waypoints(jj).N=endPointsFinal.y(nextPoint)+northRef;
        waypoints(jj).speed=pathSpeed;
        waypoints(jj).heading=atan2(startPointsFinal.x(nextPoint)-endPointsFinal.x(nextPoint),startPointsFinal.y(nextPoint)-endPointsFinal.y(nextPoint));
        waypoints(jj).heading=startDirection+pi;
        % increment current waypoint index
        jj=jj+1;
        % add point on starting edge of field
        waypoints(jj).E=startPointsFinal.x(nextPoint)+eastRef;
        waypoints(jj).N=startPointsFinal.y(nextPoint)+northRef;
        waypoints(jj).heading=atan2(startPointsFinal.x(nextPoint)-endPointsFinal.x(nextPoint),startPointsFinal.y(nextPoint)-endPointsFinal.y(nextPoint));
        waypoints(jj).heading=startDirection+pi;
        waypoints(jj).speed=pathSpeed;
        
        % determine index of next segment
        % skip minRadius segments on the far side and minRadius-1 segments on the near side 
        if (dir==1)
           nextPoint=nextPoint-floor(N/2);            
        else
           nextPoint=nextPoint+ceil(N/2);
        end 
        trackseq = [trackseq nextPoint];
    end
    jj=jj+1;
end

trackseq = [trackseq intPasses+2:numPasses];
trackseq


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
        waypoints(jj).E=startPointsFinal.x(nextPoint)+eastRef;
        waypoints(jj).N=startPointsFinal.y(nextPoint)+northRef;
        waypoints(jj).heading=atan2(endPointsFinal.x(nextPoint)-startPointsFinal.x(nextPoint),endPointsFinal.y(nextPoint)-startPointsFinal.y(nextPoint));
        waypoints(jj).heading=startDirection;
        waypoints(jj).speed=pathSpeed;
        
        % increment current waypoint index
        jj=jj+1;
        % add point on far (ending) edge of field
        waypoints(jj).E=endPointsFinal.x(nextPoint)+eastRef;
        waypoints(jj).N=endPointsFinal.y(nextPoint)+northRef;
        waypoints(jj).heading=atan2(endPointsFinal.x(nextPoint)-startPointsFinal.x(nextPoint),endPointsFinal.y(nextPoint)-startPointsFinal.y(nextPoint));
        waypoints(jj).heading=startDirection;
        waypoints(jj).speed=pathSpeed;
        
        % determine index of next segment
        % skip minRadius segments on the far side and minRadius-1 segments on the near side 
        nextPoint=nextPoint+1;

    else
        % add point on far (ending) edge of field
        waypoints(jj).E=endPointsFinal.x(nextPoint)+eastRef;
        waypoints(jj).N=endPointsFinal.y(nextPoint)+northRef;
        waypoints(jj).speed=pathSpeed;
        waypoints(jj).heading=atan2(startPointsFinal.x(nextPoint)-endPointsFinal.x(nextPoint),startPointsFinal.y(nextPoint)-endPointsFinal.y(nextPoint));
        waypoints(jj).heading=startDirection+pi;
        % increment current waypoint index
        jj=jj+1;
        % add point on starting edge of field
        waypoints(jj).E=startPointsFinal.x(nextPoint)+eastRef;
        waypoints(jj).N=startPointsFinal.y(nextPoint)+northRef;
        waypoints(jj).heading=atan2(startPointsFinal.x(nextPoint)-endPointsFinal.x(nextPoint),startPointsFinal.y(nextPoint)-endPointsFinal.y(nextPoint));
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


%% plot results
if plotResults
    % plot field
    figure(1);
    clf;
    hold on;
    % plot intersection points
    axis equal;
    legH(2)=scatter([startPointsFinal.x],[startPointsFinal.y],'ks');
    legH(3)=scatter([endPointsFinal.x],[endPointsFinal.y],'r^');
    for ii=1:numPasses
        legH(4)=plot([startPointsFinal.x(ii) endPointsFinal.x(ii)],[startPointsFinal.y(ii) endPointsFinal.y(ii)],'g');
    end
    legH(1)=plot([east(n) east(1)],[north(n),north(1)],'b:');
    for ii=2:n
        plot([east(ii-1) east(ii)],[north(ii-1),north(ii)],'b:');
    end
   
    legend(legH,'field boundary','near side points','far side points', 'passes');
    xlabel('North (m)')
    ylabel('East (m)')
    
    %%plot collision free path
    colFreePath=configurationsToDubinsPath(out, minRadius);
    
    totalLength=0;
    for i=1:length(colFreePath)
       totalLength=totalLength+colFreePath(i).length;
    end
    turnLength_hodo=totalLength-workLength
    
    h=figure(5);
    clf;
    axes_num=gca;
    plotppPolygon(boundingPolygon2);   
    hold on;
    plot_linetracker_path(colFreePath, axes_num,'RS',0,'k'); % draw arcs and lines that represent path
    axis equal

    axis([17 108 -1 90 ])
    saveTightFigure(h,'nodepothodo2.eps')

end

%% reduce rate
rate_bous=(turnLength_bous-turnLength_optsp)/turnLength_optsp
rate_hodo=(turnLength_hodo-turnLength_optsp)/turnLength_optsp

%% calculate configs for collision free survey path
% %surveyConfigs=surveyCollisionFreePath( polygons, configurations)
% 
% %% Write collision free configs to file
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Generate Path File
% fid = fopen('c:\GeneratedPath.txt','w');
% for i=1:length(newWaypoints)
%     fprintf(fid,'%f %f %f %f\r\n',newWaypoints(i).E,newWaypoints(i).N,newWaypoints(i).heading,newWaypoints(i).speed);
% end
% fclose(fid);
 
 
%% Write collision free path points to file
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Generate Path File
% fid = fopen('c:\GeneratedPath2.txt','w');
% fprintf(fid,'%f %f %f %f\r\n',colFreePath(1).startEast,colFreePath(1).startNorth,colFreePath(1).heading,colFreePath(1).speed);
% for i=1:length(colFreePath)
%     fprintf(fid,'%f %f %f %f\r\n',colFreePath(i).endEast,colFreePath(i).endNorth,colFreePath(i).heading,colFreePath(i).speed);
% end
% fclose(fid);


end