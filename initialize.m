function [g, c] = initialize(N, constraints, uniform_partition)
if nargin < 3
    uniform_partition = false;
end
while true
    if uniform_partition
        c = ones(N, 1) / N;
    else
        c = rand(N, 1);
    end
    g = rand(N);
    g = (g + g')/2;
    g = reshape(g, [], 1);
    [g, c] = rescale(g, c, N, constraints.rho0, constraints.tau0);
    if sum(g>1) == 0 && sum(g<0) == 0 && sum(abs(g-1/2)<1e-3) ~= N*N
        return
    end
end
end
