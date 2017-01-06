function [y] = I(x)
% [y] = I(x) evaluates I(x) = 0.5 * (x*log(x) + (1-x)*log(1-x))
% y = 0.5 * (x*log(x) + (1-x)*log(1-x));
mask0 = (abs(x)<1e-8);
mask1 = (abs(x-1) < 1e-8);
y = 0.5 * (x.*log(x) + (1-x).*log(1-x));
y(mask0) = 0;
y(mask1) = 0;
end
