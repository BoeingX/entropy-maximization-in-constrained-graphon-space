function [g, c] = rescale(g, c, N, rho0, tau0)
% [g, c] = rescale(g, c, N) rescales g and c 
% to satisfy the edge and triangle densities rho0 and tau0
% g: a column vector of size NxN
% c: a column vector of size N
% N: dimension of problem

% normalize g by g' = alpha*g + beta
% which consists of solving a nonlinear system
% of alpha and beta
% A1 * alpha + A2 * beta = rho_0
% B1*alpha^3+B2*alpha^2*beta+B3*alpha*beta^2+B4*beta^3 = tau_0
% where As and Bs are constants depending on g and c

A1 = rho(g, c, N);
A2 = sum(sum(c*c'));

B1 = 0.0;
B2 = 0.0;
B3 = 0.0;
B4 = 0.0;
for i = 1:N
    for j = 1:N
        for k = 1:N
            cijk = c(i)*c(j)*c(k);
            B1 = B1 + g(sub2ind([N, N], i, j))*g(sub2ind([N, N], j, k))*g(sub2ind([N, N], k, i)) * cijk;
            B2 = B2 + (g(sub2ind([N, N], i, j))*g(sub2ind([N, N], j, k)) + g(sub2ind([N, N], j, k))*g(sub2ind([N, N], k, i)) + g(sub2ind([N, N], k, i))*g(sub2ind([N, N], i, j)))*cijk;
            B3 = B3 + (g(sub2ind([N, N], i, j))+g(sub2ind([N, N], j, k))+g(sub2ind([N, N], k, i))) * cijk;
            B4 = B4 + cijk;
        end
    end
end
syms a b;
[alpha, beta] = vpasolve([A1*a + A2*b == rho0; B1*a^3+B2*a^2*b+B3*a*b^2+B4*b^3 == tau0;], [a, b]);
if isreal(alpha(1))
    alpha_ = alpha(1);
    beta_ = beta(1);
    g = double(alpha_ * g + beta_);
    if sum(g>1) == 0 && sum(g<0) == 0 
        return
    end
end
if isreal(alpha(2))
    alpha_ = alpha(2);
    beta_ = beta(2);
    g = double(alpha_ * g + beta_);
    if sum(g>1) == 0 && sum(g<0) == 0 
        return
    end
end
if isreal(alpha(3))
    alpha_ = alpha(3);
    beta_ = beta(3);
    g = double(alpha_ * g + beta_);
    if sum(g>1) == 0 && sum(g<0) == 0 
        return
    end
end
alpha_ = NaN;
beta_ = NaN;
g = double(alpha_ * g + beta_);
end
