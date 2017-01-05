function [ g, c, f, flag ] = AL( N, constraints )
%AL augmented Lagrangian to solve the problem
%   Detailed explanation goes here

func = @(x)entropy(x(1:N*N)', x((N*N+1):end)', N);
nvars = N*N + N;

% create problem
problem.fitnessfcn = func;
problem.nvars = nvars;
problem.Aineq = [];
problem.Bineq = [];
[Aeq_g, beq_g] = linear_constraints_eq(N, 'g');
[Aeq_c, beq_c] = linear_constraints_eq(N, 'c');
[n11, n12] = size(Aeq_g);
[n21, n22] = size(Aeq_c);
Aeq = [Aeq_g, zeros(n11, n22); zeros(n21, n12), Aeq_c];
Beq = [beq_g; beq_c];
problem.Aeq = Aeq;
problem.Beq = Beq;
problem.lb = zeros(1, nvars);
problem.ub = ones(1, nvars);
problem.nonlcon = @(x)nonlinear_constraints(x(1:N*N)', x((N*N+1):end)', N, constraints);
problem.solver = 'ga';
options = gaoptimset('InitialPenalty', 1e10, 'Display', 'iter', 'NonlinConAlgorithm', 'penalty', 'TolCon', 1e-10);
problem.options = options;
[x, f, flag] = ga(problem);
g = x(1:N*N);
c = x((N*N+1):end);
end

