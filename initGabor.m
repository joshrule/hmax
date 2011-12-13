function [filterSizes,filters,c1OL,nOrientations] = initGabor(orientations,RFsize,div)
% function [filterSizes,filters,c1OL,nOrientations] = initGabor(orientations,RFsize,div)
%
% By Thomas R. Serre, February 2003
% Maintained by Jacob G. Martin, Josh Rule
%
% given orientations and receptive field sizes, returns a set of Gabor filters
%
% args:
%
%     orientations: a list of filter orientations in degrees, ex. [90 45 0 -45]
%
%     RFsize: a list of receptive field sizes for the filters
%
%     div: a list of scaling factors tuning the wavelength of the sinusoidal
%         factor, 'lambda' in relation to the receptive field sizes
%         length(div) = length(RFsize)

c1OL          = 2;
nFilterSizes  = length(RFsize);
nOrientations = length(orientations);
nFilters      = nFilterSizes*nOrientations;
filterSizes   = zeros(nFilters,1); % vector of filter sizes
filters       = zeros(max(RFsize)^2,nFilters);

lambda = RFsize*2./div;
sigma  = lambda.*0.8;
gamma  = 0.3; % spatial aspect ratio: 0.23 < gamma < 0.92

for k = 1:nFilterSizes
    for r = 1:nOrientations
        theta        = orientations(r)*pi/180;
        filterSize   = RFsize(k);
        center       = ceil(filterSize/2);
        filterSizeL  = center-1;
        filterSizeR  = filterSize-filterSizeL-1;
        sigmaSquared = sigma(k)^2;
        
        for i = -filterSizeL:filterSizeR
            for j = -filterSizeL:filterSizeR
                if ( sqrt(i^2+j^2)>filterSize/2 )
                    E = 0;
                else
                    x = i*cos(theta) - j*sin(theta);
                    y = i*sin(theta) + j*cos(theta);
                    E = exp(-(x^2+gamma^2*y^2)/(2*sigmaSquared))*cos(2*pi*x/lambda(k));
                end
                f(j+center,i+center) = E;
            end
        end
       
        f = f - mean(mean(f));
        f = f ./ sqrt(sum(sum(f.^2)));
        iFilter = nOrientations*(k-1) + r;
        filters(1:filterSize^2,iFilter)=reshape(f,filterSize^2,1);
        filterSizes(iFilter)=filterSize;
    end
end
