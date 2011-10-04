function paths = lsCell(directory, extension)
% paths = lsCell(directory, extension)
%
% gives a cell array of path for images in the given directory

imgList = dir(fullfile(directory, ['*.' extension]));
paths = arrayfun(@(x) fullfile(directory,x.name),imgList,'UniformOutput',0);