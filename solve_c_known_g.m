function [c] = solve_c_known_g(g, N, constraints)
c = rand(N, 1);
c = c./sum(c);

[Aeq, beq] = linear_constraints_eq(N, 'c');
lb = zeros(size(c));
ub = ones(size(c));
nonlconc = @(x)nonlinear_constraints(g, x, N, constraints);

opts = optimoptions(@fmincon,'Algorithm','sqp','Display','off', 'ConstraintTolerance', 1e-20);
[c] = fmincon(@(x)0, c, [], [], Aeq, beq, lb, ub, nonlconc, opts);
end
