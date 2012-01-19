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


function [c2,s2,c1,s1,bestbandnums,bestlocations] = C2locations(stim,filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,s2Target,c1,patchSize,s2c1prune)
% [c2,s2,c1,s1,bestbandnums,bestlocations] = C2locations(stim,filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,s2Target,c1,patchSize,s2c1prune)
%
% given an image extracts layers s1 c1 s2 and finally c2
% for inputs stim, filters, fSiz, c1SpaceSS,c1ScaleeSS, and c1OL
% see the documentation for C1 (C1.m)
%
% briefly, 
% stim is the input image. 
% filters fSiz, c1SpaceSS, c1ScaleSS, c1OL are the parameters of
% the c1 process
%
% s2Target are the prototype (patches) to be used in the extraction
% of s2.  Each patch of size [n,n,d] is stored as a column in s2Target,
% which has itself a size of [n*n*d, n_patches];
%
% if available, a precomputed c1 layer can be used to save computation
% time.  The proper format is the output of C1.m
%
% See also C1

% c1 = [];
s1 = [];
bestbandnum = [];
bestlocation = [];

if nargin<8 || length(c1) == 0
  [c1,s1] = C1(stim,filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL);
end

nbands = length(c1);
c1BandImage = c1;
nfilts = size(c1{1},3);
n_rbf_centers = size(s2Target,2);

PatchSize = [patchSize(1,1),patchSize(2,1),nfilts];

s2 = cell(n_rbf_centers,1);

%Build s2:
%  for all prototypes in s2Target (RBF centers)
%   for all bands
%    calculate the image response
for iCenter = 1:n_rbf_centers
  Patch = reshape(s2Target(:,iCenter),PatchSize);
  s2{iCenter} = cell(nbands,1);
  for iBand = 1:nbands
     s2{iCenter}{iBand} = windowedPatchDistance(c1BandImage{iBand},Patch,s2c1prune);  
  end
end

%Build c2:
% calculate minimum distance (maximum stimulation) across position and scales
c2 = inf(n_rbf_centers,1);

bestlocations = zeros(n_rbf_centers,2);
bestbandnums = zeros(n_rbf_centers,1);
for iCenter = 1:n_rbf_centers
  bestbandnum = -1;
  for iBand = 1:nbands
     [minval minlocation] = min(s2{iCenter}{iBand}(:));
     oldvalue = c2(iCenter);
     [c2(iCenter)] = min(c2(iCenter),minval);
     if bestbandnum == -1 || oldvalue > c2(iCenter)
        bestbandnum = iBand;
        [bestlocation(1,1) bestlocation(1,2)] = ind2sub(size(s2{iCenter}{iBand}),minlocation);
     end
  end
  bestlocations(iCenter,1) = bestlocation(1,1);
  bestlocations(iCenter,2) = bestlocation(1,2);
  bestbandnums(iCenter,1) = bestbandnum;
  
  % [r c] = ind2sub([10 10], 31)
end
