function D = windowedPatchDistance(img,patch)
%function D = windowedPatchDistance(img,patch)
%
% computes the euclidean distance between patch and all crops of img of
% similar size.
%
% sum_over_p(W(p)-I(p))^2 is factored as
% sum_over_p(W(p)^2) + sum_over_p(I(p)^2) - 2*(W(p)*I(p));
%
% img and patch must have the same number of channels

assert(size(img,3) == size(patch,3), ...
  'patch and image must have the same number of layers: %d != %d', size(img,3), size(patch,3));

Psqr = sum(sum(sum(patch.^2)));
imgsq = sum((img.^2),3); % why merely sum over the third dimension (rgb)?
s = size(patch);
sumRadius = [ceil(s(2)/2)-1, ceil(s(1)/2)-1, floor(s(2)/2), floor(s(1)/2)];
imgsq = sumFilter(imgsq,sumRadius);
PI = zeros(size(imgsq));

for i = 1:size(img,3)
    PI = PI + conv2(img(:,:,i),patch(:,:,i), 'same');
end

tempval = imgsq - 2 * PI + Psqr;
tempval(tempval < 0) = 0;
D = sqrt(tempval) + 10^-10; % what is 1E-10 here for?