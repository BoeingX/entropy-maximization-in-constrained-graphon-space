function [g_opt, f_opt] = optimize_g(g, c, N, constraints)
% fix c, optimize g
fung = @(x)entropy(x, c, N);

% characterize a symmetric matrix
% by a linear system Aeq * g = 0 := beq
Aeq = zeros((N-1)*N/2, N*N);
idx = 1;
for i = 1:N
    for j = (i+1):N
        k = sub2ind([N, N], i, j);
        kc = sub2ind([N, N], j, i);
        Aeq(idx, k) = 1;
        Aeq(idx, kc) = -1;
        idx = idx+1;
    end
end
beq = zeros((N-1)*N/2, 1);
lb = zeros(size(g));
ub = ones(size(g));

options = optimoptions('fmincon','Display', 'iter', 'MaxFunctionEvaluation', 1e5);
nonlcong = @(x)nonlinear_constraints(x, c, N, constraints);
[g_opt, f_opt] = fmincon(fung, g, [], [], Aeq, beq, lb, ub, nonlcong, options);
end
