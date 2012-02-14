function [c2,s2,c1,s1] = C2(img,filters,filterSizes,c1Space,c1Scale,c1OL,patches,c1)
% function [c2,s2,c1,s1] = C2(img,filters,filterSizes,c1Space,c1Scale,c1OL,patches,c1)
%
% Given an image, returns S1, C1, S2, & C2 unit responses.
%
% args:
%
%     img: a 2-dimensional matrix, the input image must be grayscale and of
%     type 'double'
%
%     filters, filterSizes, c1Space, c1Scale, C1OL: see C1.m
%
%     patches: a 2-dimensional matrix, the prototypes (patches) used in the
%     extraction of s2. Each patch of size [n,n,d] is stored as a column in
%     patches, which has itself a size of [n*n*d, n_patches];
%
%     c1: a precomputed c1 layer can be used to save computation time if
%     available.  The proper format is the output of C1.m
%
% returns:
%
%     c2: a matrix [nPatches 1], contains the C2 responses for img
%
%     s2: a cell array [nPatches 1], contains the S2 responses for img
%
%     c1,s1: see C1.m
%
% See also C1 (C1.m)

s1 = [];
if (nargin < 8) [c1,s1] = C1(img,filters,filterSizes,c1Space,c1Scale,c1OL); end;

nBands = length(c1);
c1BandImage = c1;
nFilters = size(c1{1},3);
nPatches = size(patches,2);
L = size(patches,1) / nFilters;
patchSize = [L^.5,L^.5,nFilters];

% Build s2:
s2 = cell(nPatches,1);
for iPatch = 1:nPatches
    % make patch rectangular again
    patch = reshape(patches(:,iPatch),patchSize);
    s2{iPatch} = cell(nBands,1);
    for iBand = 1:nBands
        s2{iPatch}{iBand} = windowedPatchDistance(c1BandImage{iBand},patch);
    end
end

% Build c2:
c2 = inf(nPatches,1);
for iPatch = 1:nPatches
    for iBand = 1:nBands
        % calculate min. distance (max. stimulation) across position and scales
        c2(iPatch) = min(c2(iPatch),min(min(s2{iPatch}{iBand})));
    end
end
