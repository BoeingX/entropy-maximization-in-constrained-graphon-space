function [g] = solve_g_known_c(c, N, constraints)
g = rand(N);
g = (g + g')/2;
g = reshape(g, [], 1);

[Aeq, beq] = linear_constraints_eq(N, 'g');
lb = zeros(size(g));
ub = ones(size(g));
nonlcong = @(x)nonlinear_constraints(x, c, N, constraints);

opts = optimoptions(@fmincon,'Algorithm','interior-point','Display','off', 'ConstraintTolerance', 1e-20);

g = fmincon(@(x)0,g,[],[],Aeq,beq,lb,ub,nonlcong,opts);
end
