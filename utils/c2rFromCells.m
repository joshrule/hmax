function c2r = c2rFromCells(cImgs, c2args, fn)
% c2r = c2rFromCells(cImgs, c2args)
%
% a wrapper for C2.
% For each image in the cell cImgs, extract all the values of the C2 layer for 
% all the prototypes in the cell cPatches.
% The result c2r is a matrix of size total_num_patches \times length(cImgs)
% c2args - to understand the necessary parameters, see C2.m and C1.m
% fn - a function handle used to manipulate the img before processing

if nargin < 3, fn = @(x) x; end
c2r = [];
for i = 1:length(cImgs) % for each image
    img = rgb2gray(fn(imread(cImgs{i})));
    iC2 = c2rFromImage(c2args,img);
    c2r = [c2r iC2];
end
