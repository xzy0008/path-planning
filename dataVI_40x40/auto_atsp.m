t = timer('TimerFcn',@robot,'ExecutionMode','fixedspacing','Period',1);
start(t);
% for n=5:5:50
%     for m = 1:30
%         filename=sprintf('lkh atsp%d_%d.par',n,m);
%         system(filename);
%         
%     end
% end

for n=5:5:50
    for m = 1:30
        filename=sprintf('lkh tsp%d_%d.par',n,m);
        system(filename);
    end
end
stop(t);
