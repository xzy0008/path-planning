function out=dubinsAdmissableTangent(circ1, circ2, config1, config2)
%DUBINSADMISSABLETANGENT calculates Dubins' admissable tangent between two
%   circles.  Calculates all common tangents between the circles and then
%   checks parallelity, perpendicularity, and regularity to determine
%   drivable tangent.
%
%   internalTangents(circle1,circle2)
%       - circle1 = 1st circle to find tangent from
%       - circle2 = 2nd circle to find tangent from
%       - config1 = starting configuration
%       - config2 = ending configuration
%
% output: 
%       -  out.initCirle = circle for initial turn       
%       -  out.intCircle = circle object for intermediate turn
%       -  out.termCircle = circle object for terminal turn
%       -  out.x_c1 = point of tangency with 1st circle (x coordinate)
%       -  out.y_c1 = point of tangency with 1st circle (y coordinate)
%       -  out.x_c2 = point of tangency with 2nd circle (x coordinate)
%       -  out.y_c2 = point of tangency with 2nd circle (y coordinate)
%       -  out.lengths = vector containing total path length followed by length
%           of each segment: [l a b c] where l = total length, a = length of
%           1st turn, b = length of the straight segment, and c = length of
%           final turn
%       -  out.BBB = boolean - true if path is of type BBB (3 turn segments)
%
% Reference: Optimal Motion Control of a Ground Vehicle. Anisi
% written by: David Hodo - 2006 - hododav@auburn.edu

out.initCircle=circ1;
out.intCircle=0;
out.termCircle=circ2;


% check circle directions:
% if they are the same - compute common external tangents.
% if they are not the same - computer common internal tangents
if (circ1.left==circ2.left)
   % equi-directed circles
%    D=1; % pg. 40
   tans=externalTangents(circ1,circ2);
else
    % counter-directed circles
%    D=-1; % pg. 40
   tans=internalTangents(circ1,circ2);    

end

% compute vector between centers of two circles (r_cif)
% r_cif=[circ2.x-circ1.x; circ2.y-circ1.y];


% compute vectors needed to determine is the tagent is admissable for each
% tangent calculated
% compute r_ti - vector between center of inital circle and point of tangency
r_ti1=[tans.x1_c1-circ1.x;tans.y1_c1-circ1.y];
r_ti2=[tans.x2_c1-circ1.x;tans.y2_c1-circ1.y];

% compute r_tf - vector between center of final circle and point of
% tangency
% r_tf1=[tans.x1_c2-circ2.x;tans.y1_c2-circ2.y];
% r_tf2=[tans.x2_c2-circ2.x;tans.y2_c2-circ2.y];


% compute tangent vector r_if - vector between point of tangency on first
% circle and point of tangency on ending circle
r_if1=[tans.x1_c2-tans.x1_c1;tans.y1_c2-tans.y1_c1];
r_if2=[tans.x2_c2-tans.x2_c1;tans.y2_c2-tans.y2_c1];

% compute initial circle direction d=v x r_t 
% if left(ccw) d=1, else d=-1;
if (circ1.left)
    d_i=[0;0;1];
else
    d_i=[0;0;-1];
end


% check both computed tangents against constraints to see which one is
% admissable.  1 and only 1 tangent should pass both tests
tan1Bad=0;
tan2Bad=0;

% check perpendicularity: r_t must be perpendicular to r_if
% dot product of r_t and r_if should be 0
% TODO: SHOULD I CHECK THIS FOR BOTH INITIAL AND FINAL CONFIGURATIONS OR IS
% ONE SUFFICIENT???
% 1st tangent
if (abs(dot(r_ti1/norm(r_ti1),r_if1/norm(r_if1)))>0.1)
    % 1st tangent fails perpendicularity test
    tan1Bad=1;
end
% 2nd tangent
if (abs(dot(r_ti2/norm(r_ti2),r_if2/norm(r_if2)))>0.1)
    % 2nd tangent fails perpendicularity test
    tan2Bad=1;
end

% check regularity 
% [d x r_t] dot r_if > 0
if (dot(cross(d_i, [r_ti1;0]),[r_if1;0])<0)
    % 1st tangent fails regularity test
    tan1Bad=1;
end

if (dot(cross(d_i, [r_ti2;0]),[r_if2;0])<0)
    % 2nd tangent fails regularity test
    tan2Bad=1;
end

if (tan1Bad && tan2Bad)
    error('No admissable tangents found!  Should never get here.');
    out.x_c1=0;
    out.y_c1=0;
    out.x_c2=0;
    out.y_c2=0;
elseif (tan1Bad)
    out.x_c1=tans.x2_c1;
    out.y_c1=tans.y2_c1;
    out.x_c2=tans.x2_c2;
    out.y_c2=tans.y2_c2;
elseif (tan2Bad)
    out.x_c1=tans.x1_c1;
    out.y_c1=tans.y1_c1;
    out.x_c2=tans.x1_c2;
    out.y_c2=tans.y1_c2;
else
    error('Both tangents met constraints!  Should never get here.');
    out.x_c1=0;
    out.y_c1=0;
    out.x_c2=0;
    out.y_c2=0;
end

% figure;
% hold on;
% circle3([circ1.x;circ1.y;0],circ1.radius,1000);
% circle3([circ2.x;circ2.y;0],circ2.radius,1000);
% scatter([tans.x1_c1 tans.x1_c2 tans.x2_c1 tans.x2_c2],[tans.y1_c1 tans.y1_c2 tans.y2_c1 tans.y2_c2])
% axis equal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate length of path


% calculate angle around circle between configuration and tangent point
a=turnDistance(circ1,config1.x,config1.y,out.x_c1,out.y_c1);

% line segment
b=sqrt((out.x_c2-out.x_c1)^2+(out.y_c2-out.y_c1)^2);

% calculate angle around circle between configuration and tangent point
c=turnDistance(circ2,out.x_c2,out.y_c2,config2.x,config2.y);

% lenght is total of three segments
l=abs(a)+abs(b)+abs(c);

% return total length and lenght of each segment
%  - return individual segment lengths so that zero length segments can be
%    removed
out.length=[l a b c];
out.BBB=false;

end
