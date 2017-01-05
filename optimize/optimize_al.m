function [g, c, f, flag] = optimize_la(N, constraints, f_opt_prior, algorithm)
if nargin < 4
    algorithm = 'al'
end
n_constraints = N*(N-1)/2 + 3;
nvars = N*N + N;
lb = zeros(nvars, 1);
ub = ones(nvars, 1);
options = optimoptions('fmincon','Algorithm', 'interior-point', 'Display', 'off', 'ConstraintTolerance', 1e-10);
if strcmp(algorithm, 'al')
    x = rand(nvars, 1);
    y_k = rand(n_constraints, 1);
    lambda_k = rand();
    eta = 1e-6;
    eta_0 = 1e-1;
    eta_k = 1e-1;
    converged = false;
    alpha = 0.5;
    beta = 0.5;
    t = 1.1;
    while ~converged
        func = @(u) entropy(u(1:N*N), u((N*N+1):end), N) ...
                - y_k' * con(u, N ,constraints) + 0.5*lambda_k*((norm(con(u, N, constraints)))^2);
        [x_opt, L, flag, ~, ~, z_opt, ~] = fmincon(func, x, [], [], [], [], lb, ub, [], options);
        if norm(con(x_opt, N ,constraints)) < max(eta, eta_k)
            y_opt = y_k - lambda_k*con(x, N, constraints);
            x = x_opt;
            y = y_opt;
            z = z_opt;
            if norm(abs(con(x, N, constraints))) < 1e-6 && (isempty(find(x < 0))) ...
                & (isempty(find(x > 1)))
                converged = true;
            end
            eta_k = eta_k / (1 + lambda_k^beta);
        else
            lambda_k = lambda_k * t;
            eta_k = eta_0 / (1 + lambda_k^alpha);
        end
    end
    [g, c] = get_gc(x, N);
    f = entropy(g, c, N);
    flag = 1;
end
end
function [y] = con(x, N, constraints)
[g, c] = get_gc(x, N);
y = [con1(g, c, N); con2(g, c, N, constraints); con3(g, c, N, constraints)];
end
function [y] = con1(g, c, N)
% equality constraints
[Aeq_g, beq_g] = linear_constraints_eq(N, 'g');
[Aeq_c, beq_c] = linear_constraints_eq(N, 'c');
% a column vector, need to be unrolled in function c
y = [Aeq_g * g - beq_g; Aeq_c * c - beq_c];
end
function [y] = con2(g, c, N, constraints)
y = rho(g, c, N) - constraints.rho0;
end
function [y] = con3(g, c, N, constraints)
y = tau(g, c, N) - constraints.tau0;
end
function [g, c] = get_gc(x, N)
% make sure that x is column vector
x = reshape(x, [], 1);
g = x(1:N*N);
c = x((N*N+1):end);
end
