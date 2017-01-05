function [y] = Iprime(x)
% derivative of I
mask0 = (abs(x)<1e-10);
mask1 = (abs(x-1) < 1e-10);
y = 0.5*(log(x)-log(1-x));
y(mask0) = 0;
y(mask1) = 0;
end