function [g, c, f, flag] = optimize_alter(N, constraints, f_opt_prior)
tol = 1e-6;
[g, c, flag] = initialize(N, constraints);
if flag < 0
    f = Inf
    return
end
fs = [Inf];
retry = 0; 
max_retry = 10;
while retry < max_retry
    while true
        [c, f] = optimize_c(g, c, N, constraints);
        [g, f] = optimize_g(g, c, N, constraints);
        if abs(f - fs(end)) < tol
            disp('[INFO] iteration stopped')
            % convergence
            break
        end
        fs = [fs, f];
    end
    % check constraints
    [cueq, ceq] = nonlinear_constraints(g, c, N, constraints);
    if (f(end) > f_opt_prior) 
        disp('[WARNING] worse than prior... restart')
        [g, c] = initialize(N, constraints);
        fs = [Inf];
    elseif (norm(abs(ceq)) > tol)
        disp('[WARNING] violating constraints... restart')
        [g, c] = initialize(N, constraints);
        fs = [Inf];
    else
        disp('[INFO] converged')
        return
    end
    retry = retry + 1;
end
end

function [g_opt, f_opt] = optimize_g(g, c, N, constraints)
% fix c, optimize g
fung = @(x)entropy(x, c, N);

% characterize a symmetric matrix
% by a linear system Aeq * g = 0 := beq
[Aeq, beq] = linear_constraints_eq(N, 'g');
lb = zeros(size(g));
ub = ones(size(g));

options = optimoptions('fmincon','Algorithm', 'sqp', 'Display', 'off', 'ConstraintTolerance', 1e-10);

nonlcong = @(x)nonlinear_constraints(x, c, N, constraints);
[g_opt, f_opt] = fmincon(fung, g, [], [], Aeq, beq, lb, ub, nonlcong, options);
end

function [c_opt, f_opt] = optimize_c(g, c, N, constraints)
func = @(x)entropy(g, x, N);
options = optimoptions('fmincon','Algorithm', 'sqp', 'Display', 'off', 'ConstraintTolerance', 1e-10);
[Aeq, beq] = linear_constraints_eq(N, 'c');
lb = zeros(size(c));
ub = ones(size(c));
nonlconc = @(x)nonlinear_constraints(g, x, N, constraints);
[c_opt, f_opt] = fmincon(func, c, [], [], Aeq, beq, lb, ub, nonlconc, options);
end
