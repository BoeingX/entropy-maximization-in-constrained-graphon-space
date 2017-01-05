N = 2;
%% case 1
rho0s = linspace(0, 1, 11);
tau0s = sqrt(rho0s.^3);
dg11s = [];
dg12s = [];
dg21s = [];
dg22s = [];
dfs = [];
for i = 1:10
    rho0 = rho0s(i);
    tau0 = tau0s(i);
    constraints.rho0 = rho0;
    constraints.tau0 = tau0;
    [dg11, dg12, dg21, dg22, df] = compare(constraints);
    dg11s = [dg11s, dg11];
    dg12s = [dg12s, dg12];
    dg21s = [dg21s, dg21];
    dg22s = [dg22s, dg22];
    dfs = [dfs, df];
end
%%% case 2
%rho0 = 0.3;
%tau0 = 0;
%constraints.rho0 = rho0;
%constraints.tau0 = tau0;
%[g, c, f] = optimize_direct(N, constraints, inf);
%g_true = reshape([0, 2*rho0; 2*rho0, 0], [], 1);
%c_true = solve_c_known_g(g_true, N, constraints);
%f_true = entropy(g_true, c_true, N);
%abs(f - f_true)
%
%%% case 3
%rho0 = 0.5;
%tau0 = 0.125;
%constraints.rho0 = rho0;
%constraints.tau0 = tau0;
%[g, c, f] = optimize_direct(N, constraints, inf);
%f_true = -log(2)/2;
%abs(f - f_true)
%
%%% case 4
%rho0 = 0.5;
%tau0 = 0.125;
%constraints.rho0 = rho0;
%constraints.tau0 = tau0;
%[g, c, f] = optimize_direct(N, constraints, inf);
%g_true = reshape([0.5-(0.5^3-tau0)^(1/3), 0.5+(0.5^3-tau0)^(1/3); 0.5+(0.5^3-tau0)^(1/3), 0.5-(0.5^3-tau0)^(1/3)], [], 1);
%c_true = solve_c_known_g(g_true, N, constraints);
%f_true = entropy(g_true, c_true, N);
%abs(f - f_true)
