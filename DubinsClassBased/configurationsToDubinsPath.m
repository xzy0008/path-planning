function out=configurationsToDubinsPath(configurations, radius)
%CONFIGURATIONSTODUBINSPATH generates a path consisting of line and arc 
% segments to follow the given configurations
%
%   configurationsToDubinsPath(configurations, radius)
%       - configurations = array of configurations, which contain an x,y
%         coordinate, orientation, and speed
%       - radius = minimum turning radius
%
% output path structure:
%   path.end.E
%   path.end.N
%   path.center.E
%   path.center.N
%   path.heading
%   path.radius
%   path.type
%   path.ccw
%   path.theta_min
%   path.theta_max
%   path.theta_total
%   path.speed
%
% written by: David Hodo - 2006 - hododav@auburn.edu

% determine index of last point
[m,n]=size(configurations);
end_point=m;

% % add 1st point to path structure
% path.end.E(1)=configurations(1,1);
% path.end.N(1)=configurations(1,2);
% path.heading(1)=configurations(1,3);
% path.center.E(1)=path.end.E(1);
% path.center.N(1)=path.end.N(1);
% path.radius(1)=sqrt((path.end.E(1)-path.center.E(1))^2+(path.end.N(1)-path.center.N(1))^2);
% path.type(1)='l';
% path.ccw(1)=2;
% path.theta_min(1)=0;
% path.theta_max(1)=0;
% path.theta_total(1)=0;
% path.speed(1)=configurations(1,4);

% current path segment index
jj=1;

% define local reference - used to fix problem with overflows if very large
% values are passed in
% subtract value from all x and y coordinates and add it back to final
% answer
% choose 1st configuration as reference
eRef=configurations(1,1);
nRef=configurations(1,2);

myPath=ppSegment(0,0,0,0,0,0,0,0);

% loop through all configurations and create paths between them
for ii=2:end_point
    
    % create initial configuration
    startCfg=ppConfiguration(configurations(ii-1,1)-eRef,configurations(ii-1,2)-nRef,configurations(ii-1,3),configurations(ii-1,4));
    % create terminal configuration
    endCfg=ppConfiguration(configurations(ii,1)-eRef,configurations(ii,2)-nRef,configurations(ii,3),configurations(ii,4));
    % generate path between current configuration and next configuration
    curPath=ppDubinsPathSegment(startCfg,endCfg,radius,false);
    
    % path could contain up to three segments
    % add each segment to the path structure
    % make sure segments are not zero length before adding them
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % add 1st segment
    if (curPath.length(2)>0.01)    % make sure 1st segment is not zero length
        % add 1st segment
%         path.end.E(jj)=curPath.x_c1+eRef;
%         path.end.N(jj)=curPath.y_c1+nRef;
%         path.center.E(jj)=curPath.initCircle.x+eRef;
%         path.center.N(jj)=curPath.initCircle.y+nRef;
%         path.radius(jj)=curPath.initCircle.radius;
%         path.type(jj)='a';
%         path.ccw(jj)=curPath.initCircle.left;
%         path.theta_min(jj)=mod(atan2(path.end.E(jj-1)-(curPath.initCircle.x+eRef),path.end.N(jj-1)-(curPath.initCircle.y+nRef))+2*pi,2*pi);
%         path.theta_max(jj)=mod(atan2(path.end.E(jj)-(curPath.initCircle.x+eRef),path.end.N(jj)-(curPath.initCircle.y+nRef))+2*pi,2*pi);
%         % flip theta_min and theta_max for left(ccw) circles
% 
% 		% check to see if there will be a wrap problem
%         % - example: theta_min = 315 degrees, theta_max=0 degrees
%         %   direction)
%         % - change 0 degrees to 360 degrees to fix
%         if (path.theta_min(jj)>path.theta_max(jj))
%             path.theta_max(jj)=path.theta_max(jj)+2*pi;
%         end  
%         path.theta_total(jj)=mod(path.theta_max(jj)-path.theta_min(jj)+2*pi,2*pi);

		myPath(jj)=ppSegment(startCfg.x+eRef, startCfg.y+nRef, curPath.x_c1+eRef,curPath.y_c1+nRef, ...
			curPath.initCircle.x+eRef,curPath.initCircle.y+nRef,curPath.initCircle.left,configurations(ii,4));
	
%         path.speed(jj)=configurations(ii,4);        
        % increment segment index
        jj=jj+1;
    end % end if length segment 1 > 0
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % add 2nd segment
    if (curPath.length(3)>0.01)    % make sure 2nd segment is not zero length
        % set endpoint and speed
		
		if (curPath.BBB)
			myPath(jj)=ppSegment(curPath.x_c1+eRef,curPath.y_c1+nRef,curPath.x_c2+eRef,curPath.y_c2+nRef, ...
				curPath.intCircle.x+eRef,curPath.intCircle.y+nRef,curPath.intCircle.left,configurations(ii,4));
		else
			myPath(jj)=ppSegment(curPath.x_c1+eRef,curPath.y_c1+nRef,curPath.x_c2+eRef,curPath.y_c2+nRef, ...
				curPath.x_c1+eRef,curPath.y_c1+nRef,2,configurations(ii,4));
 		end
% 		
%         path.end.E(jj)=curPath.x_c2+eRef;
%         path.end.N(jj)=curPath.y_c2+nRef;
%         path.speed(jj)=configurations(ii,4);
%         % determine if middle segment is an arc or a line
%         if (curPath.BBB)
%             % segment is an arc segment
%             path.center.E(jj)=curPath.intCircle.x+eRef;
%             path.center.N(jj)=curPath.intCircle.y+nRef;
%             path.radius(jj)=curPath.intCircle.radius;
%             path.type(jj)='a';
%             path.ccw(jj)=curPath.intCircle.left;
%             path.theta_min(jj)=mod(atan2(path.end.E(jj-1)-(curPath.intCircle.x+eRef),path.end.N(jj-1)-(curPath.intCircle.y+nRef))+2*pi,2*pi);
%             path.theta_max(jj)=mod(atan2(path.end.E(jj)-(curPath.intCircle.x+eRef),path.end.N(jj)-(curPath.intCircle.y+nRef))+2*pi,2*pi);
%             % flip theta_min and theta_max for left(ccw) circles
%             if path.ccw(jj)
%                 path.heading(jj)=mod(path.theta_max(jj)-pi/2,2*pi);
%                 temp=path.theta_min(jj);
%                 path.theta_min(jj)=path.theta_max(jj);
%                 path.theta_max(jj)=temp;
%             else
%                 path.heading(jj)=mod(path.theta_max(jj)+pi/2,2*pi);
%             end
%             % check to see if there will be a wrap problem
%             % - example: theta_min = 315 degrees, theta_max=0 degrees
%             %   direction)
%             % - change 0 degrees to 360 degrees to fix
%             if (path.theta_min(jj)>path.theta_max(jj))
%                 path.theta_max(jj)=path.theta_max(jj)+2*pi;
%             end        
%             path.theta_total(jj)=mod(path.theta_max(jj)-path.theta_min(jj)+2*pi,2*pi);
%         else % BBB=false
%             % segment is a line segment
%             path.center.E(jj)=path.end.E(jj-1);
%             path.center.N(jj)=path.end.N(jj-1);
%             path.radius(jj)=sqrt((path.end.E(jj)-path.center.E(jj))^2+(path.end.N(jj)-path.center.N(jj))^2);      
%             path.type(jj)='l';
%             path.ccw(jj)=2;
%             path.theta_min(jj)=0;
%             path.theta_max(jj)=0;
%             path.theta_total(jj)=0;
%             path.heading(jj)=atan2(path.end.E(jj)-path.end.E(jj-1),path.end.N(jj)-path.end.N(jj-1));
%         end % end if BBB
        % increment segment index
        jj=jj+1;
    end % end if length segment 2 > 0

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % add 3rd segment
    if (curPath.length(4)>0.01)    % make sure 1st segment is not zero length
        % add 3rd segment
		myPath(jj)=ppSegment(curPath.x_c2+eRef,curPath.y_c2+nRef,configurations(ii,1),configurations(ii,2), ...
			curPath.termCircle.x+eRef,curPath.termCircle.y+nRef,curPath.termCircle.left,configurations(ii,4));

% 		
%         path.end.E(jj)=configurations(ii,1);
%         path.end.N(jj)=configurations(ii,2);
%         %path.heading(jj)=configurations(ii,3);
%         path.speed(jj)=configurations(ii,4);
%         path.center.E(jj)=curPath.termCircle.x+eRef;
%         path.center.N(jj)=curPath.termCircle.y+nRef;
%         path.radius(jj)=curPath.termCircle.radius;
%         path.type(jj)='a';
%         path.ccw(jj)=curPath.termCircle.left;
%         path.theta_min(jj)=mod(atan2(path.end.E(jj-1)-(curPath.termCircle.x+eRef),path.end.N(jj-1)-(curPath.termCircle.y+nRef))+2*pi,2*pi);
%         path.theta_max(jj)=mod(atan2(path.end.E(jj)-(curPath.termCircle.x+eRef),path.end.N(jj)-(curPath.termCircle.y+nRef))+2*pi,2*pi);
%         % flip theta_min and theta_max for left(ccw) circles
%         if path.ccw(jj)
%             path.heading(jj)=mod(path.theta_max(jj)-pi/2,2*pi);
%             temp=path.theta_min(jj);
%             path.theta_min(jj)=path.theta_max(jj);
%             path.theta_max(jj)=temp;
%         else
%             path.heading(jj)=mod(path.theta_max(jj)+pi/2,2*pi);
%         end
%         % check to see if there will be a wrap problem
%         % - example: theta_min = 315 degrees, theta_max=0 degrees
%         %   direction)
%         % - change 0 degrees to 360 degrees to fix
%         if (path.theta_min(jj)>path.theta_max(jj))
%             path.theta_max(jj)=path.theta_max(jj)+2*pi;
%         end           
%         path.theta_total(jj)=mod(path.theta_max(jj)-path.theta_min(jj)+2*pi,2*pi);
%         % increment segment index
        jj=jj+1;
        
    end % end if length segment 3 > 0    
  
    if (size(configurations(2))>4)
        % add wait to end if there is one
        myPath(jj-1).wait=configurations(2,5);
    end
	
end % end for loop


out=myPath; 

end
