function [t] = tau(g, c, N)
% [t] = tau(g, c, N) calculates the triangle density 
% for a given graphon g with partition c
% p = $\sum_{1\leq i, j, k \leq N}g_{ij}g_{jk}g_{ki}c_ic_jc_k$
% g: a column vector of size NxN
% c: a column vector of size N
% N: dimension of problem
t = 0.0;
for i = 1:N
    for j = 1:N
        for k = 1:N
            t = t + g(sub2ind([N, N], i, j))*g(sub2ind([N, N], j, k))*g(sub2ind([N, N], k, i))*c(i)*c(j)*c(k);
        end
    end
end
end
