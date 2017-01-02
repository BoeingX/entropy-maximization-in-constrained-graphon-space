function [g_opt, c_opt, f_opt, flag] = optimize(N, constraints, f_opt_prior, N_init)
if nargin < 4
    N_init = 4;
end
g_opt = zeros(N*N, N_init);
c_opt = zeros(N, N_init);
f_opt = zeros(1, N_init);
for i = 1:N_init
    [g, c, f, flag] = optimize_single(N, constraints, f_opt_prior);
    if flag < 0
        g_opt = zeros(N*N);
        c_opt = zeros(N, 1);
        f_opt = inf;
        return
    end
    g_opt(:, i) = g;
    c_opt(:, i) = c;
    f_opt(:, i) = f(end);
    f_opt_prior = min(f_opt);
end
[f_opt, I] = min(f_opt);
g_opt = g_opt(:, I);
c_opt = c_opt(:, I);
end

function [g, c, f, flag] = optimize_single(N, constraints, f_opt_prior, tol)
if nargin < 4
    tol = 1e-6;
end
[g, c, flag] = initialize(N, constraints, 100);
if flag < 0
    f = Inf
    return
end
fs = [Inf];
retry = 0;
max_retry = 10;
while retry < max_retry
    while true
        [c, f] = optimize_c(g, c, N, constraints);
        [g, f] = optimize_g(g, c, N, constraints);
        if abs(f - fs(end)) < tol
            break
        end
        fs = [fs, f];
    end
    [cueq, ceq] = nonlinear_constraints(g, c, N, constraints);
    if (f(end) > f_opt_prior) || (sum(abs(ceq) > 1e-10) ~= 0)
        [g, c] = initialize(N, constraints, 100);
        fs = [Inf];
    else
        return
    end
    retry = retry + 1;
end
end
