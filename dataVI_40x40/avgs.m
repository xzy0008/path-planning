clear; clc;

%%tsp results
filename = sprintf('output_tsp.txt');
fid = fopen(filename,'r');
results_tsp = fscanf(fid,'%g %g', [2,inf]);
results_tsp = results_tsp';

%%tsp_aa results
filename = sprintf('output_tsp_aa.txt');
fid = fopen(filename,'r');
results_tsp_aa = fscanf(fid,'%g %g', [2,inf]);
results_tsp_aa = results_tsp_aa';

%%tsp_combination results
filename = sprintf('output_tsp_com.txt');
fid = fopen(filename,'r');
results_tsp_combination = fscanf(fid,'%g %g', [2,inf]);
results_tsp_combination = results_tsp_combination';

%%tsp_combination_aa results
filename = sprintf('output_tsp_com_aa.txt');
fid = fopen(filename,'r');
results_tsp_combination_aa = fscanf(fid,'%g %g', [2,inf]);
results_tsp_combination_aa = results_tsp_combination_aa';


%%tsp_combination_c results
filename = sprintf('output_tsp_com_aia.txt');
fid = fopen(filename,'r');
results_tsp_combination_aia = fscanf(fid,'%g %g', [2,inf]);
results_tsp_combination_aia = results_tsp_combination_aia';


%%tsp_combination_c_aa results
filename = sprintf('output_tsp_com_aia_aa.txt');
fid = fopen(filename,'r');
results_tsp_combination_aia_aa = fscanf(fid,'%g %g', [2,inf]);
results_tsp_combination_aia_aa = results_tsp_combination_aia_aa';


figure;
hold on;

plot(results_tsp_aa(:,1),results_tsp_aa(:,2),'Color',[0 0.498 0],...
  'LineWidth',2.0,...
  'Marker','diamond');
plot(results_tsp_combination_aa(:,1),results_tsp_combination_aa(:,2),'Color',[1 0 1],...
  'LineWidth',2.0,...
  'Marker','+');
plot(results_tsp_combination_aia_aa(:,1),results_tsp_combination_aia_aa(:,2),'Color',[0 0 1],...
  'LineWidth',2.0,...
  'Marker','square');
plot(results_tsp(:,1),results_tsp(:,2),'Color',[0 1 0],...
  'LineWidth',2.0,...
  'Marker','o');
plot(results_tsp_combination(:,1),results_tsp_combination(:,2),'Color',[1 0 0],...
  'LineWidth',2.0,...
  'Marker','*');
plot(results_tsp_combination_aia(:,1),results_tsp_combination_aia(:,2),'Color',[0 0 1],...
  'LineWidth',2.0,...
  'Marker','^');
box on;
legend('ETSP+AA','ETSP+CO+AA','ETSP+CO+AIA+AA','ETSP','ETSP+CO','ETSP+CO+AIA');
xlabel('Number of Disks');
ylabel('Tour Length')