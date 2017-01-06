N = 2;
n = 11;
%% case 1
rho0s = linspace(0, 1, n);
tau0s = sqrt(rho0s.^3);
dg11s = [];
dg12s = [];
dg21s = [];
dg22s = [];
dfs = [];
for i = 1:n
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
%% case 2
rho0s = linspace(0.1, 0.5, n);
tau0s = zeros(size(rho0s));
dg11s = [];
dg12s = [];
dg21s = [];
dg22s = [];
dfs = [];
for i = 1:n
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

%% case 3
tau0s = linspace(0.1, 0.125, n);
rho0s = 0.5*ones(size(tau0s));
dg11s = [];
dg12s = [];
dg21s = [];
dg22s = [];
dfs = [];
for i = 1:n
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
