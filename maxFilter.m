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

function maxValues = maxFilter(img,poolSize)
% function maxValues = maxFilter(img,poolSize)
%
% Maintained by Jacob G. Martin, Josh Rule
%
% given an image and pooling range, returns an matrix of the maximum values in
% the image in each pooling neighborhood
%
% args:
%
%     img: a 2-dimensional matrix, the image to be filtered
%
%     poolSize: a scalar, P, such that each maximum will be taken over a PxP
%         area of pixels

[nRows nCols] = size(img);
halfpool = poolSize/2;
rowIndices = 1:halfpool:(nRows-poolSize)+poolSize;
colIndices = 1:halfpool:(nCols-poolSize)+poolSize;
maxValues = zeros(size(rowIndices,2),size(colIndices,2));
xCount = 1;
yCount = 1;

for r = rowIndices
    for c = colIndices
        maxValues(xCount,yCount) = max(max(img(r:min(r+poolSize-1,nRows),...
                                               c:min(c+poolSize-1,nCols))));
        yCount = yCount+1;
    end
    xCount = xCount+1;
    yCount = 1;
end
