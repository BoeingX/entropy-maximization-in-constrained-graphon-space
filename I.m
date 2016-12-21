function [y] = I(x)
% [y] = I(x) evaluates I(x) = 0.5 * (x*log(x) + (1-x)*log(1-x))
y = 0.5 * (x*log(x) + (1-x)*log(1-x));
end
