function imgs = loadImages(directory, extension)
% imgs = loadImages(directory,extension)
%
% gives a cell array of images from the given directory, converted to grayscale

imgList = dir(fullfile(directory, ['*.' extension]));
imgPaths = arrayfun(@(x) fullfile(directory,x.name),imgList,'UniformOutput',0);
imgs = cellfun(@(x) rgb2gray(imread(x)), imgPaths, 'UniformOutput', 0);