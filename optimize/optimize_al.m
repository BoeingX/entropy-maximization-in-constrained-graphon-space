function [g, c, f, flag] = optimize_al(N, constraints, f_opt_prior, algorithm)
if nargin < 4
    algorithm = 'al';
end
n_constraints = N*(N-1)/2 + 3;
nvars = N*N + N;
lb = zeros(nvars, 1);
ub = ones(nvars, 1);
% options = optimoptions('fmincon','Algorithm', 'interior-point', 'Display', 'off', 'TolCon', 1e-8);
if strcmp(algorithm, 'al')
    x = rand(nvars, 1);
    y = rand(n_constraints, 1);
    lambda_k = 10;
    eta = 1e-8;
    eta_0 = 1e-1;
    eta_k = 1e-1;
    w = 1e-10;
    converged = false;
    alpha = 0.5;
    beta = 0.5;
    t = 10;
    % equality constraints
    [Aeq_g, beq_g] = linear_constraints_eq(N, 'g');
    [Aeq_c, beq_c] = linear_constraints_eq(N, 'c'); 
    [n11, n12] = size(Aeq_g);
    [n21, n22] = size(Aeq_c);
    Aeq = [Aeq_g, zeros(n11, n22); zeros(n21, n12), Aeq_c];
    beq = [beq_g; beq_c];
    while ~converged
%         func = @(u) entropy(u(1:N*N), u((N*N+1):end), N) ...
%                 - y' * con(u, N ,constraints, Aeq, beq) + 0.5*lambda_k*((norm(con(u, N, constraints, Aeq, beq)))^2);
%         grad = @(u) entropy_grad(u(1:N*N), u((N*N+1):end), N) ...
%             - y' * con_grad(u, N, Aeq) + lambda_k*con(u, N, constraints, Aeq, beq)'*con_grad(u, N, Aeq);
        func_grad = @(u) compute_func_grad(u, y, lambda_k, N, constraints, Aeq, beq);
        options = optimoptions('fmincon','Algorithm', 'interior-point', 'Display', 'off', 'TolFun', w, 'GradObj','on');
        [x_opt, L, flag, ~, ~, z_opt, ~] = fmincon(func_grad, x, [], [], [], [], lb, ub, [], options);
        if norm(con(x_opt, N ,constraints, Aeq, beq)) < max(eta, eta_k)
            y_opt = y - lambda_k*con(x, N, constraints, Aeq, beq);
            x = x_opt;
            y = y_opt;
            z = z_opt;
            if norm(abs(con(x, N, constraints, Aeq, beq))) < eta && (isempty(find(x < 0))) ...
                & (isempty(find(x > 1)))
                converged = true;
            end
            eta_k = eta_k / (1 + lambda_k^beta);
        else
            lambda_k = lambda_k * t;
            eta_k = eta_0 / (1 + lambda_k^alpha);
        end
    end
    lambda_k
    [g, c] = get_gc(x, N);
    f = entropy(g, c, N);
    flag = 1;
end
end

function [obj, grad] = compute_func_grad(u, y, lambda_k, N, constraints, Aeq, beq)
obj = entropy(u(1:N*N), u((N*N+1):end), N) ...
     - y' * con(u, N ,constraints, Aeq, beq) + 0.5*lambda_k*((norm(con(u, N, constraints, Aeq, beq)))^2);
grad = entropy_grad(u(1:N*N), u((N*N+1):end), N) ...
     - con_grad(u, N, Aeq)*y + lambda_k*con_grad(u, N, Aeq)*con(u, N, constraints, Aeq, beq);
end

function [y] = con_grad(u, N, Aeq)
[g, c] = get_gc(u, N);
y = [linear_constraints_grad(Aeq, N)', rho_grad(g, c, N), tau_grad(g, c, N)];
end

function [y] = con(x, N, constraints, Aeq, beq)
[g, c] = get_gc(x, N);
y = [con1(Aeq, beq, x); con2(g, c, N, constraints); con3(g, c, N, constraints)];
end
function [y] = con1(Aeq, beq, x)
% a column vector, need to be unrolled in function c
y = Aeq*x-beq;
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
