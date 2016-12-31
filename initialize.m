function [g_init, c_init] = initialize_single(N, constraints)
c_init = rand(N, 1);
c_init = c_init ./ sum(c_init);
g = rand(N);
g = (g + g')/2;
g = reshape(g, [], 1);

[Aeq, beq] = linear_constraints_eq(N);
lb = zeros(size(g));
ub = ones(size(g));
nonlcong = @(x)nonlinear_constraints(x, c_init, N, constraints);

opts = optimoptions(@fmincon,'Algorithm','interior-point','Display','off');
g_init = fmincon(@(x)0,g,[],[],Aeq,beq,lb,ub,nonlcong,opts);
end
