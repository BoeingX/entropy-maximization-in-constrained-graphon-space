function [y] = I(x)
% [y] = I(x) evaluates I(x) = 0.5 * (x*log(x) + (1-x)*log(1-x))
% y = 0.5 * (x*log(x) + (1-x)*log(1-x));
mask0 = (x==0);
mask1 = (x==1);
y = 0.5 * (x.*log(x) + (1-x).*log(1-x));
y(mask0) = 0;
y(mask1) = 0;
end
