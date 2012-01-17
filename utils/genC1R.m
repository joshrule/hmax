function c1r = genC1R(cImgs,filters,filterSizes,c1OL,c1Space,c1Scale)
%
% a wrapper for C2.
% For each image in the cell cImgs, extract all the values of the C2 layer for 
% all the prototypes in the cell cPatches.
% The result c2r is a matrix of size total_num_patches \times length(cImgs)
% c2args - to understand the necessary parameters, see C2.m and C1.m
% fn - a function handle used to manipulate the img before processing

c1r = cell(1,length(cImgs));
for i = 1:length(cImgs) % for each image
    img = rgb2gray(imread(cImgs{i}));
    [iC1,~] = C1(img,filters,filterSizes,c1Space,c1Scale,c1OL);
    c1r{i} = iC1;
end
