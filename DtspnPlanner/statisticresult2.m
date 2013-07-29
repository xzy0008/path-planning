%%-------------------------------------------------------------------------
%%tsp_com_aia_aa-----------------------------------------------------------

clear; clc; close all;

turn_radius=1;
sensor_radius=1;
delta=0.001;

results_tsp_com_aia_aa=[];
for pre = 5:5:50
    converges=[];
    for dix = 1:30
        %%read tsp points
        filename = sprintf('C:\\Users\\zhongyuan\\Desktop\\dataVI_40x40\\tsp%d_%d.tmp', pre, dix);
        fid = fopen(filename, 'r');
        for i = 1:6
            tline = fgetl(fid);
        end
        a = fscanf(fid, '%g %g %g', [3, inf]);
        a = a(2:3,:)';
        fclose(fid);

        %%read output result sequence
        filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataVI_40x40\\output_tsp%d_%d.txt', pre, dix);
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

        %% generate rs path from waypoints
        totallength=0;
        nodes=[nodes nodes(1)];
        hold on;
        if turn_radius>0 %dubins path
            for i=1:length(nodes)-1
                path=configurationsToDubinsPath([nodes(i).dockConfiguration;nodes(i+1).dockConfiguration], turn_radius);
%                 plot_linetracker_path(path, gca, 'RS', false, 'g');
                for i =1:length(path)
                    totallength=totallength+path(i).length;
                end
            end
        else %line path
            for i=1:length(nodes)-1
%                 plot([nodes(i).dockConfiguration(1),nodes(i+1).dockConfiguration(1)],[nodes(i).dockConfiguration(2),nodes(i+1).dockConfiguration(2)],'g');
                totallength=totallength+sqrt((nodes(i+1).dockConfiguration(1)-nodes(i).dockConfiguration(1))^2 ...
                        +(nodes(i+1).dockConfiguration(2)-nodes(i).dockConfiguration(2))^2);
            end
        end
        converges=[converges totallength];
    end
    average=mean(converges);
    results_tsp_com_aia_aa = [results_tsp_com_aia_aa; [pre average]];
end

filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataVI_40x40\\output_tsp_com_aia_aa.txt');
save(filename,'results_tsp_com_aia_aa','-ascii');


%%-------------------------------------------------------------------------
%%tsp_com_aa---------------------------------------------------------------

clear; clc; close all;

turn_radius=1;
sensor_radius=1;
delta=0.001;

results_tsp_com_aa=[];
for pre = 5:5:50
    converges=[];
    for dix = 1:30
        %%read tsp points
        filename = sprintf('C:\\Users\\zhongyuan\\Desktop\\dataVI_40x40\\tsp%d_%d.tmp', pre, dix);
        fid = fopen(filename, 'r');
        for i = 1:6
            tline = fgetl(fid);
        end
        a = fscanf(fid, '%g %g %g', [3, inf]);
        a = a(2:3,:)';
        fclose(fid);

        %%read output result sequence
        filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataVI_40x40\\output_tsp%d_%d.txt', pre, dix);
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
%         nodes=minEntryAreas(nodes);
        %find the alternate entry points
%         nodes=alternateIterativeAlgorithm(nodes, delta, 0);
        %assign headings for entry points
        nodes=alternatingAlgorithm(nodes,turn_radius);

        %% generate rs path from waypoints
        totallength=0;
        nodes=[nodes nodes(1)];
        hold on;
        if turn_radius>0 %dubins path
            for i=1:length(nodes)-1
                path=configurationsToDubinsPath([nodes(i).dockConfiguration;nodes(i+1).dockConfiguration], turn_radius);
%                 plot_linetracker_path(path, gca, 'RS', false, 'g');
                for i =1:length(path)
                    totallength=totallength+path(i).length;
                end
            end
        else %line path
            for i=1:length(nodes)-1
%                 plot([nodes(i).dockConfiguration(1),nodes(i+1).dockConfiguration(1)],[nodes(i).dockConfiguration(2),nodes(i+1).dockConfiguration(2)],'g');
                totallength=totallength+sqrt((nodes(i+1).dockConfiguration(1)-nodes(i).dockConfiguration(1))^2 ...
                        +(nodes(i+1).dockConfiguration(2)-nodes(i).dockConfiguration(2))^2);
            end
        end
        converges=[converges totallength];
    end
    average=mean(converges);
    results_tsp_com_aa = [results_tsp_com_aa; [pre average]];
end

filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataVI_40x40\\output_tsp_com_aa.txt');
save(filename,'results_tsp_com_aa','-ascii');



%%-------------------------------------------------------------------------
%%tsp_aa-------------------------------------------------------------------



clear; clc; close all;

turn_radius=1;
sensor_radius=1;
delta=0.001;

results_tsp_aa=[];
for pre = 5:5:50
    converges=[];
    for dix = 1:30
        %%read tsp points
        filename = sprintf('C:\\Users\\zhongyuan\\Desktop\\dataVI_40x40\\tsp%d_%d.tmp', pre, dix);
        fid = fopen(filename, 'r');
        for i = 1:6
            tline = fgetl(fid);
        end
        a = fscanf(fid, '%g %g %g', [3, inf]);
        a = a(2:3,:)';
        fclose(fid);

        %%read output result sequence
        filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataVI_40x40\\output_tsp%d_%d.txt', pre, dix);
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
%         nodes=minDiskCover(initial_nodes,sensor_radius);
        %substitude grouped area with convex shape, instead of circle
%         nodes=minEntryAreas(nodes);
        %find the alternate entry points
%         nodes=alternateIterativeAlgorithm(nodes, delta, 0);
        %assign headings for entry points
        nodes=alternatingAlgorithm(nodes,turn_radius);

        %% generate rs path from waypoints
        totallength=0;
        nodes=[nodes nodes(1)];
        hold on;
        if turn_radius>0 %dubins path
            for i=1:length(nodes)-1
                path=configurationsToDubinsPath([nodes(i).dockConfiguration;nodes(i+1).dockConfiguration], turn_radius);
%                 plot_linetracker_path(path, gca, 'RS', false, 'g');
                for i =1:length(path)
                    totallength=totallength+path(i).length;
                end
            end
        else %line path
            for i=1:length(nodes)-1
%                 plot([nodes(i).dockConfiguration(1),nodes(i+1).dockConfiguration(1)],[nodes(i).dockConfiguration(2),nodes(i+1).dockConfiguration(2)],'g');
                totallength=totallength+sqrt((nodes(i+1).dockConfiguration(1)-nodes(i).dockConfiguration(1))^2 ...
                        +(nodes(i+1).dockConfiguration(2)-nodes(i).dockConfiguration(2))^2);
            end
        end
        converges=[converges totallength];
    end
    average=mean(converges);
    results_tsp_aa = [results_tsp_aa; [pre average]];
end

filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataVI_40x40\\output_tsp_aa.txt');
save(filename,'results_tsp_aa','-ascii');



%%-------------------------------------------------------------------------
%%tsp----------------------------------------------------------------------

clear; clc; close all;

turn_radius=0;
sensor_radius=1;
delta=0.001;

results_tsp=[];
for pre = 5:5:50
    converges=[];
    for dix = 1:30
        %%read tsp points
        filename = sprintf('C:\\Users\\zhongyuan\\Desktop\\dataVI_40x40\\tsp%d_%d.tmp', pre, dix);
        fid = fopen(filename, 'r');
        for i = 1:6
            tline = fgetl(fid);
        end
        a = fscanf(fid, '%g %g %g', [3, inf]);
        a = a(2:3,:)';
        fclose(fid);

        %%read output result sequence
        filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataVI_40x40\\output_tsp%d_%d.txt', pre, dix);
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
%         nodes=minDiskCover(initial_nodes,sensor_radius);
        %substitude grouped area with convex shape, instead of circle
%         nodes=minEntryAreas(nodes);
        %find the alternate entry points
%         nodes=alternateIterativeAlgorithm(nodes, delta, 0);
        %assign headings for entry points
%         nodes=alternatingAlgorithm(nodes,turn_radius);

        %% generate rs path from waypoints
        totallength=0;
        nodes=[nodes nodes(1)];
        hold on;
        if turn_radius>0 %dubins path
            for i=1:length(nodes)-1
                path=configurationsToDubinsPath([nodes(i).dockConfiguration;nodes(i+1).dockConfiguration], turn_radius);
%                 plot_linetracker_path(path, gca, 'RS', false, 'g');
                for i =1:length(path)
                    totallength=totallength+path(i).length;
                end
            end
        else %line path
            for i=1:length(nodes)-1
%                 plot([nodes(i).dockConfiguration(1),nodes(i+1).dockConfiguration(1)],[nodes(i).dockConfiguration(2),nodes(i+1).dockConfiguration(2)],'g');
                totallength=totallength+sqrt((nodes(i+1).dockConfiguration(1)-nodes(i).dockConfiguration(1))^2 ...
                        +(nodes(i+1).dockConfiguration(2)-nodes(i).dockConfiguration(2))^2);
            end
        end
        converges=[converges totallength];
    end
    average=mean(converges);
    results_tsp = [results_tsp; [pre average]];
end

filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataVI_40x40\\output_tsp.txt');
save(filename,'results_tsp','-ascii');



%%-------------------------------------------------------------------------
%%tsp_com-------------------------------------------------------------------

clear; clc; close all;

turn_radius=0;
sensor_radius=1;
delta=0.001;

results_tsp_com=[];
for pre = 5:5:50
    converges=[];
    for dix = 1:30
        %%read tsp points
        filename = sprintf('C:\\Users\\zhongyuan\\Desktop\\dataVI_40x40\\tsp%d_%d.tmp', pre, dix);
        fid = fopen(filename, 'r');
        for i = 1:6
            tline = fgetl(fid);
        end
        a = fscanf(fid, '%g %g %g', [3, inf]);
        a = a(2:3,:)';
        fclose(fid);

        %%read output result sequence
        filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataVI_40x40\\output_tsp%d_%d.txt', pre, dix);
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
%         nodes=minEntryAreas(nodes);
        %find the alternate entry points
%         nodes=alternateIterativeAlgorithm(nodes, delta, 0);
        %assign headings for entry points
%         nodes=alternatingAlgorithm(nodes,turn_radius);

        %% generate rs path from waypoints
        totallength=0;
        nodes=[nodes nodes(1)];
        hold on;
        if turn_radius>0 %dubins path
            for i=1:length(nodes)-1
                path=configurationsToDubinsPath([nodes(i).dockConfiguration;nodes(i+1).dockConfiguration], turn_radius);
%                 plot_linetracker_path(path, gca, 'RS', false, 'g');
                for i =1:length(path)
                    totallength=totallength+path(i).length;
                end
            end
        else %line path
            for i=1:length(nodes)-1
%                 plot([nodes(i).dockConfiguration(1),nodes(i+1).dockConfiguration(1)],[nodes(i).dockConfiguration(2),nodes(i+1).dockConfiguration(2)],'g');
                totallength=totallength+sqrt((nodes(i+1).dockConfiguration(1)-nodes(i).dockConfiguration(1))^2 ...
                        +(nodes(i+1).dockConfiguration(2)-nodes(i).dockConfiguration(2))^2);
            end
        end
        converges=[converges totallength];
    end
    average=mean(converges);
    results_tsp_com = [results_tsp_com; [pre average]];
end

filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataVI_40x40\\output_tsp_com.txt');
save(filename,'results_tsp_com','-ascii');




%%-------------------------------------------------------------------------
%%tsp_com_aia--------------------------------------------------------------


clear; clc; close all;

turn_radius=0;
sensor_radius=1;
delta=0.001;

results_tsp_com_aia=[];
for pre = 5:5:50
    converges=[];
    for dix = 1:30
        %%read tsp points
        filename = sprintf('C:\\Users\\zhongyuan\\Desktop\\dataVI_40x40\\tsp%d_%d.tmp', pre, dix);
        fid = fopen(filename, 'r');
        for i = 1:6
            tline = fgetl(fid);
        end
        a = fscanf(fid, '%g %g %g', [3, inf]);
        a = a(2:3,:)';
        fclose(fid);

        %%read output result sequence
        filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataVI_40x40\\output_tsp%d_%d.txt', pre, dix);
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
%         nodes=alternatingAlgorithm(nodes,turn_radius);

        %% generate rs path from waypoints
        totallength=0;
        nodes=[nodes nodes(1)];
        hold on;
        if turn_radius>0 %dubins path
            for i=1:length(nodes)-1
                path=configurationsToDubinsPath([nodes(i).dockConfiguration;nodes(i+1).dockConfiguration], turn_radius);
%                 plot_linetracker_path(path, gca, 'RS', false, 'g');
                for i =1:length(path)
                    totallength=totallength+path(i).length;
                end
            end
        else %line path
            for i=1:length(nodes)-1
%                 plot([nodes(i).dockConfiguration(1),nodes(i+1).dockConfiguration(1)],[nodes(i).dockConfiguration(2),nodes(i+1).dockConfiguration(2)],'g');
                totallength=totallength+sqrt((nodes(i+1).dockConfiguration(1)-nodes(i).dockConfiguration(1))^2 ...
                        +(nodes(i+1).dockConfiguration(2)-nodes(i).dockConfiguration(2))^2);
            end
        end
        converges=[converges totallength];
    end
    average=mean(converges);
    results_tsp_com_aia = [results_tsp_com_aia; [pre average]];
end

filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataVI_40x40\\output_tsp_com_aia.txt');
save(filename,'results_tsp_com_aia','-ascii');







%%-------------------------------------------------------------------------
%%tsp_com_aia_aa-----------------------------------------------------------

clear; clc; close all;

turn_radius=1;
sensor_radius=1;
delta=0.001;

results_tsp_com_aia_aa=[];
for pre = 5:5:50
    converges=[];
    for dix = 1:30
        %%read tsp points
        filename = sprintf('C:\\Users\\zhongyuan\\Desktop\\dataV_10x10\\tsp%d_%d.tmp', pre, dix);
        fid = fopen(filename, 'r');
        for i = 1:6
            tline = fgetl(fid);
        end
        a = fscanf(fid, '%g %g %g', [3, inf]);
        a = a(2:3,:)';
        fclose(fid);

        %%read output result sequence
        filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataV_10x10\\output_tsp%d_%d.txt', pre, dix);
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

        %% generate rs path from waypoints
        totallength=0;
        nodes=[nodes nodes(1)];
        hold on;
        if turn_radius>0 %dubins path
            for i=1:length(nodes)-1
                path=configurationsToDubinsPath([nodes(i).dockConfiguration;nodes(i+1).dockConfiguration], turn_radius);
%                 plot_linetracker_path(path, gca, 'RS', false, 'g');
                for i =1:length(path)
                    totallength=totallength+path(i).length;
                end
            end
        else %line path
            for i=1:length(nodes)-1
%                 plot([nodes(i).dockConfiguration(1),nodes(i+1).dockConfiguration(1)],[nodes(i).dockConfiguration(2),nodes(i+1).dockConfiguration(2)],'g');
                totallength=totallength+sqrt((nodes(i+1).dockConfiguration(1)-nodes(i).dockConfiguration(1))^2 ...
                        +(nodes(i+1).dockConfiguration(2)-nodes(i).dockConfiguration(2))^2);
            end
        end
        converges=[converges totallength];
    end
    average=mean(converges);
    results_tsp_com_aia_aa = [results_tsp_com_aia_aa; [pre average]];
end

filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataV_10x10\\output_tsp_com_aia_aa.txt');
save(filename,'results_tsp_com_aia_aa','-ascii');


%%-------------------------------------------------------------------------
%%tsp_com_aa---------------------------------------------------------------

clear; clc; close all;

turn_radius=1;
sensor_radius=1;
delta=0.001;

results_tsp_com_aa=[];
for pre = 5:5:50
    converges=[];
    for dix = 1:30
        %%read tsp points
        filename = sprintf('C:\\Users\\zhongyuan\\Desktop\\dataV_10x10\\tsp%d_%d.tmp', pre, dix);
        fid = fopen(filename, 'r');
        for i = 1:6
            tline = fgetl(fid);
        end
        a = fscanf(fid, '%g %g %g', [3, inf]);
        a = a(2:3,:)';
        fclose(fid);

        %%read output result sequence
        filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataV_10x10\\output_tsp%d_%d.txt', pre, dix);
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
%         nodes=minEntryAreas(nodes);
        %find the alternate entry points
%         nodes=alternateIterativeAlgorithm(nodes, delta, 0);
        %assign headings for entry points
        nodes=alternatingAlgorithm(nodes,turn_radius);

        %% generate rs path from waypoints
        totallength=0;
        nodes=[nodes nodes(1)];
        hold on;
        if turn_radius>0 %dubins path
            for i=1:length(nodes)-1
                path=configurationsToDubinsPath([nodes(i).dockConfiguration;nodes(i+1).dockConfiguration], turn_radius);
%                 plot_linetracker_path(path, gca, 'RS', false, 'g');
                for i =1:length(path)
                    totallength=totallength+path(i).length;
                end
            end
        else %line path
            for i=1:length(nodes)-1
%                 plot([nodes(i).dockConfiguration(1),nodes(i+1).dockConfiguration(1)],[nodes(i).dockConfiguration(2),nodes(i+1).dockConfiguration(2)],'g');
                totallength=totallength+sqrt((nodes(i+1).dockConfiguration(1)-nodes(i).dockConfiguration(1))^2 ...
                        +(nodes(i+1).dockConfiguration(2)-nodes(i).dockConfiguration(2))^2);
            end
        end
        converges=[converges totallength];
    end
    average=mean(converges);
    results_tsp_com_aa = [results_tsp_com_aa; [pre average]];
end

filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataV_10x10\\output_tsp_com_aa.txt');
save(filename,'results_tsp_com_aa','-ascii');



%%-------------------------------------------------------------------------
%%tsp_aa-------------------------------------------------------------------



clear; clc; close all;

turn_radius=1;
sensor_radius=1;
delta=0.001;

results_tsp_aa=[];
for pre = 5:5:50
    converges=[];
    for dix = 1:30
        %%read tsp points
        filename = sprintf('C:\\Users\\zhongyuan\\Desktop\\dataV_10x10\\tsp%d_%d.tmp', pre, dix);
        fid = fopen(filename, 'r');
        for i = 1:6
            tline = fgetl(fid);
        end
        a = fscanf(fid, '%g %g %g', [3, inf]);
        a = a(2:3,:)';
        fclose(fid);

        %%read output result sequence
        filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataV_10x10\\output_tsp%d_%d.txt', pre, dix);
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
%         nodes=minDiskCover(initial_nodes,sensor_radius);
        %substitude grouped area with convex shape, instead of circle
%         nodes=minEntryAreas(nodes);
        %find the alternate entry points
%         nodes=alternateIterativeAlgorithm(nodes, delta, 0);
        %assign headings for entry points
        nodes=alternatingAlgorithm(nodes,turn_radius);

        %% generate rs path from waypoints
        totallength=0;
        nodes=[nodes nodes(1)];
        hold on;
        if turn_radius>0 %dubins path
            for i=1:length(nodes)-1
                path=configurationsToDubinsPath([nodes(i).dockConfiguration;nodes(i+1).dockConfiguration], turn_radius);
%                 plot_linetracker_path(path, gca, 'RS', false, 'g');
                for i =1:length(path)
                    totallength=totallength+path(i).length;
                end
            end
        else %line path
            for i=1:length(nodes)-1
%                 plot([nodes(i).dockConfiguration(1),nodes(i+1).dockConfiguration(1)],[nodes(i).dockConfiguration(2),nodes(i+1).dockConfiguration(2)],'g');
                totallength=totallength+sqrt((nodes(i+1).dockConfiguration(1)-nodes(i).dockConfiguration(1))^2 ...
                        +(nodes(i+1).dockConfiguration(2)-nodes(i).dockConfiguration(2))^2);
            end
        end
        converges=[converges totallength];
    end
    average=mean(converges);
    results_tsp_aa = [results_tsp_aa; [pre average]];
end

filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataV_10x10\\output_tsp_aa.txt');
save(filename,'results_tsp_aa','-ascii');



%%-------------------------------------------------------------------------
%%tsp----------------------------------------------------------------------

clear; clc; close all;

turn_radius=0;
sensor_radius=1;
delta=0.001;

results_tsp=[];
for pre = 5:5:50
    converges=[];
    for dix = 1:30
        %%read tsp points
        filename = sprintf('C:\\Users\\zhongyuan\\Desktop\\dataV_10x10\\tsp%d_%d.tmp', pre, dix);
        fid = fopen(filename, 'r');
        for i = 1:6
            tline = fgetl(fid);
        end
        a = fscanf(fid, '%g %g %g', [3, inf]);
        a = a(2:3,:)';
        fclose(fid);

        %%read output result sequence
        filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataV_10x10\\output_tsp%d_%d.txt', pre, dix);
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
%         nodes=minDiskCover(initial_nodes,sensor_radius);
        %substitude grouped area with convex shape, instead of circle
%         nodes=minEntryAreas(nodes);
        %find the alternate entry points
%         nodes=alternateIterativeAlgorithm(nodes, delta, 0);
        %assign headings for entry points
%         nodes=alternatingAlgorithm(nodes,turn_radius);

        %% generate rs path from waypoints
        totallength=0;
        nodes=[nodes nodes(1)];
        hold on;
        if turn_radius>0 %dubins path
            for i=1:length(nodes)-1
                path=configurationsToDubinsPath([nodes(i).dockConfiguration;nodes(i+1).dockConfiguration], turn_radius);
%                 plot_linetracker_path(path, gca, 'RS', false, 'g');
                for i =1:length(path)
                    totallength=totallength+path(i).length;
                end
            end
        else %line path
            for i=1:length(nodes)-1
%                 plot([nodes(i).dockConfiguration(1),nodes(i+1).dockConfiguration(1)],[nodes(i).dockConfiguration(2),nodes(i+1).dockConfiguration(2)],'g');
                totallength=totallength+sqrt((nodes(i+1).dockConfiguration(1)-nodes(i).dockConfiguration(1))^2 ...
                        +(nodes(i+1).dockConfiguration(2)-nodes(i).dockConfiguration(2))^2);
            end
        end
        converges=[converges totallength];
    end
    average=mean(converges);
    results_tsp = [results_tsp; [pre average]];
end

filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataV_10x10\\output_tsp.txt');
save(filename,'results_tsp','-ascii');



%%-------------------------------------------------------------------------
%%tsp_com-------------------------------------------------------------------

clear; clc; close all;

turn_radius=0;
sensor_radius=1;
delta=0.001;

results_tsp_com=[];
for pre = 5:5:50
    converges=[];
    for dix = 1:30
        %%read tsp points
        filename = sprintf('C:\\Users\\zhongyuan\\Desktop\\dataV_10x10\\tsp%d_%d.tmp', pre, dix);
        fid = fopen(filename, 'r');
        for i = 1:6
            tline = fgetl(fid);
        end
        a = fscanf(fid, '%g %g %g', [3, inf]);
        a = a(2:3,:)';
        fclose(fid);

        %%read output result sequence
        filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataV_10x10\\output_tsp%d_%d.txt', pre, dix);
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
%         nodes=minEntryAreas(nodes);
        %find the alternate entry points
%         nodes=alternateIterativeAlgorithm(nodes, delta, 0);
        %assign headings for entry points
%         nodes=alternatingAlgorithm(nodes,turn_radius);

        %% generate rs path from waypoints
        totallength=0;
        nodes=[nodes nodes(1)];
        hold on;
        if turn_radius>0 %dubins path
            for i=1:length(nodes)-1
                path=configurationsToDubinsPath([nodes(i).dockConfiguration;nodes(i+1).dockConfiguration], turn_radius);
%                 plot_linetracker_path(path, gca, 'RS', false, 'g');
                for i =1:length(path)
                    totallength=totallength+path(i).length;
                end
            end
        else %line path
            for i=1:length(nodes)-1
%                 plot([nodes(i).dockConfiguration(1),nodes(i+1).dockConfiguration(1)],[nodes(i).dockConfiguration(2),nodes(i+1).dockConfiguration(2)],'g');
                totallength=totallength+sqrt((nodes(i+1).dockConfiguration(1)-nodes(i).dockConfiguration(1))^2 ...
                        +(nodes(i+1).dockConfiguration(2)-nodes(i).dockConfiguration(2))^2);
            end
        end
        converges=[converges totallength];
    end
    average=mean(converges);
    results_tsp_com = [results_tsp_com; [pre average]];
end

filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataV_10x10\\output_tsp_com.txt');
save(filename,'results_tsp_com','-ascii');




%%-------------------------------------------------------------------------
%%tsp_com_aia--------------------------------------------------------------


clear; clc; close all;

turn_radius=0;
sensor_radius=1;
delta=0.001;

results_tsp_com_aia=[];
for pre = 5:5:50
    converges=[];
    for dix = 1:30
        %%read tsp points
        filename = sprintf('C:\\Users\\zhongyuan\\Desktop\\dataV_10x10\\tsp%d_%d.tmp', pre, dix);
        fid = fopen(filename, 'r');
        for i = 1:6
            tline = fgetl(fid);
        end
        a = fscanf(fid, '%g %g %g', [3, inf]);
        a = a(2:3,:)';
        fclose(fid);

        %%read output result sequence
        filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataV_10x10\\output_tsp%d_%d.txt', pre, dix);
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
%         nodes=alternatingAlgorithm(nodes,turn_radius);

        %% generate rs path from waypoints
        totallength=0;
        nodes=[nodes nodes(1)];
        hold on;
        if turn_radius>0 %dubins path
            for i=1:length(nodes)-1
                path=configurationsToDubinsPath([nodes(i).dockConfiguration;nodes(i+1).dockConfiguration], turn_radius);
%                 plot_linetracker_path(path, gca, 'RS', false, 'g');
                for i =1:length(path)
                    totallength=totallength+path(i).length;
                end
            end
        else %line path
            for i=1:length(nodes)-1
%                 plot([nodes(i).dockConfiguration(1),nodes(i+1).dockConfiguration(1)],[nodes(i).dockConfiguration(2),nodes(i+1).dockConfiguration(2)],'g');
                totallength=totallength+sqrt((nodes(i+1).dockConfiguration(1)-nodes(i).dockConfiguration(1))^2 ...
                        +(nodes(i+1).dockConfiguration(2)-nodes(i).dockConfiguration(2))^2);
            end
        end
        converges=[converges totallength];
    end
    average=mean(converges);
    results_tsp_com_aia = [results_tsp_com_aia; [pre average]];
end

filename=sprintf('C:\\Users\\zhongyuan\\Desktop\\dataV_10x10\\output_tsp_com_aia.txt');
save(filename,'results_tsp_com_aia','-ascii');


