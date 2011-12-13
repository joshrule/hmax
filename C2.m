function [c2,s2,c1,s1] = C2(img,filters,filterSizes,c1Space,c1Scale,c1OL,patches,c1)
% function [c2,s2,c1,s1] = C2(img,filters,filterSizes,c1Space,c1Scale,c1OL,patches,c1)
%
% Maintained by Jacob G. Martin, Josh Rule
%
% Given an image, returns S1, C1, S2, & C2 unit responses.
%
% args:
%
%     img: a 2- or 3-dimensional matrix, the input image
%         must be grayscale and of type 'double'
%
%     filters, filterSizes, c1Space, c1Scale, C1OL: see C1.m
%
%     patches: a 2-dimensional matrix, the prototypes (patches) used in the
%     extraction of s2. Each patch of size [n,n,d] is stored as a column in
%     patches, which has itself a size of [n*n*d, n_patches];
%
%     c1: a precomputed c1 layer can be used to save computation time if
%         available.  The proper format is the output of C1.m
%
% See also C1 (C1.m)

if (nargin < 8) [c1,s1] = C1(img,filters,filterSizes,c1Space,c1Scale,c1OL); end;

nBands = length(c1);
c1BandImage = c1;
nFilters = size(c1{1},3);
nRBFcenters = size(patches,2);
L = size(patches,1) / nFilters;
patchSize = [L^.5,L^.5,nFilters];

% Build s2:
s2 = cell(nRBFcenters,1);
for iCenter = 1:nRBFcenters % for all prototypes in patches (RBF centers)
    patch = reshape(patches(:,iCenter),patchSize);
    s2{iCenter} = cell(nBands,1);
    for iBand = 1:nBands % for all bands
        % calculate the image response
        s2{iCenter}{iBand} = windowedPatchDistance(c1BandImage{iBand},patch);
    end
end

% Build c2:
c2 = inf(nRBFcenters,1);
for iCenter = 1:nRBFcenters % for all prototypes
    for iBand = 1:nBands % for all bands
        % calculate min. distance (max. stimulation) across position and scales
        c2(iCenter) = min(c2(iCenter),min(min(s2{iCenter}{iBand})));
    end
end
