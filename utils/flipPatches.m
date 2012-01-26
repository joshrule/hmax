function flippedPatches = flipPatches(patches,patchSizes)
% flippedPatches = flipPatches(patches,patchSizes)
%
% flips all patches, because in MATLAB conv2 is much faster than filter2.
% It does NOT affect C1 code, which uses imfilter (patches are not used in C1).
%
% args:
%
%    patches: a cell array with 1 cell/patchSize, each cell holds an
%        patchSizeX * patchSizeY * nOrientations x nPatchesPerSize matrix
%
%    patchSizes: a 2 x nPatchSizes matrix of patch sizes [sizeX; sizeY]
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
