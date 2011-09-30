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


function [cPatches bandschosen patchsizeschosen] = extractRandC1Patches(cItrainingOnly, numPatchSizes, numPatchesPerSize, patchSizes);
%extracts random prototypes as part of the training of the C2 classification 
%system. 
%Note: we extract only from BAND 2. Extracting from all bands might help
%cPatches the returned prototypes
%cItrainingOnly the training images
%numPatchSizes is the number of sizes in which the prototypes come
%numPatchesPerSize is the number of prototypes extracted for each size
%patchSizes is the vector of the patche sizes

if nargin<2
  numPatchSizes = 4;
  numPatchesPerSize = 250;
  patchSizes = [4:4:16;4:4:16];
end

nImages = length(cItrainingOnly);

%----Settings for Training the random patches--------%
rot = [90 -45 0 45];
c1ScaleSS = [1 3];
RF_siz    = [11 13];
c1SpaceSS = [10];
minFS     = 11;
maxFS     = 13;
div = [4:-.05:3.2];
% Div       = div(3:4);
Div = div;
%--- END Settings for Training the random patches--------%

c1ScaleSS = [1:2:18];
RF_siz    = [7:2:39];
c1SpaceSS = [8:2:22];
minFS     = 7;
maxFS     = 39;

% fprintf(1,'Initializing gabor filters -- partial set...');
[fSiz,filters,c1OL,numSimpleFilters] = init_gabor(rot, RF_siz, Div);
% fprintf(1,'done\n');

cPatches = cell(numPatchSizes,1);
bsize = [0 0];

pind = zeros(numPatchSizes,1);
for j = 1:numPatchSizes
  cPatches{j} = zeros(patchSizes(1,j)*patchSizes(2,j) *4,numPatchesPerSize);
end

c1source = cell(1,5);
s1source = cell(1,5);
alltraining = cItrainingOnly(floor(rand(1,numPatchesPerSize)*nImages) + 1);
tic
parfor i = 1:numPatchesPerSize,
%   ii = floor(rand*nImages) + 1;
  fprintf(1,'.');
  stim = alltraining{i};
%   img_siz = size(stim);
  
  [c1source{i},s1source{i}] = C1(stim, filters, fSiz, c1SpaceSS, ...
      c1ScaleSS, c1OL);
end
toc
disp(['That was the time for extracting rand patches...']);
bandschosen = zeros(1,numPatchesPerSize * numPatchSizes);
patchsizeschosen = zeros(1,numPatchesPerSize * numPatchSizes);
count = 1;
for i=1:numPatchesPerSize
  b = c1source{i}(:,:,:); %new C1 interface;
  
  for j = 1:numPatchSizes
      foundband = 0;
      while (~foundband)
        % check to make sure that the 
        randbandindex = ceil(rand() * length(b));
        bsize(1) = size(b{randbandindex},1);
        bsize(2) = size(b{randbandindex},2);
        x = floor(rand(1,1).*(bsize(1)-patchSizes(1,j)))+1;
        y = floor(rand(1,1).*(bsize(2)-patchSizes(2,j)))+1;
        if x > 0 && y > 0
            foundband = 1;
            bandschosen(1,count) = randbandindex;
            patchsizeschosen(1,count) = j;
            count = count + 1;
        end
      end
    %     tmp = b{1}(xy(1):xy(1)+patchSizes(j)-1,xy(2):xy(2)+patchSizes(j)-1,:);  %    changed to extract from a random band
    
    tmp = b{randbandindex}(x:x+patchSizes(1,j)-1,y:y+patchSizes(2,j)-1,:);
    pind(j) = pind(j) + 1;
    cPatches{j}(:,pind(j)) = tmp(:); 
  end
end 
fprintf('\n');

end