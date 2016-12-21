N = 10;
constraints.rho0 = 1/2;
constraints.tau0 = 1/8;
[g, c] = initialize(N, constraints, false);

% fix c, optimize g
fun = @(x)entropy(x, c, N);

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

options = optimoptions('fmincon','Display', 'iter', 'MaxFunctionEvaluation', 1e10)
nonlcon = @(x)nonlinear_constraints(x, c, N, constraints);
g_opt = fmincon(fun, g, [], [], Aeq, beq, lb, ub, nonlcon, options);
g_opt
