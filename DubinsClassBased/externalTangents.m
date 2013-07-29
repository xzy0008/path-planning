function out = externalTangents(circle1,circle2)
%EXTERNALTANGENTS calculates common external tangents between two different
%   circles
%
%   externalTangents(circle1,circle2)
%       - circle1 = 1st circle to find tangent from
%       - circle2 = 2nd circle to find tangent from
%
%   output: a structure containing 4 points given as :
%       -(out.x1_c1, cout.y1_c1) - 1st point of tangency with 1st circle
%       -(out.x1_c2, cout.y1_c2) - 1st point of tangency with 2nd circle
%       -(out.x2_c1, cout.y2_c1) - 2nd point of tangency with 2nd circle
%       -(out.x2_c2, cout.y2_c2) - 2nd point of tangency with 2nd circle
%
% Reference: Two Circles and Their Common Tangents, V.K. Srinivasan 2001
% written by: David Hodo - 2006 - hododav@auburn.edu

% fails when circles are the same - should be checked elsewhere before
% running this function

% it can be observed that the common external tangents are parallel to the
% line segment between the centers of the two circles - shift this line to
% both sides of circle to get tangents

% calculate vector r_12 between centers of two circles
r_12=[circle2.x-circle1.x;circle2.y-circle1.y];
% calculate vector perpendicular to r12 by rotating 90 degrees
r_p=[0 -1; 1 0]*r_12;
% normalize rp to create unit vector
r_pn=r_p/norm(r_p);
% vector from center of circle to tangent point is +-r*r_pn
% vectors are same for both circles
r_ct=[r_pn*circle1.radius -r_pn*circle2.radius];

% calculate points of tangency
out.x1_c1=circle1.x+r_ct(1,1);
out.y1_c1=circle1.y+r_ct(2,1);
out.x1_c2=circle2.x+r_ct(1,1);
out.y1_c2=circle2.y+r_ct(2,1);
out.x2_c1=circle1.x+r_ct(1,2);
out.y2_c1=circle1.y+r_ct(2,2);
out.x2_c2=circle2.x+r_ct(1,2);
out.y2_c2=circle2.y+r_ct(2,2);
end