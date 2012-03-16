function [c2,c1,bestBands,bestLocations,s2,s1] = extractC2FromCell(filters,filterSizes,c1Space,c1Scale,c1OL,linearPatches,imgs,nPatchSizes,patchSizes,ALLS2C1PRUNE,c1,ORIENTATIONS2C1PRUNE,IGNOREPARTIALS)
% [c2,c1,bestBands,bestLocations,s2,s1] = extractC2FromCell(filters,filterSizes,c1Space,c1Scale,c1OL,linearPatches,imgs,nPatchSizes,patchSizes,ALLS2C1PRUNE,c1,ORIENTATIONS2C1PRUNE,IGNOREPARTIALS)
%
% For each image in 'imgs', extract all responses.
%
% args:
%
%     imgs: a cell array of matrices, each representing an image
%
%     filters,filterSizes: see initGabor.m
%
%     c1Space,c1Scale,c1OL: see C1.m
%
%     linearPatches: a cell array with 1 cell/patchSize, each cell holds an
%         patchSizeX * patchSizeY * nOrientations x nPatchesPerSize matrix
%
%     nPatchSizes: size(patchSizes,2) - kept only for backward compatibility
%
%     patchSizes: a 3 x nPatchSizes array of patch sizes 
%     Each column should hold [nRows; nCols; nOrients]
%
%     c1: a precomputed set of C1 responses, as output by C1.m
%
%     IGNOREPARTIALS: see C2.m
%
%     ALLS2C1PRUNE,ORIENTATIONS2C1PRUNE: see windowedPatchDistance.m
%
% returns: 
%
%     c2: a nPatches x nImgs array holding C2 activations
%
%     s2,c1,s1: cell arrays holding the particular s2, c1, or s1 response for
%     each image, see C2.m, C1.m
%
%     bestBands: a nPatches x nImgs array, the band whence came the maximal
%     response for each patch and image
%
%     bestLocations: a nPatches x nImgs x 2 array, the (x,y) pair whence came
%     the maximal response for each patch and image

    nImgs = length(imgs);
    nPatchSizes = size(patchSizes,2);
    nPatchesPerSize = size(linearPatches{1},2);
    nPatches = nPatchSizes*nPatchesPerSize;

    if (nargin < 13) IGNOREPARTIALS = 0; end;
    if (nargin < 12) ORIENTATIONS2C1PRUNE = 0; end;
    if (nargin < 11 || isempty(c1)) c1 = cell(1,nImgs); end;
    if (nargin < 10) ALLS2C1PRUNE = 0; end;

    % because conv2 is faster than filter2
    flippedPatches = flipPatches(linearPatches,patchSizes);

    c2 = zeros(nPatches,nImgs);
    s2 = cell(1,nImgs);
    s1 = cell(1,nImgs);
    bestBands = zeros(nPatches,nImgs);
    bestLocations = zeros(nPatches,nImgs,2);
    for iImg = 1:nImgs
        for iPatch = 1:nPatchSizes
            patchIndices = (nPatchesPerSize*(iPatch-1)+1):(nPatchesPerSize*iPatch);
            if isempty(c1{iImg}),  %compute C1 & S1
                [c2(patchIndices,iImg),s2{iImg}{iPatch},c1{iImg},s1{iImg},bestBands(patchIndices,iImg),bestLocations(patchIndices,iImg,:)] =...
                C2(imgs{iImg},filters,filterSizes,c1Space,c1Scale,c1OL,flippedPatches{iPatch},patchSizes(:,iPatch)',[],IGNOREPARTIALS,ALLS2C1PRUNE,ORIENTATIONS2C1PRUNE);
                s2{iImg}{iPatch} = 0; % takes too much memory
                s1{iImg} = 0; % takes too much memory
            else
                [c2(patchIndices,iImg),s2{iImg}{iPatch},~,~,bestBands(patchIndices,iImg),bestLocations(patchIndices,iImg,:)] =...
                C2(imgs{iImg},filters,filterSizes,c1Space,c1Scale,c1OL,flippedPatches{iPatch},patchSizes(:,iPatch)',c1{iImg},IGNOREPARTIALS,ALLS2C1PRUNE,ORIENTATIONS2C1PRUNE);
                s2{iImg}{iPatch} = 0; % takes too much memory
            end
        end
    end
end

function flippedPatches = flipPatches(patches,patchSizes)
% flippedPatches = flipPatches(patches,patchSizes)
%
% flips all patches, because in MATLAB conv2 is much faster than filter2.
% It does NOT affect C1 code, which uses imfilter (patches are not used in C1).
%
% args:
%
%     patches: a cell array with 1 cell/patchSize, each cell holds an
%     patchSizeX * patchSizeY * nOrientations x nPatchesPerSize matrix
%   
%     patchSizes: a 3 x nPatchSizes matrix of patch sizes 
%     Each column should hold [nRows; nCols; nOrients]
%
% returns: flippedPatches, identical to patches but all patches are flipped

    nPatchSizes = size(patchSizes,2);
    nPatchesPerSize = size(patches{1},2);

    flippedPatches = cell(1,nPatchSizes);
    parfor i = 1:nPatchSizes
        sizeX = patchSizes(1,i);
        sizeY = patchSizes(2,i);
        flippedPatches{i} = zeros(size(patches{i}));
        for j = 1:nPatchesPerSize
            squarePatch = reshape(patches{i}(:,j),[sizeX,sizeY,4]);
            flippedPatch = squarePatch(end:-1:1,end:-1:1,:);
            flippedPatches{i}(:,j) = flippedPatch(:);
        end
    end
end
