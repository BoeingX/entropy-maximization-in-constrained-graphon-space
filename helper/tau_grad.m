function [grad] = tau_grad(g, c, N, variable)
% gradient of tau
if nargin < 4
    variable = 'all';
end

if strcmp(variable, 'g')
    g = reshape(g, N, []);
    grad = 3*(c*c').*(g.*(g*diag(c)*g));
    grad = grad(:);
elseif strcmp(variable, 'c')
    g = reshape(g, N, []);
    grad = 3*diag((g*diag(c))^3);
else
    g = reshape(g, N, []);
    grad1 = 3*(c*c').*(g'*diag(c)*g');
    grad2 = 3*diag((g*diag(c))^2*g);
    grad = [grad1(:);grad2];
end
end