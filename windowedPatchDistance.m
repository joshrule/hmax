function distances = windowedPatchDistance(c1Img,patch)
% distances = windowedPatchDistance(c1Img,patch)
% 
% given an image and patch, computes the euclidean distance between the patch
% and all crops of an image's C1 representation of similar size.
%
% args:
%
%     c1Img: a 3-dimensional matrix, the representation of an image in C1-space
%
%     patch: a 3-dimensional matrix, the patch to match windows against
%     c1Img and patch must have the same depth
%
% returns:
%
%     distances: a size(c1Img,1) x size(c1Img,2) matrix, marking the euclidean
%     distance between the patch and the C1-space representation of an image.
%     Each entry marks the distance between the patch and the image's C1
%     activations centered at that location.
%
% note: sumOverP(W(p)-I(p))^2 is computed as
%       sumOverP(W(p)^2) - 2*(W(p)*I(p)) + sumOverP(I(p)^2);

c1ImgDepth = size(c1Img,3);
patchDepth = size(patch,3);
if(c1ImgDepth ~= patchDepth)
    fprintf('windowedPa....m: patch and c1Img must have the same depth\n');
end

patchSize = size(patch);
patchSize(3) = c1ImgDepth;
patchSquaredSum = sum(sum(sum(patch.^2)));
sumSupport = [ceil(patchSize(2)/2)-1,ceil(patchSize(1)/2)-1,...
              floor(patchSize(2)/2),floor(patchSize(1)/2)];
c1ImgSquared = c1Img.^2;
c1ImgSquared = sum(c1ImgSquared,3);
c1ImgSquared = sumFilter(c1ImgSquared,sumSupport);

patchXc1Img = zeros(size(c1ImgSquared));
for i = 1:c1ImgDepth
    patchXc1Img = patchXc1Img + conv2(c1Img(:,:,i),patch(:,:,i), 'same');
end

distancesSquared = c1ImgSquared - 2*patchXc1Img + patchSquaredSum;
distancesSquared(distancesSquared < 0) = 0;
distances = sqrt(distancesSquared) + 10^-10;
