N = 2;
%% case 1
rho0 = 0.3;
tau0 = sqrt(rho0^3);
constraints.rho0 = rho0;
constraints.tau0 = tau0;
[g, c, f] = optimize(N, constraints, inf);
g_true = reshape([1, 0, 0, 0], [], 1);
c_true = [sqrt(rho0); sqrt(rho0)];
f_true = entropy(g_true, c_true, N);
abs(f - f_true)

%% case 2
rho0 = 0.3;
tau0 = 0;
constraints.rho0 = rho0;
constraints.tau0 = tau0;
[g, c, f] = optimize(N, constraints, inf);
g_true = reshape([0, 2*rho0; 2*rho0, 0], [], 1);
c_true = solve_c_known_g(g_true, N, constraints);
f_true = entropy(g_true, c_true, N);
abs(f - f_true)

%% case 3
rho0 = 0.5;
tau0 = 0.1;
constraints.rho0 = rho0;
constraints.tau0 = tau0;
[g, c, f] = optimize(N, constraints, inf);
g_true = reshape([0.5-(0.5^3-tau0), 0.5+(0.5^3-tau0); 0.5+(0.5^3-tau0), 0.5-(0.5^3-tau0)], [], 1);
c_true = solve_c_known_g(g_true, N, constraints);
f_true = entropy(g_true, c_true, N);
abs(f - f_true)

%% case 4
rho0 = 0.5;
tau0 = 0.125;
constraints.rho0 = rho0;
constraints.tau0 = tau0;
[g, c, f] = optimize(N, constraints, inf);
g_true = reshape([0.5-(0.5^3-tau0), 0.5+(0.5^3-tau0); 0.5+(0.5^3-tau0), 0.5-(0.5^3-tau0)], [], 1);
c_true = solve_c_known_g(g_true, N, constraints);
f_true = entropy(g_true, c_true, N);
abs(f - f_true)
