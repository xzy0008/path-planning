function out = externalTangentsExist(circle1,circle2)
%EXTERNALTANGENTSEXIST determines if external tangents exist between two circles
%
%   externalTangentsExist(circle1,circle2)
%       - circle1 = 1st circle to find tangent from
%       - circle2 = 2nd circle to find tangent from

% external tangents exist as along as circles are not equal
%
% written by: David Hodo - 2006 - hododav@auburn.edu

if (abs(circle1.radius-circle2.radius)>0.01)
    out=true;
elseif (abs(circle1.x-circle2.x)>0.01)
    out=true;
elseif (abs(circle1.y-circle2.y)>0.01)
    out=true;
else
    out=false;
end

end