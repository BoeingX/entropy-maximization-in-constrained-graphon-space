function [H] = entropy(g, c, N)
% [H] = entropy(g, c, N) calculate the (opposite) entropy
% of a given graphon g with partition c
% g: a column vector of size NxN
% c: a column vector of size N
% N: dimension of problem
g = reshape(g, N, []); %convert g to a square matrix
H = c'*I(g)*c;
end
