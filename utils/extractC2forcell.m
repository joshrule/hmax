% PROPRIETARY INFORMATION
% PROPRIETARY INFORMATION
% PROPRIETARY INFORMATION
% PROPRIETARY INFORMATION
%
% Copyright (c) 2010 by Jacob G. Martin - All Rights Reserved
%
% Redistribution and use in source and binary forms, with or without
% modification, are strictly prohibited.
%
% The name of Jacob G. Martin may not be used to endorse or promote products
% derived from or associated with this software without specific prior written permission.
% 
% No products may be derived from or associated with this software without specific permission.
%
% This software is provided "AS IS," without a warranty of any
% kind. ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND
% WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE OR NON-INFRINGEMENT, ARE HEREBY
% EXCLUDED. Jacob G. Martin SHALL NOT BE LIABLE FOR ANY
% DAMAGES OR LIABILITIES SUFFERED BY ANY ORGANIZATION OR ITS
% LICENSEES AS A RESULT OF OR RELATING TO USE, MODIFICATION OR DISTRIBUTION OF THIS
% SOFTWARE OR ITS DERIVATIVES. IN NO EVENT WILL Jacob G. Martin BE LIABLE
% FOR ANY LOST REVENUE, PROFIT OR DATA, OR FOR DIRECT, INDIRECT,
% SPECIAL, CONSEQUENTIAL, INCIDENTAL OR PUNITIVE DAMAGES, HOWEVER
% CAUSED AND REGARDLESS OF THE THEORY OF LIABILITY, ARISING OUT OF
% THE USE OF OR INABILITY TO USE THIS SOFTWARE, EVEN IF Jacob G. Martin HAS
% BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES AND THE USER OF THIS CODE
% AGREES TO HOLD Jacob G. Martin HARMLESS THEREFROM.
%
% PROPRIETARY INFORMATION
% PROPRIETARY INFORMATION
% PROPRIETARY INFORMATION
% PROPRIETARY INFORMATION


function [mC2 c1Cache bestbands bestlocations ] = extractC2forcell(filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,cPatches,cImages,numPatchSizes,patchSizes, s2c1prune,c1Cache)
%function mC2 = extractC2forcell(filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,cPatches,cImages,numPatchSizes);
%
%this function is a wrapper of C2. For each image in the cell cImages, 
%it extracts all the values of the C2 layer 
%for all the prototypes in the cell cPatches.
%The result mC2 is a matrix of size total_number_of_patches \times number_of_images where
%total_number_of_patches is the sum over i = 1:numPatchSizes of length(cPatches{i})
%and number_of_images is length(cImages)
%The C1 parameters used are given as the variables filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL
%for more detail regarding these parameters see the help entry for C1
%
%See also C1
%
% also returns the best band and the best location within that band

if nargin < 10, s2c1prune = -1; end
if nargin < 11, c1Cache   = []; end

%all the patches are being flipped. This is becuase in matlab conv2 is much
%faster than filter2. This does NOT affect the C1 level code which uses imfilter
%because patches are not used in C1.
parfor i = 1:numPatchSizes,
  [siz,numpatch] = size(cPatches{i});
  sizex = patchSizes(1,i);
  sizey = patchSizes(2,i);
  for j = 1:numpatch,
    tmp = reshape(cPatches{i}(:,j),[sizex,sizey,4]);
    tmp = tmp(end:-1:1,end:-1:1,:);
    cPatches{i}(:,j) = tmp(:);
  end
end

mC2 = [];
bestbands = [];
bestlocations = [];

if isempty(c1Cache)
    c1Cache = cell(1,length(cImages));
end

for i = 1:length(cImages), %for every input image
  stim = cImages{i};
  if isempty(c1Cache{1,i})
     c1  = [];
  else
     c1 = c1Cache{1,i};
  end
  iC2 = [];
  ibestbands = [];
  ibestlocations = [];
  
  for j = 1:numPatchSizes, %for every unique patch size
    if isempty(c1),  %compute C2
      [tmpC2,tmp,c1,~,bestbandnum,bestlocation] = C2(stim,filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,cPatches{j},[],patchSizes(:,j),s2c1prune);
      c1Cache{1,i} = c1;
    else
      [tmpC2,s2,~,~,bestbandnum,bestlocation] = C2(stim,filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,cPatches{j},c1,patchSizes(:,j),s2c1prune);
    end
    iC2 = [iC2;tmpC2];
    ibestbands = [ibestbands;bestbandnum];
    ibestlocations = [ibestlocations;bestlocation];
  end
  mC2 = [mC2, iC2];
  bestbands = [bestbands,ibestbands];
  bestlocations = [bestlocations,ibestlocations];
end
