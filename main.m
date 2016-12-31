function [g, c, f_opt] = main()
N = 2;
constraints.rho0 = 0.3;
constraints.tau0 = 0;
[g, c] = initialize(N, constraints);
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
end
