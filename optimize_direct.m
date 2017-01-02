function [g_opt, c_opt, f_opt, flag_opt] = optimize_direct(N, constraints, N_init)
g_opt = zeros(N*N, N_init);
c_opt = zeros(N, N_init);
f_opt = zeros(1, N_init);
flag_opt = zeros(1, N_init);
for i = 1:N_init
    [g, c, f, flag] = optimize_direct_single(N, constraints);
    g_opt(:, i) = g;
    c_opt(:, i) = c;
    f_opt(:, i) = f(end);
    flag_opt(:, i) = flag; 
end
idx = find(flag_opt > 0);
if ~isempty(idx)
    [f_opt, idx] = min(f_opt);
    g_opt = g_opt(:, idx);
    c_opt = c_opt(:, idx);
    flag_opt = flag_opt(:, idx);
    return
end
flag_opt = NaN;
end

function [g, c, f, flag] = optimize_direct_single(N, constraints)
flag = -1;
max_retry = 10;
num_retry = 0;
while flag < 0 || num_retry > max_retry
    g = rand(N*N, 1);
    c = rand(N, 1);
    x = [g; c];
    options = optimoptions('fmincon','Algorithm', 'sqp', 'Display', 'off', 'ConstraintTolerance', 1e-20);
    func = @(x)entropy(x(1:N*N), x(N*N+1:end), N);
    [Aeq_g, beq_g] = linear_constraints_eq(N, 'g');
    [Aeq_c, beq_c] = linear_constraints_eq(N, 'c');
    Aeq = [Aeq_g, zeros(size(Aeq_c)); zeros(size(Aeq_g)), Aeq_c];
    beq = [beq_g; beq_c];
    lb = zeros(size(x));
    ub = ones(size(x));
    nonlcon = @(x)nonlinear_constraints(x(1:N*N), x(N*N+1:end), N, constraints);
    [x, f, flag] = fmincon(func, x, [], [], Aeq, beq, lb, ub, nonlcon, options);
    g = x(1:N*N);
    c = x(N*N+1, end);
    num_retry = num_retry + 1;
end
end
