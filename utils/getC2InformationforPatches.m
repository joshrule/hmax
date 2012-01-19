function [C2results bestbands bestlocations] = getC2InformationforPatches(image,cPatches,c1Cache,numPatchSizes,patchSizes)
    rot        = [90 -45 0 45];
    c1ScaleSS  = [1:2:18];
    RF_siz     = [7:2:39];
    c1SpaceSS  = [8:2:22];
    Div        = [4:-.05:3.2];

    %creates the gabor filters use to extract the S1 layer
    [fSiz,filters,c1OL,numSimpleFilters] = initGabor(rot, RF_siz, Div);

    %The actual C2 features are computed below for each one of the training/testing directories
    Cim = cell(1,1);
    Cim{1}(:,:) = image{1,1}(:,:);
    [C2results C1cache bestbands bestlocations]  = extractC2forcell(filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,cPatches,Cim,numPatchSizes,patchSizes,0.0,c1Cache(1,1));
