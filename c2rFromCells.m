function c2r = c2rFromCells(cImgs, c2args)
% c2r = c2rFromCells(cImgs, c2args)
%
% a wrapper for C2.
% For each image in the cell cImgs, extract all the values of the C2 layer for 
% all the prototypes in the cell cPatches.
% The result mC2 is a matrix of size total_num_patches \times num_images where
% total_num_patches is the sum over i = 1:numPatchSizes of length(cPatches{i})
% and num_images is length(cImgs).
% For more details on the parameters specified in c2args, see C2.m and C1.m

filters = c2args.filters;
fSiz = c2args.filterSizes;
c1SpaceSS = c2args.c1SpaceSS;
c1ScaleSS = c2args.c1ScaleSS;
c1OL = c2args.c1OL;
cPatches = c2args.cPatches;
nPatchSizes = min(c2args.nPatchSizes, length(cPatches));
nImgs = length(cImgs);

%all patches are flipped, becuase matlab's conv2 is much faster than filter2
parfor i = 1:nPatchSizes,
    [siz,numpatch] = size(cPatches{i});
    siz = sqrt(siz/4);
    for j = 1:numpatch,
        tmp = reshape(cPatches{i}(:,j),[siz,siz,4]);
        tmp = tmp(end:-1:1,end:-1:1,:);
        cPatches{i}(:,j) = tmp(:);
    end
end

c2r = [];
parfor i = 1:nImgs % for each image
    c1  = [];
    iC2 = [];
    img = rgb2gray(imread(cImgs{i}));
    for j = 1:nPatchSizes, %for each patch size
        if isempty(c1),  %compute C2
            [tmpC2,~,c1] = C2(img,filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,...
                              cPatches{j});
        else
            [tmpC2] = C2(img,filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,...
                         cPatches{j},c1);
        end
        iC2 = [iC2;tmpC2];
    end
    c2r = [c2r, iC2];
end
