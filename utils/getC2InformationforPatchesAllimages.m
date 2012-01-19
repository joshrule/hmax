function [C2res] = getC2InformationforPatchesAllimages(images,cPatches,c1Cache, numPatchSizes,patchSizes)


    %----Settings for Training --------%
    rot        = [90 -45 0 45];
    c1ScaleSS  = [1:2:18];
    RF_siz     = [7:2:39];
    c1SpaceSS  = [8:2:22];
    minFS      = 7;
    maxFS      = 39;
    div        = [4:-.05:3.2];
    % now get the activations for these patches
    % For each patch and image in the training, 
    % compute the outputs from the model
    %creates the gabor filters use to extract the S1 layer
    [fSiz,filters,c1OL,numSimpleFilters] = initGabor(rot, RF_siz, div);
    
    disp(['Calculating C1 responses in getC2InformationforPatches for training image.']);
    
    numimages = length(images);
    numpatches = length(cPatches) * size(cPatches{1},2);
    
    C2res = zeros(numpatches,numimages);
    
    %The actual C2 features are computed below for each one of the training/testing directories
    parfor i=1:numimages
        img = images{i};
        Cim = cell(1,1);
        Cim{1}(:,:) = img(:,:);
        C2res(:,i) = extractC2forcell(filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,cPatches,Cim,numPatchSizes,patchSizes,0.0,c1Cache(1,i));
    end
               
end
