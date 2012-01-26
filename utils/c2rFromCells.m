function [c2r, c1Cache] = c2rFromCells(imgs,c2args,c1Cache)
% c2r = c2rFromCells(imgs, c2args, fn)
%
% A C2.m wrapper. For each image in 'imgs', extract all C2 layer responses.
%
% args:
%
%     imgs: a cell array of matrices, each representing an image
%
%     c2args: see below, C2.m and C1.m
%
%     c1Cache: a precomputed set of C1 responses
%
% returns: 
%
%     c2r: an nPatches x nImages matrix of C2 responses
%
%     c1Cache: a precomputed set of C1 responses

if (nargin < 3) c1Cache = cell(1,length(imgs)); end;

filters = c2args.filters;
fSiz = c2args.filterSizes;
c1Space = c2args.c1Space;
c1Scale = c2args.c1Scale;
c1OL = c2args.c1OL;
patches = c2args.cPatches;
patchSizes = c2args.patchSizes;

nPatchSizes = size(patchSizes,2);
nPatchesPerSize = size(patches{1},2);
nPatches = nPatchSizes * nPatchesPerSize;
nImgs = length(imgs);

% because conv2 is faster than filter2
flippedPatches = flipPatches(patches,patchSizes);

c2r = zeros(nPatches,nImgs);
parfor i = 1:length(imgs) % for each image
    % setup cache if available
    if isempty(c1Cache{1,i})
        c1  = [];
    else
        c1 = c1Cache{1,i};
    end

    iC2 = [];
    for j = 1:nPatchSizes, %for every patch size
        if isempty(c1)
            [jC2,~,c1,~] = C2(imgs{i},filters,fSiz,c1Space,c1Scale,c1OL,flippedPatches{j});
            c1Cache{1,i} = c1;
        else
            [jC2,~,~,~]  = C2(imgs{i},filters,fSiz,c1Space,c1Scale,c1OL,flippedPatches{j},c1);
        end
        iC2 = [iC2; jC2];
    end
    c2r(:,i) = iC2;
end
