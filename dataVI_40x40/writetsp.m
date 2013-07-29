clear;
for n=5:5:50
    for m = 1:30

        %%write tmp
        filename=sprintf('tsp%d_%d.tmp',n,m);
        fid = fopen(filename,'w');
        dlmwrite(filename, []);
        fprintf(fid,'NAME: tsp%d_%d\n', n,m);
        fprintf(fid,'COMMENT: %d-tsp problem (Padberg/Rinaldi)\n',n);
        fprintf(fid,'TYPE: TSP\n');
        fprintf(fid,'DIMENSION: %d\n', n);
        fprintf(fid,'EDGE_WEIGHT_TYPE : EUC_2D\n');
        fprintf(fid,'NODE_COORD_SECTION\n');

        a =[[1:n]' 40*rand(n,2)];
        dlmwrite(filename, a,'-append','delimiter', ' ', 'precision', '%.2f'); 

        fclose(fid);



        %%write xml
        docNode = com.mathworks.xml.XMLUtils.createDocument('CityList');
        for i = 1:n
            city_node = docNode.createElement('City');
            city_node.setAttribute('X',num2str(a(i,2)));
            city_node.setAttribute('Y',num2str(a(i,3)));
            docNode.getDocumentElement.appendChild(city_node);
        end
        str=xmlwrite(docNode);
        filename=sprintf('dtsp%d_%d.xml',n,m);
        fid=fopen(filename,'w');
        fprintf(fid,str);
        fclose(fid);


        %%write tsp
        filename=sprintf('tsp%d_%d.tsp',n,m);
        fid = fopen(filename,'w');
        dlmwrite(filename, []);
        fprintf(fid,'NAME: tsp%d_%d\n', n,m);
        fprintf(fid,'COMMENT: %d-tsp problem (Padberg/Rinaldi)\n',n);
        fprintf(fid,'TYPE: TSP\n');
        fprintf(fid,'DIMENSION: %d\n', n);
        fprintf(fid,'EDGE_WEIGHT_TYPE : EUC_2D\n');
        fprintf(fid,'NODE_COORD_SECTION\n');

        a =round(a);
        dlmwrite(filename, a,'-append','delimiter', ' ', 'precision', '%.0f'); 

        fclose(fid);



%         %%write atsp
%         clc;
%         filename=sprintf('tsp%d_%d.tmp',n,m);
% 
%         fid=fopen(filename,'r');
% 
%         for i=1:6
%             tline = fgetl(fid);
%             if ~ischar(tline),   break,   end
%         end
%         a=fscanf(fid,'%g %g %g',[3,inf]);
%         a =a(2:3,:)';
%         fclose(fid);
% 
%         b = [a 2*pi*rand(size(a,1),1)];
%         n = size(b,1);
%         matrix = 9999999*ones(n,n);
%         for i = 1:n
%             for j = 1:n
%                 if i ~= j
%                     matrix(i,j) = dubins(b(i,:),b(j,:),1);
%                 end
%             end
%         end
% 
%         filename=sprintf('atsp%d_%d.atsp',n,m);
% 
%         dlmwrite(filename,[]); 
% 
%         fid = fopen(filename,'w');
%         fprintf(fid,'NAME: atsp%d_%d\n', n,m);
%         fprintf(fid,'TYPE: ATSP\n');
%         fprintf(fid,'COMMENT: Asymmetric TSP (Fischetti)\n');
%         fprintf(fid,'DIMENSION: %d\n', n);
%         fprintf(fid,'EDGE_WEIGHT_TYPE: EXPLICIT\n');
%         fprintf(fid,'EDGE_WEIGHT_FORMAT: FULL_MATRIX\n');
%         fprintf(fid,'EDGE_WEIGHT_SECTION\n');
% 
%         dlmwrite(filename,matrix,'-append','delimiter', '\t', 'precision', '%.0f'); 
%         fclose(fid);


        %%write par_tsp
        filename=sprintf('tsp%d_%d.par',n,m);
        fid = fopen(filename,'w');

        fprintf(fid,'PROBLEM_FILE= tsp%d_%d.tsp\n', n,m);
        fprintf(fid,'OPTIMUM 378032\n');
        fprintf(fid,'MOVE_TYPE = 5\n');
        fprintf(fid,'PATCHING_C = 3\n');
        fprintf(fid,'PATCHING_A = 2\n');
        fprintf(fid,'RUNS = 10\n');
        fprintf(fid,'OUTPUT_TOUR_FILE = output_tsp%d_%d.txt\n',n,m);
        fclose(fid);

%         %%write par_atsp
%         filename=sprintf('atsp%d_%d.par',n,m);
%         fid = fopen(filename,'w');
% 
%         fprintf(fid,'PROBLEM_FILE= atsp%d_%d.atsp\n', n,m);
%         fprintf(fid,'OPTIMUM 378032\n');
%         fprintf(fid,'MOVE_TYPE = 5\n');
%         fprintf(fid,'PATCHING_C = 3\n');
%         fprintf(fid,'PATCHING_A = 2\n');
%         fprintf(fid,'RUNS = 10\n');
%         fprintf(fid,'OUTPUT_TOUR_FILE = output_atsp%d_%d.txt\n',n,m);
%         fclose(fid);

    end
end