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
% derived from or associated with this software without specific prior written permission.
% 
% No products may be derived from or associated with this software without specific permission.
%
% This software is provided "AS IS," without a warranty of any
% kind. ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND
% WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE OR NON-INFRINGEMENT, ARE HEREBY
% EXCLUDED. Jacob G. Martin SHALL NOT BE LIABLE FOR ANY
% DAMAGES OR LIABILITIES SUFFERED BY ANY ORGANIZATION OR ITS
% LICENSEES AS A RESULT OF OR RELATING TO USE, MODIFICATION OR DISTRIBUTION OF THIS
% SOFTWARE OR ITS DERIVATIVES. IN NO EVENT WILL Jacob G. Martin BE LIABLE
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


function maxval = mymaxfilter(image,poolrange)

    [numrows numcols] = size(image);
    halfpool = poolrange/2;

    therowindices = 1:halfpool:(numrows - poolrange) + poolrange;
    thecolindices = 1:halfpool:(numcols - poolrange) + poolrange;
    maxval = zeros(size(therowindices,2),size(thecolindices,2));
    xcount = 1;
    ycount = 1;
    for i=therowindices
        for j=thecolindices
            maxval(xcount,ycount) = max(max(image(i:min(i+poolrange-1,numrows),j:min(j+poolrange-1,numcols))));
            ycount=ycount+1;
        end
        xcount=xcount+1;
        ycount=1;
    end
end

