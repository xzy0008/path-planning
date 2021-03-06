clear; clc; close all;

east_start=641747.74847656-20;
north_start=3606773.38784639+20;

dir='../dataVI_40x40/';

turn_radius=2;
sensor_radius=1;
delta=0.001;
converges=[];

pre = 50;
dix = 18;
%%read tsp points
filename = sprintf('%stsp%d_%d.tmp',dir, pre, dix);
fid = fopen(filename, 'r');
for i = 1:6
    tline = fgetl(fid);
end
a = fscanf(fid, '%g %g %g', [3, inf]);
a = a(2:3,:)';
fclose(fid);

%%read output result sequence
filename=sprintf('%soutput_tsp%d_%d.txt',dir, pre, dix);
fid = fopen(filename, 'r');
for i = 1:6
    tline = fgetl(fid);
end
seq = fscanf(fid, '%g', [1,pre]);
seq = seq';
fclose(fid);

%%extract data from tsp sequence
configurations = [];
for i = 1:size(seq,1)
    configurations = [configurations; [a(seq(i),:) 0 1.0 0]];
end

%creat initial nodes from loaded configurations
for i = 1:size(configurations,1)
    circle=ppCircle(configurations(i,1), configurations(i,2), sensor_radius);
    initial_nodes(i)=ppNode(configurations(i,:), circle, NaN);
end
nodes=initial_nodes;
%group process
nodes=minDiskCover(initial_nodes,sensor_radius);
%substitude grouped area with convex shape, instead of circle
nodes=minEntryAreas(nodes);
%find the alternate entry points
nodes=alternateIterativeAlgorithm(nodes, delta, 0);
%assign headings for entry points
nodes=alternatingAlgorithm(nodes,turn_radius);
%prm and dijkstra
nodes=prmDijkstra(nodes,turn_radius,2);


%% generate rs path from waypoints
totallength=0;
nodes=[nodes nodes(1)];
hold on;
if turn_radius>0 %dubins path
    for i=1:length(nodes)-1
        path=configurationsToDubinsPath([nodes(i).dockConfiguration;nodes(i+1).dockConfiguration], turn_radius);
        [fig,h]=plot_linetracker_path(path, gca, 'RS', false, 'k');
        for i =1:length(path)
            totallength=totallength+path(i).length;
        end
    end
else %line path
    for i=1:length(nodes)-1
        h=plot([nodes(i).dockConfiguration(1),nodes(i+1).dockConfiguration(1)],...
            [nodes(i).dockConfiguration(2),nodes(i+1).dockConfiguration(2)],'k','LineWidth',2.5);
        totallength=totallength+sqrt((nodes(i+1).dockConfiguration(1)-nodes(i).dockConfiguration(1))^2 ...
                +(nodes(i+1).dockConfiguration(2)-nodes(i).dockConfiguration(2))^2);
    end
end
totallength
converges=[converges totallength];

%draw dock points
hold on;
for i=1:length(nodes)-1
    plot(nodes(i).dockConfiguration(1),nodes(i).dockConfiguration(2),'b.','markersize',20);
end


%draw circles
hold on;
for i=1:length(initial_nodes)
    h=plotppCircle(initial_nodes(i).circle,'b');
end


%draw configurations
hold on;
% scatter(configurations(:,1),configurations(:,2),'MarkerEdgeColor','k','MarkerFaceColor','g');
plot(configurations(:,1),configurations(:,2),'o','markersize',4,'MarkerEdgeColor','k','MarkerFaceColor','g');
axis equal;
box on;





%%write configurations for test
filename=sprintf('testdata_%dm_%s.txt',turn_radius,date);
fid = fopen(filename,'w');
fprintf(fid,'%d\n', turn_radius);

for i=1:length(nodes)
    fprintf(fid,'%d %d %d %d %d\n',nodes(i).dockConfiguration(1)+east_start,...
        nodes(i).dockConfiguration(2)+north_start,...
        nodes(i).dockConfiguration(3),...
        nodes(i).dockConfiguration(4),...
        nodes(i).dockConfiguration(5));
end
fclose(fid);










% figure;
% plot(converges);
% if 0
% %recalculate the visiting sequence
% n=length(nodes)-1;
% matrix = 9999999*ones(n,n);
% for i = 1:n
%     for j = 1:n
%         if i ~= j
%             path=configurationsToDubinsPath([nodes(i).dockConfiguration;nodes(j).dockConfiguration], turn_radius);
%             len=0;
%             for tt =1:length(path)
%                 len=len+path(tt).length;
%             end
%             matrix(i,j)=round(len);
%         end
%     end
% end
% 
% %%write data_atsp
% filename=sprintf('atsp_.atsp');
% dlmwrite(filename,[]); 
% 
% fid = fopen(filename,'w');
% fprintf(fid,'NAME: atsp_\n');
% fprintf(fid,'TYPE: ATSP\n');
% fprintf(fid,'COMMENT: Asymmetric TSP (Fischetti)\n');
% fprintf(fid,'DIMENSION: %d\n', n);
% fprintf(fid,'EDGE_WEIGHT_TYPE: EXPLICIT\n');
% fprintf(fid,'EDGE_WEIGHT_FORMAT: FULL_MATRIX\n');
% fprintf(fid,'EDGE_WEIGHT_SECTION\n');
% 
% dlmwrite(filename,matrix,'-append','delimiter', '\t', 'precision', '%.0f'); 
% fclose(fid);
% 
% %%write par_atsp
% filename=sprintf('atsp_.par');
% fid = fopen(filename,'w');
% 
% fprintf(fid,'PROBLEM_FILE= atsp_.atsp\n');
% fprintf(fid,'OPTIMUM 378032\n');
% fprintf(fid,'MOVE_TYPE = 5\n');
% fprintf(fid,'PATCHING_C = 3\n');
% fprintf(fid,'PATCHING_A = 2\n');
% fprintf(fid,'RUNS = 10\n');
% fprintf(fid,'OUTPUT_TOUR_FILE = output_atsp_.txt\n');
% fclose(fid);
% 
% %%compute atsp
% filename=sprintf('lkh atsp_.par');
% system(filename);
% 
% %%draw atsp
% figure;
% filename = sprintf('output_atsp_.txt');
% fid=fopen(filename,'r');
% 
% for i=1:6
%     tline = fgetl(fid);
%     if ~ischar(tline),   break,   end
% end
% s=fscanf(fid,'%g',[1,n]);
% fclose(fid);
% 
% %% generate rs path from waypoints
% totallength=0;
% 
% for i=1:n-1
%     path=configurationsToDubinsPath([nodes(s(i)).dockConfiguration;nodes(s(i+1)).dockConfiguration], turn_radius);
%     plot_linetracker_path(path, gca, 'RS', false, 'g');
%     for i =1:length(path)
%         totallength=totallength+path(i).length;
%     end
% end
% path=configurationsToDubinsPath([nodes(s(n)).dockConfiguration;nodes(s(1)).dockConfiguration], turn_radius);
% plot_linetracker_path(path, gca, 'RS', false, 'g');
% for i =1:length(path)
%     totallength=totallength+path(i).length;
% end
% totallength
% 
% %draw dock points
% hold on;
% for i=1:length(nodes)-1
%     plot(nodes(i).dockConfiguration(1),nodes(i).dockConfiguration(2),'k*');
% end
% 
% %draw circles
% hold on;
% for i=1:length(nodes)-1
%     plotppCircle(nodes(i).circle);
% end
% 
% %draw configurations
% hold on;
% scatter(configurations(:,1),configurations(:,2),'r.')
% for ii=1:length(configurations)
% %     plot_arrow_angle(configurations(ii,1),configurations(ii,2),configurations(ii,3), 7);
%     %plot_arrow_angle(configurations(ii,1),configurations(ii,2),psi2theta(configurations(ii,1)), 5);
% end

% end