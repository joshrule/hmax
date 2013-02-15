function c1r = c1rFromCells(imgs,params)
% c1r = c1rFromCells(imgs,filters,filterSizes,c1OL,c1Space,c1Scale)
%
% A C1.m wrapper. For each image in 'imgs', extract all C1 layer responses.
%
% args:
%
%     imgs: a cell array of matrices, each representing an image
%
%     params: see getParamsForCategory.m
%
% returns: c1r, a cell array of C1 responses, 1 set per image

c1r = cell(1,length(imgs));
parfor i = 1:length(imgs)
    img = double(resizeImage(grayImage(imread(imgs{i})),params.maxSize));
    c1r{i} = C1(img,...
                params.filters,...
                params.filterSizes,...
                params.c1Space,...
                params.c1Scale,...
                params.c1OL);
end
