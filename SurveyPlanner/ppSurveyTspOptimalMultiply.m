function out = ppSurveyTspOptimalMultiply(startPoints, endPoints, startDirections, minRadius, pathSpeed, eastRef, northRef)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Writen by: Xin Yu
%%%find optimal survey directions by generalized Traveling Salesman Problem
%%%with Lin kernihan heuristic
%%%this algorithm treats each pass as two virtual directed passes for tsp
%%%refer to Xin Yu's work
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numPasses=length(startPoints.x);
%%create virtual passes
%%startPoint of a virtual pass is ingoing, endPoint is outgoing
for i=1:numPasses 
    passes(2*i-1).startPoint.x=startPoints.x(i);
    passes(2*i-1).startPoint.y=startPoints.y(i);
    passes(2*i-1).startPoint.heading=startDirections(i);
    passes(2*i-1).endPoint.x=endPoints.x(i);
    passes(2*i-1).endPoint.y=endPoints.y(i);
    passes(2*i-1).endPoint.heading=startDirections(i);
    passes(2*i-1).cluster=i;
    passes(2*i-1).succeedPassNum=2*i;

    passes(2*i).startPoint.x=endPoints.x(i);
    passes(2*i).startPoint.y=endPoints.y(i);
    passes(2*i).startPoint.heading=startDirections(i)+pi;
    passes(2*i).endPoint.x=startPoints.x(i);
    passes(2*i).endPoint.y=startPoints.y(i);
    passes(2*i).endPoint.heading=startDirections(i)+pi;
    passes(2*i).cluster=i;
    passes(2*i).succeedPassNum=2*i-1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%construct cost matrix, use symmetric to reduce compute time
numVirPasses=length(passes);
cost(numVirPasses, numVirPasses)=NaN;
M=0;
for ii=1:numVirPasses
    for jj=1:ii
        if passes(ii).cluster==passes(jj).cluster;
            cost(ii,jj)=2147483647;
        else
            cfgInitial=[passes(ii).endPoint.x passes(ii).endPoint.y passes(ii).endPoint.heading pathSpeed];
            cfgFinal=[passes(jj).startPoint.x passes(jj).startPoint.y passes(jj).startPoint.heading pathSpeed];
            dubinsPath=configurationsToDubinsPath([cfgInitial; cfgFinal], minRadius);
            len=0;
            for i=1:length(dubinsPath)
               len=len+dubinsPath(i).length;
            end
            cost(ii,jj)=len;
            M=M+cost(ii,jj);
        end
    end
end

%%symmetric cost, reduce computing time
for ii=1:numVirPasses
    for jj=ii+1:numVirPasses
        cost(ii,jj)=cost(passes(jj).succeedPassNum,passes(ii).succeedPassNum);
        if passes(ii).cluster~=passes(jj).cluster
            M=M+cost(ii,jj);
        else
            cost(ii,jj)=cost(jj,ii);
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%put some constraints in the cost matrix
%%e.g. disconnect field 2 and field 3

cost(61:76,45:60)=7483647;
cost(45:60,61:76)=7483647;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%cost from depot to each pass
%%depot position 

hasdepot=false; %whether or not display the depot
isfixed=false; %whether or not the start and end are fixed

depot.startPoint.x=30;
depot.startPoint.y=-10;
depot.startPoint.heading=pi;
depot.endPoint=depot.startPoint;
depot.endPoint.heading=0;
depot.cluster=0;
depot.succeedPassNum=length(passes)+1;

passes=[passes depot];
numVirPasses=length(passes);

cost(numVirPasses,numVirPasses)=2147483647;

%% for specific start point and end point use
%for example start:1, end:numVirPasses-2
if isfixed
    cost(numVirPasses,:)=2147;
    cost(:,numVirPasses)=2147;
    cost(numVirPasses,numVirPasses-2)=-10000;
    cost(2,numVirPasses)=-10000;
else
    cost(numVirPasses,1:end-1)=-10;
    cost(1:end-1,numVirPasses)=-10;
end

%%
if hasdepot
    ii=numVirPasses;
    for jj=1:numVirPasses
        if passes(ii).cluster==passes(jj).cluster;
            cost(ii,jj)=2147483647;
        else
            cfgInitial=[passes(ii).endPoint.x passes(ii).endPoint.y passes(ii).endPoint.heading pathSpeed];
            cfgFinal=[passes(jj).startPoint.x passes(jj).startPoint.y passes(jj).startPoint.heading pathSpeed];
            dubinsPath=configurationsToDubinsPath([cfgInitial; cfgFinal], minRadius);
            len=0;
            for i=1:length(dubinsPath)
               len=len+dubinsPath(i).length;
            end
            cost(ii,jj)=len;
            M=M+cost(ii,jj);
        end
    end

    jj=numVirPasses;
    for ii=1:numVirPasses
        if passes(ii).cluster==passes(jj).cluster;
            cost(ii,jj)=2147483647;
        else
            cfgInitial=[passes(ii).endPoint.x passes(ii).endPoint.y passes(ii).endPoint.heading pathSpeed];
            cfgFinal=[passes(jj).startPoint.x passes(jj).startPoint.y passes(jj).startPoint.heading pathSpeed];
            dubinsPath=configurationsToDubinsPath([cfgInitial; cfgFinal], minRadius);
            len=0;
            for i=1:length(dubinsPath)
               len=len+dubinsPath(i).length;
            end
            cost(ii,jj)=len;
            M=M+cost(ii,jj);
        end
    end


end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%transform gtsp to atsp
matrix=cost;
for ii=1:numVirPasses
    for jj=1:numVirPasses
        if passes(ii).cluster==passes(jj).cluster
            matrix(ii,passes(ii).succeedPassNum)=0;
        else
            matrix(ii,jj)=cost(passes(ii).succeedPassNum,jj)+M;
        end     
    end
end

%%write atsp file for lkh
filename=sprintf('surveytsp.atsp');
fid = fopen(filename,'w');
fprintf(fid,'%s\n', 'NAME: surveytsp');
fprintf(fid,'%s\n', 'TYPE: ATSP');
fprintf(fid,'%s\n', 'COMMENT: Asymmetric TSP (Fischetti)');
strline = sprintf('DIMENSION: %d', numVirPasses);
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
filename=sprintf('./LKH surveytsp.par');
system(filename);

%%read output result
filename=sprintf('surveytsp.txt');
fid = fopen(filename, 'r');
for i = 1:6
    tline = fgetl(fid);
end
seq = fscanf(fid, '%g', [1,numVirPasses])';
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%resort result sequence, let depot be the first node
pos=find(seq==numVirPasses);
seq=circshift(seq,-(pos-1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%extract data from atsp for gtsp
j=1;
for i=2:length(seq)
    if passes(seq(i)).cluster~=passes(seq(i-1)).cluster
        configurations(2*j-1).x=passes(seq(i)).startPoint.x+eastRef;
        configurations(2*j-1).y=passes(seq(i)).startPoint.y+northRef;
        configurations(2*j-1).heading=passes(seq(i)).startPoint.heading;
        configurations(2*j-1).speed=pathSpeed;
        
        configurations(2*j).x=passes(seq(i)).endPoint.x+eastRef;
        configurations(2*j).y=passes(seq(i)).endPoint.y+northRef;
        configurations(2*j).heading=passes(seq(i)).endPoint.heading;
        configurations(2*j).speed=pathSpeed;
        
        j=j+1;
    end
end

%%consider depot configurations
if hasdepot
    configStart.x=depot.endPoint.x+eastRef;
    configStart.y=depot.endPoint.y+northRef;
    configStart.heading=depot.endPoint.heading;
    configStart.speed=pathSpeed;

    configEnd.x=depot.startPoint.x+eastRef;
    configEnd.y=depot.startPoint.y+northRef;
    configEnd.heading=depot.startPoint.heading;
    configEnd.speed=pathSpeed;
    
    configurations=[configStart configurations configEnd];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%output configurations
out=[configurations.x; configurations.y; configurations.heading; configurations.speed]'; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%visiting sequence except depot
trackseq=[];
for i=2:length(seq)
    if passes(seq(i)).cluster~=passes(seq(i-1)).cluster
        trackseq = [trackseq passes(seq(i)).cluster];
    end
end
trackseq

end