function [g, c] = initialize(N, constraints, uniform_partition)
if nargin < 3
    uniform_partition = false;
end
max_iter = 1e5;
while true
    if uniform_partition
        c = ones(N, 1);
    else
        c = rand(N, 1);
    end
    c = c./sum(c); % normalize c is trivial
    iter = 0;
    while iter < max_iter
        g = rand(N);
        g = (g + g')/2;
        g = reshape(g, [], 1);
        [g, c] = rescale(g, c, N, constraints.rho0, constraints.tau0);
        if (~isnan(sum(g)))
            return
        end
        iter = iter+1;
    end
end
end
