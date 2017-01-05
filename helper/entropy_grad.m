function [grad] = entropy_grad(g, c, N, variable)
% compute the gradient of H with respect to the given variable
% g: a column vector of size NxN
% c: a column vector of size N
if nargin < 4
    variable = 'all';
end

if strcmp(variable, 'g')
    grad = reshape(c*c', [], 1).*Iprime(g);
elseif strcmp(variable, 'c')
    grad = 2*reshape(I(g), N, [])*c;
else
    grad1 = reshape(c*c', [], 1).*Iprime(g);
    grad2 = 2*reshape(I(g), N, [])*c;
    grad = [grad1; grad2];
end
end