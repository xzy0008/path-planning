function out = internalTangents(circle1,circle2)
%INTERNALTANGENTS calculates internal tangents between two circles with the
%same radius
%
%   internalTangents(circle1,circle2)
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

% TODO: FAILS IF THERE IS ONE OR MORE VERTICAL TANGENTS

% make sure circles have same radius
if (abs(circle1.radius-circle2.radius)>0.01)
   error('Cirlces must have the same radius') 
end

% % find center of similitude of the 2 circles
% % since the cirlces are the same radius, the center of simulitude is the
% % midpoint of the line segment connecting the centers of the two circle
% Tx=(circle2.x+circle1.x)/2;
% Ty=(circle2.y+circle1.y)/2;
% 
% % check to see if 1 or 2 tangents exist.
% % user must check to see if any tangents exist before calling function -
% % internalTangentsExist will only return true if 2 tangents exist
% 
% % tangent lines through T2 have the form:
% % y-T2_y=m*(x-T2_x)
% 
% % calculate slopes (m) of two common internal tangents (transverse
% % tangents) using results of solving equation (2.4)
% % check for infinite tangent
% % if ((circle1.radius^2-circle1.x^2+2*circle1.x*Tx-Tx^2)==0)
% %     % 
% %     m(1)=inf;
% %     m(2)=inf;
% % else
%     m(1)= ( Ty*circle1.x-Tx*Ty-circle1.y*circle1.x+Tx*circle1.y+(-circle1.radius^2*(2*circle1.x*Tx+circle1.radius^2-circle1.x^2-Tx^2-Ty^2-circle1.y^2+2*circle1.y*Ty))^(1/2))/(circle1.radius^2-circle1.x^2+2*circle1.x*Tx-Tx^2);
%     m(2)=-(-Ty*circle1.x+Tx*Ty+circle1.y*circle1.x-Tx*circle1.y+(-circle1.radius^2*(2*circle1.x*Tx+circle1.radius^2-circle1.x^2-Tx^2-Ty^2-circle1.y^2+2*circle1.y*Ty))^(1/2))/(circle1.radius^2-circle1.x^2+2*circle1.x*Tx-Tx^2);
%     % calculate y intercepts
%     b=Ty-m*Tx;
% 
%     % now that we have the equations of the tangent lines - calculate the
%     % points where they intersect the circles
%     % intersection of 1st line with 1st circle
%     res1=line_circle_intersection(circle1,m(1),b(1));
%     % intersection of 1st line with 2nd circle
%     res2=line_circle_intersection(circle2,m(1),b(1));
%     % intersection of 2nd line with 1st circle
%     res3=line_circle_intersection(circle1,m(2),b(2));
%     % intersection of 2nd line with 2nd circle
%     res4=line_circle_intersection(circle2,m(2),b(2));
% 
% %end
% 
% 
% % since this is a tangent line - they should only intersect in one place so
% % throw out second solutions
% % solving line circle intersection equations sometimes give answer with
% % very small imaginary part - use real to get rid of it - figure out why
% % it's happening later
% out.x1_c1=real(res1(1,1));
% out.y1_c1=real(res1(2,1));
% out.x1_c2=real(res2(1,1));
% out.y1_c2=real(res2(2,1));
% out.x2_c1=real(res3(1,1));
% out.y2_c1=real(res3(2,1));
% out.x2_c2=real(res4(1,1));
% out.y2_c2=real(res4(2,1));




% 2nd method - elminates problems with vertical tangents
% - also don't have to solve line_cirlce intersection anymore
% calculate distacne between circle centers
d=sqrt((circle2.y-circle1.y)^2+(circle2.x-circle1.x)^2);

theta=acos(circle1.radius/(d/2));
theta2=atan2(circle2.y-circle1.y,circle2.x-circle1.x);
phi=theta2+theta;
phi2=-(theta-theta2);

% calculate intersections with 1st circle
out.x1_c1=circle1.x+circle1.radius*cos(phi);
out.y1_c1=circle1.y+circle1.radius*sin(phi);
out.x2_c1=circle1.x+circle1.radius*cos(phi2);
out.y2_c1=circle1.y+circle1.radius*sin(phi2);
% calculate intersections with 2nd circle
out.x1_c2=circle2.x-circle2.radius*cos(phi);
out.y1_c2=circle2.y-circle2.radius*sin(phi);
out.x2_c2=circle2.x-circle2.radius*cos(phi2);
out.y2_c2=circle2.y-circle2.radius*sin(phi2);

end
