function [ C2gauss ] = C2gaussian(C2dist, C2sigma)
%C2gaussian takes the Euclidean distance activation of C2 and makes a
%gaussian response function.

C2gauss = exp(-(C2dist.^2)./(2*C2sigma.^2));

end
