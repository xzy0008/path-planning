function out=tangentCircleExists(circ1,circ2)
%TANGENTCIRCLEEXISTS determines if a tangent circle exists to the two given
%circles
%
%   tangentCircleExists(circ1, circ2)
%       - circ1 = 1st circle
%       - circ2 = 2nd circle
%
% written by: David Hodo - 2006 - hododav@auburn.edu

% check to see if the two circles are compatible
if (circ1.left ~= circ2.left)
    out = false;
elseif (circ1.forward==circ2.forward)
    out=false;
else
    % calculate the distance between the two centers
    d=sqrt((circ2.x-circ1.x)^2+(circ2.y-circ1.y)^2);
    if (d>4*circ1.radius)
       out=false; 
    else
        out=true;
    end
end

end

% existence of a tangential cc-circle between two cc-circles
% // existence d'un cc-circle tangent entre deux cc-circles
% bool tangent_circle_exists (SMT_CC_Circle c1, SMT_CC_Circle c2) {
%   // les deux cc-circles sont-ils compatibles ?
%   The two cc-circles are they compatible?  
%   if ( c1.left != c2.left ) { return false; }
%   if ( c1.forward == c2.forward ) { return false; }
%   // The two centers are they sufficiently near?  
%   double distance = point_distance (c1.xc, c1.yc, c2.xc, c2.yc);
%   return ( distance <= 4 * c1.radius); 
% }

