function [c2,s2,c1,s1,patches,filters,totalTime] = hmaxExample(imgPath)
% [c2,s2,c1,s1,patches,filters,totalTime] = hmaxExample(imgPath)
%
% given the path to an image, returns unit responses for that image, the
% patches and filters used, and total run time
%
% An example showing how HMAX is initalized and used. 
%
% args:
%
%     imgPath: the directory path to an image
%
% returns:
%
%     c2,s2,c1,s1: see C1.m and C2.m
%
%     patches: the randomly generated patches used for computing S2 responses
%
%     filters: the gabor filters used for computing S1 responses
%
%     totalTime: total run time, in seconds, of the example

tic; % start the timer

fprintf('initializing S1 gabor filters\n');
orientations = [90 -45 0 45]; % 4 orientations for gabor filters
RFsizes      = 7:2:39;        % receptive field sizes
div          = 4:-.05:3.2;    % tuning parameters for the filters' "tightness"
[filterSizes,filters,c1OL,~] = initGabor(orientations,RFsizes,div);
size(filterSizes)
    
fprintf('initializing C1 parameters\n')
c1Scale = 1:2:18; % defining 8 scale bands
c1Space = 8:2:22; % defining spatial pooling range for each scale band
  
fprintf('initializing random S2 patches\n')
patchSizes = repmat([4,8,16,32],1,100); % 4*100 = 400 C2 units
nPatches = size(patchSizes,2); % total number of patches needed
nOrientations = length(orientations); % four orientations for S1 -> four for S2
patches = zeros((max(patchSizes)^2)*nOrientations,nPatches); % empty patch array
for x=1:nPatches % for each patch
    % generate a random patch
    randPatch = round(10*rand((patchSizes(x)^2)*nOrientations,1));
    % and normalize it
    patches(1:(patchSizes(x)^2)*nOrientations,x) = randPatch./norm(randPatch);
end

fprintf('calculating unit responses\n');
img = double(rgb2gray(imread(imgPath))); % read image
[c2,s2,c1,s1] = C2(img,filters,filterSizes,c1Space,c1Scale,c1OL,patches); 

totalTime = toc; % stop the timer
