function [dg11, dg12, dg21, dg22, df] = compare(constraints)
N = 2;
dg11 = [];
dg12 = [];
dg21 = [];
dg22 = [];
df = [];
rho0 = constraints.rho0;
tau0 = constraints.tau0;
if (tau0^2 - rho0^3) < 1e-6
    g_true = reshape([1; 0; 0; 0], N, []);
    c_true = [sqrt(rho0); 1 - sqrt(rho0)];
    f_true = 0;
elseif rho0 < 0.5 && tau0 == 0
    g_true = reshape([0, 2*rho0; 2*rho0, 0], N, []);
    c_true = [0.5; 0.5];
    f_true = entropy(g_true, c_true, N);
elseif rho0 == 0.5 && tau0 <= 0.125
    a = 0.5 - (0.5^3 - tau0)^(1/3);
    b = 0.5 + (0.5^3 - tau0)^(1/3);
    g_true = reshape([a, b; b, a], N, []);
    c_true = [0.5; 0.5];
    f_true = entropy(g_true, c_true, N);
end
algorithms = cell(4, 1);
algorithms{1} = 'baseline';
algorithms{2} = 'ga';
algorithms{3} = 'al';
for i = 1:1
    algorithm = algorithms{i}
    [g, c, f, flag] = optimize(N, constraints, inf, algorithm);
    g = reshape(g, N, []);
    if g(1,1) < g(2, 2)
        t = g(1, 1);
        g(1, 1) = g(2, 2);
        g(2, 2) = t;
    end
    dg = abs(g - g_true);
    dg11 = [dg11; dg(1, 1)];
    dg12 = [dg12; dg(1, 2)];
    dg21 = [dg21; dg(2, 1)];
    dg22 = [dg22; dg(2, 2)];
    df = [df; abs(f - f_true)];
end
end
