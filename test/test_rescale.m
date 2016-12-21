N = 10;
c = rand(N, 1);
g = rand(N);
g = (g + g')/2;
g = reshape(g, [], 1);
rho0 = 1/2;
tau0 = 1/8;
[g, c] = rescale(g, c, N, rho0, tau0);
sum(c)
rho(g, c, N)
tau(g, c, N)
