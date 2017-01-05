function [grad] = linear_constraints_grad(Aeq, N, variable)
% gradient of the linear constraints function
if nargin < 3
    variable = 'all';
end
if strcmp(variable, 'g')
    grad = Aeq(1:N*N);
elseif strcmp(variable, 'c')
    grad = Aeq((N*N+1):end);
else
    grad = Aeq;
end
    
end