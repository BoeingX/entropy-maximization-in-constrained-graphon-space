function [y] = Iprime(x)
% derivative of I
x(abs(x)<1e-20) = 1e-20;
x(abs(x-1) < 1e-20) = 1e-20;
y = 0.5*(log(x)-log(1-x));
end