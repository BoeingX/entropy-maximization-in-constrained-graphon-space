function [g_opt, f_opt] = optimize_g(g, c, N, constraints)
% fix c, optimize g
fung = @(x)entropy(x, c, N);

% characterize a symmetric matrix
% by a linear system Aeq * g = 0 := beq
[Aeq, beq] = linear_constraints_eq(N);
lb = zeros(size(g));
ub = ones(size(g));

options = optimoptions('fmincon','Display', 'iter', 'MaxFunctionEvaluation', 1e5);
nonlcong = @(x)nonlinear_constraints(x, c, N, constraints);
[g_opt, f_opt] = fmincon(fung, g, [], [], Aeq, beq, lb, ub, nonlcong, options);
end
