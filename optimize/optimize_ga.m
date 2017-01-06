function [g, c, f, flag, history] = optimize_direct_single(N, constraints, f_opt_prior)
flag = -1;
max_retry = 10;
num_retry = 0;
[Aeq_g, beq_g] = linear_constraints_eq(N, 'g');
[Aeq_c, beq_c] = linear_constraints_eq(N, 'c');
[n11, n12] = size(Aeq_g);
[n21, n22] = size(Aeq_c);
Aeq = [Aeq_g, zeros(n11, n22); zeros(n21, n12), Aeq_c];
Beq = [beq_g; beq_c];
nvars = N*N + N;
% x here is a ROW vector
func = @(x)entropy(x(1:N*N)', x((N*N+1):end)', N);
nonlcon = @(x)nonlinear_constraints(x(1:N*N)', x((N*N+1):end)', N, constraints);
history.x = [];
history.fval = [];
while num_retry < max_retry
    % create problem
    problem.fitnessfcn = func;
    problem.nvars = nvars;
    problem.Aineq = [];
    problem.Bineq = [];
    problem.Aeq = Aeq;
    problem.Beq = Beq;
    problem.lb = zeros(1, nvars);
    problem.ub = ones(1, nvars);
    problem.nonlcon = nonlcon;
    problem.solver = 'ga';
    options = gaoptimset('Display', 'off', 'NonlinConAlgorithm', 'penalty', 'tolcon', 1e-6, 'OutputFcn',@outfun);
    problem.options = options;
    [x, f, flag] = ga(problem);
    g = x(1:N*N)';
    c = x((N*N+1):end)';
    if flag >= 0 && f < f_opt_prior
        return
    end
    num_retry =  num_retry + 1;
end
function stop = outfun(x,optimValues,state)
    stop = false;
    history.fval = [history.fval; optimValues.fval];
    history.x = [history.x; x];
end
end
