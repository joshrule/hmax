function iC2 = c2rFromImage(c2args,img)
% iC2 = c2rFromImage(c2args,img);
%
% a wrapper of C2. It extracts all the values of the C2 layer for all the 
% prototypes in the cell cPatches, for the image, img. The result iC2 is a
% vector of size total_num_patches where total_num_patches is the sum over
% i = 1:numPatchSizes of length(cPatches{i})
% c2args - for more detail regarding these parameters see the help entry for C1

filters = c2args.filters;
fSiz = c2args.filterSizes;
c1SpaceSS = c2args.c1SpaceSS;
c1ScaleSS = c2args.c1ScaleSS;
c1OL = c2args.c1OL;
cPatches = c2args.cPatches;
nPatchSizes = min(c2args.nPatchSizes, length(cPatches));

nPatchSizes = min(nPatchSizes,length(cPatches));
%all the patches are being flipped. This is becuase in matlab conv2 is much faster than filter2
parfor i = 1:nPatchSizes,
   [siz,nPatches] = size(cPatches{i});
   siz = sqrt(siz/4);
   for j = 1:nPatches
     tmp = reshape(cPatches{i}(:,j),[siz,siz,4]);
     tmp = tmp(end:-1:1,end:-1:1,:);
     cPatches{i}(:,j) = tmp(:);
   end
end

c1  = [];
iC2 = [];
for j = 1:nPatchSizes, %for every patch size
  if isempty(c1),  %compute C2
    [tmpC2,tmp,c1] = C2(img,filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,cPatches{j});
  else
    [tmpC2] = C2(img,filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,cPatches{j},c1);
  end
  iC2 = [iC2;tmpC2];
end
