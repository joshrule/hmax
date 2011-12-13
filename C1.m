% PROPRIETARY INFORMATION
% PROPRIETARY INFORMATION
% PROPRIETARY INFORMATION
% PROPRIETARY INFORMATION
%
% Copyright (c) 2010 by Jacob G. Martin - All Rights Reserved
%
% Redistribution and use in source and binary forms, with or without
% modification, are strictly prohibited.
%
% The name of Jacob G. Martin may not be used to endorse or promote products
% derived from or associated with this software without specific prior written
% permission.
%
% No products may be derived from or associated with this software without
% specific permission.
%
% This software is provided "AS IS," without a warranty of any
% kind. ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND
% WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE OR NON-INFRINGEMENT, ARE HEREBY
% EXCLUDED. Jacob G. Martin SHALL NOT BE LIABLE FOR ANY
% DAMAGES OR LIABILITIES SUFFERED BY ANY ORGANIZATION OR ITS
% LICENSEES AS A RESULT OF OR RELATING TO USE, MODIFICATION OR DISTRIBUTION OF
% THIS SOFTWARE OR ITS DERIVATIVES. IN NO EVENT WILL Jacob G. Martin BE LIABLE
% FOR ANY LOST REVENUE, PROFIT OR DATA, OR FOR DIRECT, INDIRECT,
% SPECIAL, CONSEQUENTIAL, INCIDENTAL OR PUNITIVE DAMAGES, HOWEVER
% CAUSED AND REGARDLESS OF THE THEORY OF LIABILITY, ARISING OUT OF
% THE USE OF OR INABILITY TO USE THIS SOFTWARE, EVEN IF Jacob G. Martin HAS
% BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES AND THE USER OF THIS CODE
% AGREES TO HOLD Jacob G. Martin HARMLESS THEREFROM.
%
% PROPRIETARY INFORMATION
% PROPRIETARY INFORMATION
% PROPRIETARY INFORMATION
% PROPRIETARY INFORMATION

function [c1,s1] = C1(img,filters,filterSizes,c1Space,c1Scale,c1OL,INCLUDEBORDERS)
% function [c1,s1] = C1(img,filters,filterSizes,c1Space,c1Scale,c1OL,INCLUDEBORDERS)
%
% MATLAB implementation of C1 code originally by Max Riesenhuber & Thomas Serre.
% Adapted by Stanley Bileschi
% Maintained by Jacob G. Martin, Josh Rule
%
% Given an image, returns C1 & S1 unit responses
%
% args:
%
%     img: a 2- or 3-dimensional matrix, the input image
%         must be grayscale and of type 'double'
%
%     INCLUDEBORDERS: "constant" scalar, defines border treatment for 'img'.
%
%     filters: (for S1 units) a matrix of Gabor filters of size
%         max_filterSizes x nFilters, where max_filterSizes is the length of the
%         largest filter & nFilters is the total number of filters. Column j of
%         'filters' contains a n_jxn_j filter, reshaped as a column vector
%         and padded with zeros. n_j = filterSizes(j).
%
%     filterSizes: (for S1 units) a vector, contains filter sizes.
%         filterSizes(i) = n if filters(i) is n x n (see 'filters' above).
%
%     c1Scale: (for C1 units) a vector, defines the scale bands, a group of
%         filter sizes over which a local max is taken to get C1 unit responses.
%         ex. c1Scale = [1 k num_filters+1] means 2 bands, the first with
%         filters(:,1:k-1) and the second with filters(:,k:num_filters).
%         If N bands, make length(c1Scale) = N+1.
%
%     c1Space: (for C1 units) a vector, defines the spatial pooling range of
%         each scale band, ex. c1Space(i) = m means that each C1 unit response
%         in band i is obtained by taking a max over a neighborhood of m x m
%         S1 units. If N bands, make length(c1Space) = N.
%
%     c1OL: (for C1 units) a scalar, defines the overlap between C1 units.
%         In scale band i, C1 unit responses are computed every c1Space(i)/c1OL.

USECONV2 = 1; % should be faster if 1. Why?
USE_NORMXCORR_INSTEAD = 0;
if(nargin < 7) INCLUDEBORDERS = 1; end;

nBands=length(c1Scale)-1;
nScales=c1Scale(end)-1; % last element in c1Scale is max index + 1
nFilters=floor(length(filterSizes)/nScales);
scalesInThisBand=cell(1,nBands);
for iBand = 1:nBands
    scalesInThisBand{iBand} = c1Scale(iBand):(c1Scale(iBand+1) -1);
end

% rebuild all filters (of all sizes) %
nFilts = length(filterSizes);
for i = 1:nFilts
    sqfilter{i} = reshape(filters(1:(filterSizes(i)^2),i),filterSizes(i),filterSizes(i));
    if USECONV2
        % flip to use conv2 instead of imfilter
        sqfilter{i} = sqfilter{i}(end:-1:1,end:-1:1);
    end
end

% compute all filter responses (s1) %

% (1) precalculate normalizations for the usable filter sizes
img = padImage(img,64,0.0); % pad with zeros to avoid edge effects
imgSquared = img.^2;
iUFilterIndex = 0;
uFiltSizes = unique(filterSizes);
for i = 1:length(uFiltSizes)
    s1Norm{uFiltSizes(i)} = (sumFilter(imgSquared,(uFiltSizes(i)-1)/2)).^0.5;
    % avoid divide by zero
    s1Norm{uFiltSizes(i)} = s1Norm{uFiltSizes(i)} + ~s1Norm{uFiltSizes(i)};
end

% (2) apply filters
for iBand = 1:nBands
    for iScale = 1:length(scalesInThisBand{iBand})
        for iFilt = 1:nFilters
            iUFilterIndex = iUFilterIndex+1;
            if ~USECONV2
                s1{iBand}{iScale}{iFilt} = abs(imfilter(img,sqfilter{iUFilterIndex},'symmetric','same','corr'));
                if(~INCLUDEBORDERS)
                   s1{iBand}{iScale}{iFilt} = removeborders(s1{iBand}{iScale}{iFilt},filterSizes(iUFilterIndex));
                end
                s1{iBand}{iScale}{iFilt} = im2double(s1{iBand}{iScale}{iFilt}) ./ s1Norm{filterSizes(iUFilterIndex)};
            else % not 100% compatible but 20% faster at least
                s1{iBand}{iScale}{iFilt} = abs(conv2(img,sqfilter{iUFilterIndex},'same'));
                if(~INCLUDEBORDERS)
                    s1{iBand}{iScale}{iFilt} = removeborders(s1{iBand}{iScale}{iFilt},filterSizes(iUFilterIndex));
                end
                s1{iBand}{iScale}{iFilt} = im2double(s1{iBand}{iScale}{iFilt}) ./ s1Norm{filterSizes(iUFilterIndex)};
            end
        end
    end
end

% Calculate local pooling (c1) %

% (1) pool over scales within band
for iBand = 1:nBands
    for iFilt = 1:nFilters
        c1{iBand}(:,:,iFilt) = zeros(size(s1{iBand}{1}{iFilt}));
        for iScale = 1:length(scalesInThisBand{iBand});
            c1{iBand}(:,:,iFilt) = max(c1{iBand}(:,:,iFilt),s1{iBand}{iScale}{iFilt});
        end
    end
end

% (2) pool over local neighborhood
for iBand = 1:nBands
    poolRange = (c1Space(iBand));
    for iFilt = 1:nFilters
        myc1{iBand}(:,:,iFilt)  = maxFilter(c1{iBand}(:,:,iFilt),poolRange);
    end
end
clear c1;
c1 = myc1;

%   (3) subsample
%  for iBand = 1:nBands
%    s=ceil(c1Space(iBand)/c1OL);
%    clear T;
%    for iFilt = 1:nFilters
%      T(:,:,iFilt) = c1{iBand}(1:s:end,1:s:end,iFilt);
%    end
%    c1{iBand} = T;
%  end

end

function sout = removeborders(sin,siz)
sin = unpadImage(sin, [(siz+1)/2,(siz+1)/2,(siz-1)/2,(siz-1)/2]);
sin = padarray(sin, [(siz+1)/2,(siz+1)/2],0,'pre');
sout = padarray(sin, [(siz-1)/2,(siz-1)/2],0,'post');
end
