function I3 = sumFilter(I,radius)
%function I3 = sumFilter(I,radius);
%
% I is the input image
% radius is the additional radius of the mask, i.e., 5 means a mask of 11 x 11
% if radius is a four value vector, any rectangular support may be used.
% The order should be [left top right bottom].

if (size(I,3) > 1)
    error('Only single-channel images are allowed');
end

switch length(radius)
  case 4,
    mask = ones(radius(2)+radius(4)+1, radius(1)+radius(3)+1);
    I3 = conv2(double(I), mask, 'same');
  case 1,
    mask = ones(2*radius+1);
    I3 = conv2(double(I), mask, 'same');
end
