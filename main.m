N = 10;
constraints.rho0 = 1/2;
constraints.tau0 = 1/8;
[g, c] = initialize(N, constraints, false);
f_opts = [Inf];
tol = 1e-6;
while true
    [c, f_opt] = optimize_c(g, c, N, constraints);
    [g, f_opt] = optimize_g(g, c, N, constraints);
    if abs(f_opt - f_opts(end)) < tol
        break
    end
    f_opts = [f_opts, f_opt];
end
