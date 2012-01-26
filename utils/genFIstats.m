function fi = genFIstats(patchSpecs, c2r, targs, dtors)
% fi = genFIstats(patchSpecs, c2r, targs, dtors)
%
% generate a struct with Fisher Information statistics about the patches
%
% args:
%
%    patchSpecs: see structs.m
%
%    c2r: an nPatches x nImages matrix of C2 responses
%
%    targs: a list of indexes of target images in the C2 responses
%
%    dtors: a list of indexes of distractor images in the C2 responses
%
% returns: fi, a struct containing Fisher Information stats calculated below

fisherInformation = fisher(c2r(:,targs)', c2r(:,dtors)');
[fi.sortedFI, fi.patchIndices] = sort(fisherInformation,'descend');
nPatchSizes = size(patchSpecs.patchSizes,2);
nPatchesPerSize = patchSpecs.patchesPerSize;

fi.means = zeros(1,nPatchSizes);
fi.stds  = zeros(1,nPatchSizes);

for i = 1:nPatchSizes
    fi.means(i) = mean(fisherInformation((nPatchesPerSize*(i-1)+1):nPatchesPerSize*i));
    fi.stds(i)  =  std(fisherInformation((nPatchesPerSize*(i-1)+1):nPatchesPerSize*i));
end
