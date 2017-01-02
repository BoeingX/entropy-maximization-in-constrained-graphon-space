function [g, c, flag] = initialize(N, constraints, N_init)
for i = 1:N_init
    c = rand(N, 1);
    c = c ./ sum(c);
    [g, flag] = solve_g_known_c(c, N, constraints);
    if flag >= 1
        disp('[INFO] Feasible initial point found!')
        return
    end
end
for i = 1:N_init
    g = rand(N);
    g = (g + g')/2;
    g = reshape(g, [], 1);
    [c, flag] = solve_c_known_g(g, N, constraints);
    if flag >= 1
        disp('[INFO] Feasible initial point found!')
        return
    end
end
end
