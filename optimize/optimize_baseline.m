function [g, c, f, flag, history] = optimize_baseline(N, constraints, f_opt_prior)
flag = -1;
max_retry = 10;
num_retry = 0;
history.x = [];
history.fval = [];
while num_retry < max_retry
    g = rand(N*N, 1);
    c = rand(N, 1);
    x = [g; c];
    options = optimoptions('fmincon','Algorithm', 'sqp', 'Display', 'off', 'ConstraintTolerance', 1e-10, 'GradObj', 'on', 'OutputFcn',@outfun);
    func_grad = @(x)compute_func_grad(x, N);
    [Aeq_g, beq_g] = linear_constraints_eq(N, 'g');
    [Aeq_c, beq_c] = linear_constraints_eq(N, 'c');
    [n11, n12] = size(Aeq_g);
    [n21, n22] = size(Aeq_c);
    Aeq = [Aeq_g, zeros(n11, n22); zeros(n21, n12), Aeq_c];
    beq = [beq_g; beq_c];
    lb = zeros(size(x));
    ub = ones(size(x));
    nonlcon = @(x)nonlinear_constraints(x(1:N*N), x((N*N+1):end), N, constraints);
    [x, f, flag] = fmincon(func_grad, x, [], [], Aeq, beq, lb, ub, nonlcon, options);
    g = x(1:N*N);
    c = x((N*N+1):end);
    if flag >= 0 && f < f_opt_prior
        return
    end
    num_retry = num_retry + 1;
end
function stop = outfun(x,optimValues,state)
    stop = false;
    history.fval = [history.fval; optimValues.fval];
    history.x = [history.x; x];
end
end
function [obj, grad] = compute_func_grad(u, N)
obj = entropy(u(1:N*N), u((N*N+1):end), N);
grad = entropy_grad(u(1:N*N), u((N*N+1):end), N);
end


