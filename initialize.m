function [g, c] = initialize_single(N, constraints)
c = rand(N, 1);
c = c ./ sum(c);
g = solve_g_known_c(c, N, constraints);
end
