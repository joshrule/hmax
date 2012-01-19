function c1r = genC1R(imgs,filters,filterSizes,c1OL,c1Space,c1Scale)
%
% A C1.m wrapper. For each image in 'imgs', extract all C1 layer responses.
%
% args:
%
%    imgs: a cell array of matrices, each representing an image
%
%    filters, filterSizes, c1OL, c1Space, c1Scale: see C1.m
%
% returns: c1r, a cell array of C1 responses, 1 set per image

c1r = cell(1,length(imgs));
for i = 1:length(imgs) % for each image
    [c1r{i},~] = C1(imgs{i},filters,filterSizes,c1Space,c1Scale,c1OL);
end
