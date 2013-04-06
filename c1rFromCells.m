function c1cell = c1rFromCells(imgs,params)
% c1cell = c1rFromCells(imgs,filters,filterSizes,c1OL,c1Space,c1Scale)
%
% A C1.m wrapper. For each image in 'imgs', extract all C1 layer responses.
% Extra complexity comes from caching
%
% args:
%
%     imgs: a cell array of matrices, each representing an image
%
%     params: see getParamsForCategory.m
%
% returns: c1cell, a cell array of C1 responses, 1 set per image

c1cell = cell(1,length(imgs));
for i = 1:length(imgs)
    c1r = {};
    dummy = struct;
    cacheFile = [imgs{i} '.c1.mat'];
    if exist(cacheFile,'file')
        loaded = load(cacheFile,'c1r');
    end
    if exist('loaded','var') && isfield(loaded,'c1r')
        c1r = loaded(1).c1r;
    else
        img = double(resizeImage(grayImage(imread(imgs{i})),params.maxSize));
        c1r = C1(img,...
                params.filters,...
                params.filterSizes,...
                params.c1Space,...
                params.c1Scale,...
                params.c1OL);
        dummy.c1r = c1r;
        saveWrapper(cacheFile,dummy);
    end
    c1cell{i} = c1r;
end
