function [g_opt, c_opt, f_opt] = optimize(N, constraints, N_init)
if nargin < 3
    N_init = 10;
end
g_opt = zeros(N*N, N_init);
c_opt = zeros(N, N_init);
f_opt = zeros(1, N_init);
parfor i = 1:N_init
    [g, c, f] = optimize_single(N, constraints, 1e-6);
    g_opt(:, i) = g;
    c_opt(:, i) = c;
    f_opt(:, i) = f(end);
end
[f_opt, I] = min(f_opt);
g_opt = g_opt(:, I);
c_opt = c_opt(:, I);
end

function [g, c, f] = optimize_single(N, constraints, tol)
if nargin < 3
    tol = 1e-6;
end
[g, c] = initialize(N, constraints);
fs = [Inf];
while true
    [c, f] = optimize_c(g, c, N, constraints);
    [g, f] = optimize_g(g, c, N, constraints);
    if abs(f - fs(end)) < tol
        break
    end
    fs = [fs, f];
    [cueq, ceq] = nonlinear_constraints(g, c, N, constraints);
    if sum(abs(ceq) > 1e-10) ~= 0
        [g, c] = initialize(N, constraints);
        fs = [Inf];
    end
end
end
