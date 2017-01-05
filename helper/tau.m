function [t] = tau(g, c, N)
% [t] = tau(g, c, N) calculates the triangle density 
% for a given graphon g with partition c
% p = $\sum_{1\leq i, j, k \leq N}g_{ij}g_{jk}g_{ki}c_ic_jc_k$
% g: a column vector of size NxN
% c: a column vector of size N
% N: dimension of problem
g = reshape(g, [], N);
t = trace((g*diag(c))^3);
end
