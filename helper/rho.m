function [p] = rho(g, c, N)
% [p] = rho(g, c) calculates the edge density for a given graphon g with partition c
% p = $\sum_{1\leq i, j \leq N}g_{ij}c_ic_j$
% g: a column vector of size NxN
% c: a column vector of size N
% N: dimension of problem

g = reshape(g, N, []); %convert g to a square matrix
p = c'*g*c;
end
