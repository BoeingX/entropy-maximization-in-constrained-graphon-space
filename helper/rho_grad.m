function [grad] = rho_grad(g, c, N, variable)
% gradient of rho
if nargin < 4
    variable = 'all';
end

if strcmp(variable, 'g')
    grad = reshape(c*c', [], 1);
elseif strcmp(variable, 'c')
    grad = 2*reshape(g, N, [])*c;
else
    grad1 = reshape(c*c', [], 1);
    grad2 = 2*reshape(g, N, [])*c;
    grad = [grad1;grad2];
end
end