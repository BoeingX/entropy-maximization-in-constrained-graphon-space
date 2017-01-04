function [g_opt, c_opt, f_opt, flag] = optimize(N, constraints, f_opt_prior)
N_fold = 3;
g_opt = zeros(N*N, N_fold);
c_opt = zeros(N, N_fold);
f_opt = zeros(1, N_fold);
for i = 1:N_fold
    [g, c, f, flag] = optimize_single(N, constraints, f_opt_prior);
    g_opt(:, i) = g;
    c_opt(:, i) = c;
    f_opt(:, i) = f(end);
    if flag < 0
        % no convergence
        f_opt(:, i) = inf;
    end
    f_opt_prior = min(f_opt);
end
[f_opt, I] = min(f_opt);
g_opt = g_opt(:, I);
c_opt = c_opt(:, I);
end

function [g, c, f, flag] = optimize_single(N, constraints, f_opt_prior)
tol = 1e-6;
[g, c, flag] = initialize(N, constraints);
if flag < 0
    f = Inf
    return
end
fs = [Inf];
retry = 0; 
max_retry = 100;
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
    elseif (norm(abs(ceq)) > 1e-10)
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
