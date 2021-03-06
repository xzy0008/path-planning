function out = ppSurveyTsp(startPoints, endPoints, startDirection, minRadius, pathSpeed, eastRef, northRef)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Writen by: Xin Yu
%%%find optimal survey directions by Traveling Salesman Problem
%%%with Lin kernihan heuristic
%%%cost matrix generated by endpoints of each pass 
%%%refer to D.D.Bochtis "The vehicle routing problem in field logistics part I" 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numPasses=length(startPoints.x);
for i=1:numPasses
    waypoints(2*i-1).x=startPoints.x(i);
    waypoints(2*i-1).y=startPoints.y(i);
    waypoints(2*i-1).headIn=startDirection;
    waypoints(2*i-1).headOut=startDirection+pi;
    waypoints(2*i-1).passNum=i;
    waypoints(2*i-1).side=1;
    waypoints(2*i).x=endPoints.x(i);
    waypoints(2*i).y=endPoints.y(i);
    waypoints(2*i).headIn=startDirection+pi;
    waypoints(2*i).headOut=startDirection;
    waypoints(2*i).passNum=i;
    waypoints(2*i).side=2;
end

%depot position
depot.x=10;
depot.y=-5;
depot.headIn=pi;
depot.headOut=0;
depot.passNum=0;
depot.side=0;

samedepot=false;
waypoints=[waypoints,depot];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numNodes=length(waypoints);
matrix(numNodes,numNodes)=NaN;

if samedepot
    for ii=1:numNodes
        for jj=1:numNodes
            if ii==jj
                matrix(ii,jj)=0;
            elseif waypoints(ii).passNum==waypoints(jj).passNum
                matrix(ii,jj)=0;
            elseif waypoints(ii).side==waypoints(jj).side || waypoints(ii).side==0 || waypoints(jj).side==0
                cfgStart=[waypoints(ii).x waypoints(ii).y waypoints(ii).headOut pathSpeed];
                cfgEnd=[waypoints(jj).x waypoints(jj).y waypoints(jj).headIn pathSpeed];
                dubinsCfg=[cfgStart; cfgEnd];
                dubinsPath=configurationsToDubinsPath(dubinsCfg, minRadius);
                tt=0;
                for i=1:length(dubinsPath)
                   tt=tt+dubinsPath(i).length;
                end
                matrix(ii,jj)=100*tt;
            else
                matrix(ii,jj)=9999999;
            end
        end
    end
else
    for ii=1:numNodes-1
        for jj=1:numNodes-1
            if ii==jj
                matrix(ii,jj)=0;
            elseif waypoints(ii).passNum==waypoints(jj).passNum
                matrix(ii,jj)=0;
            elseif waypoints(ii).side==waypoints(jj).side || waypoints(ii).side==0 || waypoints(jj).side==0
                cfgStart=[waypoints(ii).x waypoints(ii).y waypoints(ii).headOut pathSpeed];
                cfgEnd=[waypoints(jj).x waypoints(jj).y waypoints(jj).headIn pathSpeed];
                dubinsCfg=[cfgStart; cfgEnd];
                dubinsPath=configurationsToDubinsPath(dubinsCfg, minRadius);
                tt=0;
                for i=1:length(dubinsPath)
                   tt=tt+dubinsPath(i).length;
                end
                matrix(ii,jj)=100*tt;
            else
                matrix(ii,jj)=9999999;
            end
        end
    end
    matrix(numNodes,numNodes)=0;
end

%%write atsp file for lkh
filename=sprintf('surveytsp.atsp');
fid = fopen(filename,'w');
fprintf(fid,'%s\n', 'NAME: surveytsp');
fprintf(fid,'%s\n', 'TYPE: ATSP');
fprintf(fid,'%s\n', 'COMMENT: Asymmetric TSP (Fischetti)');
strline = sprintf('DIMENSION: %d', numNodes);
fprintf(fid,'%s\n', strline);
fprintf(fid,'%s\n', 'EDGE_WEIGHT_TYPE: EXPLICIT');
fprintf(fid,'%s\n', 'EDGE_WEIGHT_FORMAT: FULL_MATRIX');
fprintf(fid,'%s\n', 'EDGE_WEIGHT_SECTION');

dlmwrite(filename, matrix, '-append','delimiter', '\t', 'precision', '%.0f'); 
fclose(fid);


%%write par_atsp for lkh
filename=sprintf('surveytsp.par');
fid = fopen(filename,'w');
strline = sprintf('PROBLEM_FILE= surveytsp.atsp\n');
fprintf(fid,strline);
fprintf(fid,'OPTIMUM 378032\n');
fprintf(fid,'MOVE_TYPE = 5\n');
fprintf(fid,'PATCHING_C = 3\n');
fprintf(fid,'PATCHING_A = 2\n');
fprintf(fid,'RUNS = 1\n');
strline = sprintf('OUTPUT_TOUR_FILE = surveytsp.txt\n');
fprintf(fid,strline);
fclose(fid);

%%exicute lkh
filename=sprintf('/Users/XIN/Downloads/LKH-2.0.5/LKH surveytsp.par');
system(filename);

%%read output result
filename=sprintf('surveytsp.txt');
fid = fopen(filename, 'r');
for i = 1:6
    tline = fgetl(fid);
end
seq = fscanf(fid, '%g', [1,numNodes])';
fclose(fid);

%%resort result sequence, let depot be the first node
pos=find(seq==numNodes);
seq=circshift(seq,-(pos-1));

%%extract data from atsp
seq = [seq; seq(1)];
for i=2:length(seq)-1
    if waypoints(seq(i)).passNum==waypoints(seq(i+1)).passNum
        configurations(i).x=waypoints(seq(i)).x+eastRef;
        configurations(i).y=waypoints(seq(i)).y+northRef;
        configurations(i).heading=waypoints(seq(i)).headIn;
        configurations(i).speed=pathSpeed;
    else
        configurations(i).x=waypoints(seq(i)).x+eastRef;
        configurations(i).y=waypoints(seq(i)).y+northRef;
        configurations(i).heading=waypoints(seq(i)).headOut;
        configurations(i).speed=pathSpeed;
    end
end

if samedepot
    configStart.x=depot.x+eastRef;
    configStart.y=depot.y+northRef;
    configStart.heading=depot.headOut;
    configStart.speed=pathSpeed;

    configEnd.x=depot.x+eastRef;
    configEnd.y=depot.y+northRef;
    configEnd.heading=depot.headIn;
    configEnd.speed=pathSpeed;
    
    configurations=[configStart configurations configEnd];
end

out=[configurations.x; configurations.y; configurations.heading; configurations.speed]'; 

%% plot path
%     len=0;
%     positions = [];
%     for i=1:length(configurations)-1
%         cfg1=[configurations(i).x; configurations(i).y; configurations(i).heading];
%         cfg2=[configurations(i+1).x; configurations(i+1).y; configurations(i+1).heading];
%         positions = [positions; drawdubinspath(cfg1, cfg2, minRadius)];
%         len = len+dubins(cfg1, cfg2, minRadius);
%     end
%     figure(4)
%     plot(positions(:,1),positions(:,2));
%     axis equal
%     len


end


