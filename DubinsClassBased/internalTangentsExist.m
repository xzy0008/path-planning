function out = internalTangentsExist(circle1,circle2)
%PPDUBINSPATH determines if internal tangents exist between two circles
%
%   internalTangentsExist(circle1,circle2)
%       - circle1 = 1st circle to find tangent from
%       - circle2 = 2nd circle to find tangent from

% at least one internal tangent exists as long as distance between centers
% is great than the sum of the radii of the circles
%
% written by: David Hodo - 2006 - hododav@auburn.edu

% calculate distance between centers
d=sqrt((circle2.x-circle1.x)^2+(circle2.y-circle1.y)^2);
if (d>(circle1.radius+circle2.radius))
    out=true;
else
    out=false;
end

end