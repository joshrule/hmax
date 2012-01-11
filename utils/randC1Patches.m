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


function [cPatches bandschosen imgChosen patchsizeschosen] = randC1Patches(cItrainingOnly, numPatchesPerSize, patchSizes);
% extracts random prototypes for the training of the C2 classification system.
% cPatches the returned prototypes
% imgChosen, the image the patch came from
% cItrainingOnly the training images
% numPatchesPerSize is the number of prototypes extracted for each size
% patchSizes is the vector of the patch sizes

if nargin<2
  numPatchesPerSize = 250;
  patchSizes = [4:4:16;4:4:16];
end

%----Settings for Training the random patches--------%
%c1ScaleSS = [1 3];
%RF_siz    = [11 13];
%c1SpaceSS = [10];
%minFS     = 11;
%maxFS     = 13;
nImages = length(cItrainingOnly);
nPatchSizes = size(patchSizes,2);
nPatchesTotal = nPatchSizes*numPatchesPerSize;
rot = [90 -45 0 45];
Div = [4:-.05:3.2];
c1ScaleSS = [1:2:18];
RF_siz    = [7:2:39];
c1SpaceSS = [8:2:22];
minFS     = 7;
maxFS     = 39;
%--- END Settings for Training the random patches--------%

% initialize Gabor filters
[fSiz,filters,c1OL,numSimpleFilters] = initGabor(rot, RF_siz, Div);

% select patch source images and get their S1/C1 activations
fprintf('reading images\n');
sourceImgs = cItrainingOnly(floor(rand(1,nPatchesTotal)*nImages)+1);
parfor i = 1:numPatchesPerSize % we reuse images for multiple patches
    stim = rgb2gray(imread(sourceImgs{i})); % WARNING: side-effects.
    [c1source(i,:,:,:),~] = C1(stim,filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL);
    fprintf(',');
    if mod(i,100) == 0
        fprintf('\n');
    end
end

% initialize neccesary arrays/cells
fprintf('initializing arrays\n');
cPatches = cell(nPatchSizes,1);
bsize = [0 0];
pind = zeros(nPatchSizes,1);
parfor j = 1:nPatchSizes
  cPatches{j} = zeros(patchSizes(1,j)*patchSizes(2,j) *4,numPatchesPerSize);
end
bandschosen = zeros(1,numPatchesPerSize * nPatchSizes);
patchsizeschosen = zeros(1,numPatchesPerSize * nPatchSizes);
imgChosen = cell(1,numPatchesPerSize * nPatchSizes);

% select a patch from a random C1 band
fprintf('creating patches\n');
count = 1;
for i=1:numPatchesPerSize
    b = c1source(i,:,:,:);
    for j = 1:nPatchSizes
        foundband = 0;
        while (~foundband)
            randbandindex = ceil(rand() * length(b));
            bsize(1) = size(b{randbandindex},1);
            bsize(2) = size(b{randbandindex},2);
            x = floor(rand()*(bsize(1)-patchSizes(1,j)))+1;
            y = floor(rand()*(bsize(2)-patchSizes(2,j)))+1;
            if x > 0 && y > 0
                foundband = 1;
                bandschosen(1,count) = randbandindex;
                patchsizeschosen(1,count) = j;
                imgChosen{1,count} = sourceImgs{i};
                fprintf('.');
                if mod(count,100) == 0
                    fprintf('\n');
                end
                count = count + 1;
            end
        end
        tmp = b{randbandindex}(x:x+patchSizes(1,j)-1,y:y+patchSizes(2,j)-1,:);
        pind(j) = pind(j) + 1;
        cPatches{j}(:,pind(j)) = tmp(:); 
    end
end 
