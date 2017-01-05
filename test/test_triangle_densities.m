% read triangle densities
td = csvread('data/TriangleDensities.csv', 1);
% generate triangle densities for which N=2 
% does not give a non-empty feasible region
td(:, end+1) = 0.5*(td(:, 2) + td(:, 3));
% number of test cases
N_cases = length(td);
% prepare array to store smallest N which gives non empty feasible region 
% and its corresponding objective function value
Ns = zeros(1, N_cases);
fs = zeros(1, N_cases);% read triangle densities
td = csvread('data/TriangleDensities.csv', 1);
% generate triangle densities for which N=2 
% does not give a non-empty feasible region
td(:, end+1) = 0.5*(td(:, 2) + td(:, 3));
% number of test cases
N_cases = length(td);
% prepare array to store smallest N which gives non empty feasible region 
% and its corresponding objective function value
Ns = zeros(1, N_cases);
fs = zeros(1, N_cases);
for i = 1:N_cases
    message = ['[INFO] case '  int2str(i)  ' / '  int2str(N_cases)];
    disp(message);
    rho0 = td(i, 1);
    tau0 = td(i, end);
    constraints.rho0 = rho0;
    constraints.tau0 = tau0;
    for N = 2:16
        [g, c, f, flag] = optimize_direct(N, constraints, inf);
        if ~isnan(flag)
            Ns(i) = N;
            fs(i) = f;
            break;
        end
    end
end