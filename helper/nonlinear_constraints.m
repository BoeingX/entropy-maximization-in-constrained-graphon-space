function [cueq, ceq] = nonlinear_constrains(g, c, N, constraints)
cueq = [];
ceq = [rho(g, c, N) - constraints.rho0, tau(g, c, N) - constraints.tau0];
end
