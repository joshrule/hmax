function [c2r, c1Cache, bestBands, bestLocations] = c2rFromCellsWithLocations(imgs,patches,patchSizes,s2c1prune,c1Cache)
%[c2r c1Cache bestBands bestLocations] = c2rFromCellsWithLocations(imgs,patches,patchSizes,s2c1prune,c1Cache)
%
% A C2locations.m wrapper. For each image in 'imgs', extract all C2 responses.
%
% args:
%
%     imgs: a cell array of matrices, each representing an image
%
%     patches: a cell array with 1 cell/patchSize, each cell holds an
%         patchSizeX * patchSizeY * nOrientations x nPatchesPerSize matrix
%
%     patchSizes: a 2 x nPatchSizes matrix of patch sizes [sizeX; sizeY]
%
%     s2c1prune: see windowedPatchDistance.m
%
%     c1Cache: a precomputed set of C1 responses, as output by C1.m
%
% returns: 
%
%     c2r: an nPatches x nImgs matrix of C2 responses
%
%     c1Cache: a set of C1 responses
%
%     bestBands: the band whence came the maximal response for each patch and image
%
%     bestLocations: the (x,y) pair whence came the maximal response for each patch and image

if (nargin < 4) s2c1prune = -1; end;
if (nargin < 5) c1Cache   = cell(1,length(imgs)); end;

nImgs = length(imgs);
nPatchSizes = size(patchSizes,2);
nPatchesPerSize = size(patches{1},2);
nPatches = nPatchSizes*nPatchesPerSize;

% these manually set parameters are a hack...
orientations = [90 -45 0 45];
RFsizes      = [7:2:39];
div          = [4:-.05:3.2];
c1Space      = [8:2:22];
c1Scale      = [1:2:18];

% creates the gabor filters use to extract the S1 layer
[fSiz,filters,c1OL,~] = initGabor(orientations, RFsizes, div);

% because conv2 is faster than filter2
flippedPatches = flipPatches(patches,patchSizes);

c2r = zeros(nPatches,nImgs);
bestBands = zeros(nPatches,nImgs);
bestLocations = zeros(nPatches,nImgs,2);
bestLocations1 = zeros(nPatches,nImgs);
bestLocations2 = zeros(nPatches,nImgs);
parfor i = 1:nImgs
    % setup cache if available
    if isempty(c1Cache{1,i})
        c1  = [];
    else
        c1 = c1Cache{1,i};
    end
 
    iC2 = [];
    ibestbands = [];
    ibestlocations = [];
    for j = 1:nPatchSizes
        if isempty(c1),  %compute C2
            [jC2,~,c1,~,bestband,bestlocation] = C2locations(imgs{i},filters,fSiz,c1Space,c1Scale,c1OL,flippedPatches{j},[],patchSizes(:,j),s2c1prune);
            c1Cache{1,i} = c1;
        else
            [jC2,~,~,~,bestband,bestlocation] = C2locations(imgs{i},filters,fSiz,c1Space,c1Scale,c1OL,flippedPatches{j},c1,patchSizes(:,j),s2c1prune);
        end
        iC2 = [iC2; jC2];
        ibestbands = [ibestbands; bestband];
        ibestlocations = [ibestlocations; bestlocation];
    end
 
    c2r(:,i) = iC2;
    bestBands(:,i) = ibestbands;
    bestLocations1(:,i) = ibestlocations(:,1);
    bestLocations2(:,i) = ibestlocations(:,2);
end
bestLocations(:,:,1) = bestLocations1;
bestLocations(:,:,2) = bestLocations2;
