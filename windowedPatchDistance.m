function distances = windowedPatchDistance(img,patch)
% 
% Maintained by Jacob G. Martin, Josh Rule
%
% given an image and patch, computes the euclidean distance between the patch
% and all crops of the image of similar size.
%
% args:
%
%     img: a 2- or 3-dimensional matrix, the image to window/crop
%
%     patch: a 2- or 3-dimensional matrix, the patch to match windows against
%         img and patch must have the same depth
%
% note: sumOverP(W(p)-I(p))^2 is computed as
%     sumOverP(W(p)^2) - 2*(W(p)*I(p)) + sumOverP(I(p)^2);

imgDepth   = size(img,3);
patchDepth = size(patch,3);
if(imgDepth ~= patchDepth)
    fprintf('windowedPa....m: patch and image must have the same depth\n');
end

patchSize = size(patch);
patchSize(3) = imgDepth;
patchSquaredSum = sum(sum(sum(patch.^2)));
sumSupport = [ceil(patchSize(2)/2)-1,ceil(patchSize(1)/2)-1,...
              floor(patchSize(2)/2),floor(patchSize(1)/2)];
imgSquared = img.^2;
imgSquared = sum(imgSquared,3);
imgSquared = sumFilter(imgSquared,sumSupport);

patchXImg = zeros(size(imgSquared));
for i = 1:imgDepth
    patchXImg = patchXImg + conv2(img(:,:,i),patch(:,:,i), 'same');
end

distancesSquared = imgSquared - 2*patchXImg + patchSquaredSum;
distancesSquared(distancesSquared < 0) = 0;
distances = sqrt(distancesSquared) + 10^-10;
