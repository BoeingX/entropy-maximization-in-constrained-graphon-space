function [g, c, f, exit_flag] = optimize_direct(N, constraints)
g = rand(N*N, 1);
c = rand(N, 1);
x = [g; c];
options = optimoptions('fmincon','Display', 'off', 'MaxFunctionEvaluation', 1e5, 'MaxIterations', 1e5, 'ConstraintTolerance', 1e-20);
func = @(x)entropy(x(1:N*N), x(N*N+1:end), N);
[Aeq_g, beq_g] = linear_constraints_eq(N, 'g');
[Aeq_c, beq_c] = linear_constraints_eq(N, 'c');
Aeq = [Aeq_g, zeros(size(Aeq_c)); zeros(size(Aeq_g)), Aeq_c];
beq = [beq_g; beq_c];
lb = zeros(size(x));
ub = ones(size(x));
nonlcon = @(x)nonlinear_constraints(x(1:N*N), x(N*N+1:end), N, constraints);
[x, f, exit_flag] = fmincon(func, x, [], [], Aeq, beq, lb, ub, nonlcon, options);
g = x(1:N*N);
c = x(N*N+1, end);
end
