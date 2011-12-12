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


    function D = WindowedPatchDistance(Im,Patch,s2c1prune)
    %function D = WindowedPatchDistance(Im,Patch)
    %
    %computes the euclidean distance between Patch and all crops of Im of
    %similar size.
    %
    % sum_over_p(W(p)-I(p))^2 is factored as
    % sum_over_p(W(p)^2) + sum_over_p(I(p)^2) - 2*(W(p)*I(p));
    %
    % Im and Patch must have the same number of channels
    %



    dIm = size(Im,3);
    dPatch = size(Im,3);
    if(dIm ~= dPatch)
      fprintf('The patch and image must be of the same number of layers');
    end
    % patches should be normalized.  1.0 0.9 0.8 0.7

    prunepatches = s2c1prune > 0;
    s = size(Patch);
    s(3) = dIm;
    if prunepatches
        Psqr = 0;
        for i = 1:dIm
            % if prune, only keep the patch values that are greater than the patchpruneamount
            indices(:,:) = Patch(:,:,i) > s2c1prune;
            Psqr = Psqr + sum(sum(sum( indices(:,:) .* Patch(:,:,i).^2)));
        end
    else
        Psqr = sum(sum(sum(Patch.^2)));
    end
    Imsq = Im.^2;
    Imsq = sum(Imsq,3);
    sum_support = [ceil(s(2)/2)-1,ceil(s(1)/2)-1,floor(s(2)/2),floor(s(1)/2)];
    Imsq = sumFilter(Imsq,sum_support);
    PI = zeros(size(Imsq));
    nPI = zeros(size(Imsq));


%     patchpruneamount = 0.10;
    [rows cols z] = size(Patch);
    indices = zeros(rows,cols);
    for i = 1:dIm
        if prunepatches
            % if prune, only keep the patch values that are greater than the patchpruneamount
            indices(:,:) = Patch(:,:,i) > s2c1prune;
             PI = PI + conv2(Im(:,:,i),indices(:,:) .* Patch(:,:,i), 'same');
%             PI = PI + cudaconv2(Im(:,:,i),indices(:,:) .* Patch(:,:,i));
        else
             PI = PI + conv2(Im(:,:,i),Patch(:,:,i), 'same');
%              newim = single(Im(:,:,i));
%              newp = single(Patch(:,:,i));
%              nPI = nPI + conv2(newim,newp, 'same');
%              PI2 = PI + convnfft(Im(:,:,i),Patch(:,:,i), 'same');  % slower!
%             PI = PI + cudaconv2(Im(:,:,i),Patch(:,:,i));
        end

    end

    tempval = Imsq - 2 * PI + Psqr;
    tempval(tempval < 0) = 0;
    D = sqrt(tempval) + 10^-10;
    if ~isreal(D)
       disp(['NOT REAL DATA!!!!!']); 
    end
end
