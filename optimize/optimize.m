function [g_opt, c_opt, f_opt, flag_opt, history_opt] = optimize(N, constraints, f_opt_prior, algorithm)
N_init = 4;
g_opt = zeros(N*N, N_init);
c_opt = zeros(N, N_init);
f_opt = zeros(1, N_init);
flag_opt = zeros(1, N_init);
history_opt = cell(1, N_init);
for i = 1:N_init
    if strcmp(algorithm, 'baseline')
        [g, c, f, flag, history] = optimize_baseline(N, constraints, f_opt_prior);
    elseif strcmp(algorithm, 'alter')
        [g, c, f, flag, history] = optimize_alter(N, constraints, f_opt_prior);
    elseif strcmp(algorithm, 'ga')
        [g, c, f, flag, history] = optimize_ga(N, constraints, f_opt_prior);
    else
        [g, c, f, flag, history] = optimize_al(N, constraints, f_opt_prior);
    end
    g_opt(:, i) = g;
    c_opt(:, i) = c;
    f_opt(:, i) = f(end);
    flag_opt(:, i) = flag; 
    history_opt{i} = history;
end
idx = find(flag_opt > 0);
if ~isempty(idx)
    [f_opt, idx] = min(f_opt);
    g_opt = g_opt(:, idx);
    c_opt = c_opt(:, idx);
    flag_opt = flag_opt(:, idx);
    history_opt = history_opt(idx);
    return
end
f_opt = f_opt(:, end);
g_opt = g_opt(:, end);
c_opt = c_opt(:, end);
flag_opt = -1;
history_opt = history_opt(end);
end
