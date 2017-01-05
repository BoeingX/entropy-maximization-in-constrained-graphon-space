td = csvread('data/TriangleDensities.csv', 1);
td(:, end+1) = 0.5*(td(:, 2) + td(:, 3));
rho0 = td(10, 1);
tau0 = td(10, end);
constraints.rho0 = rho0;
constraints.tau0 = tau0;
f_opts = [inf];
for N = 3:5
    N
    [g, c, f] = optimize_direct(N, constraints, min(f_opts));
    f_opts = [f_opts, f];
end
