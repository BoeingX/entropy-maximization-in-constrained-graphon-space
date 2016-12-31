N = 2;
%% case 1
rho0 = 0.3;
tau0 = 0;
constraints.rho0 = rho0;
constraints.tau0 = tau0;
[g, c, f_opt] = optimize(N, constraints);
g_true = reshape([0, 2*rho0; 2*rho0, 0], [], 1);
c_true = solve_c_known_g(g_true, N, constraints);
f_true = entropy(g_true, c_true, N);
