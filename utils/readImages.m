function imgs = readImages(imgList)
% imgs = readImages(imgList)
%
% given a cell aray of image filenames, return a cell array of image matrices
% prepared for processing by HMAX (grayscale doubles).
%
% args: imgList, a cell array of image filenames
%
% returns: imgs, a cell array of matrices representing images

imgs = cell(1, length(imgList));
parfor i = 1:length(imgList)
    imgs{i} = double(rgb2gray(imread(imgList{i})));
end
