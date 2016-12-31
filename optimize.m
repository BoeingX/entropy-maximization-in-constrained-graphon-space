function [g_opt, c_opt, f_opt] = optimize(N, constraints, N_init)
if nargin < 3
    N_init = 10;
end
f_opt = Inf
for i = 1:N_init
    [g, c, f] = optimize_single(N, constraints, 1e-6);
    if f(end) < f_opt(end)
        g_opt = g;
        c_opt = c;
        f_opt = f;
    end
end
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
    if sum(ceq > 1e-10) ~= 0
        [g, c] = initialize(N, constraints);
        fs = [Inf];
    end
end
end
