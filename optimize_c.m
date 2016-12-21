function [c_opt, f_opt] = optimize_c(g, c, N, constraints)
func = @(x)entropy(g, x, N);
options = optimoptions('fmincon','Display', 'iter', 'MaxFunctionEvaluation', 1e5);
Aeq = ones(size(c'));
beq = 1;
lb = zeros(size(c));
ub = ones(size(c));
nonlconc = @(x)nonlinear_constraints(g, x, N, constraints);
[c_opt, f_opt] = fmincon(func, c, [], [], Aeq, beq, lb, ub, nonlconc, options);
end
